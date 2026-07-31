import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter_test/flutter_test.dart';

QuestionnaireItem _item(
  String linkId,
  QuestionnaireItemType type, {
  bool required = false,
  String? text,
  List<QuestionnaireItem>? children,
  List<QuestionnaireEnableWhen>? enableWhen,
  List<FhirExtension>? extension_,
}) =>
    QuestionnaireItem(
      linkId: FhirString(linkId),
      type: type,
      text: FhirString(text ?? linkId),
      required_: FhirBoolean(required),
      item: children,
      enableWhen: enableWhen,
      extension_: extension_,
    );

QuestionnaireResponse _response(Map<String, String> answers) =>
    QuestionnaireResponse(
      status: QuestionnaireResponseStatus.inProgress,
      item: answers.entries
          .map((e) => QuestionnaireResponseItem(
                linkId: FhirString(e.key),
                answer: [
                  QuestionnaireResponseAnswer(valueX: FhirString(e.value)),
                ],
              ))
          .toList(),
    );

void main() {
  const validator = QuestionnaireValidator();

  group('QuestionnaireValidator', () {
    test('reports required items with no answer', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _item('name', QuestionnaireItemType.string, required: true),
          _item('nickname', QuestionnaireItemType.string),
        ],
      );

      final findings =
          validator.validate(questionnaire, _response(const {}));

      expect(findings, hasLength(1));
      expect(findings.single.linkId, 'name');
      expect(findings.single.reason, QuestionnaireFindingReason.missingRequired);
    });

    test('accepts required items that have an answer', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [_item('name', QuestionnaireItemType.string, required: true)],
      );

      final findings =
          validator.validate(questionnaire, _response({'name': 'Ada'}));

      expect(findings, isEmpty);
    });

    test('reports answers that fail the regex extension', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _item(
            'code',
            QuestionnaireItemType.string,
            extension_: [
              FhirExtension(
                url:
                    FhirString('http://hl7.org/fhir/StructureDefinition/regex'),
                valueX: FhirString(r'^\d{3}$'),
              ),
            ],
          ),
        ],
      );

      final findings =
          validator.validate(questionnaire, _response({'code': 'abc'}));

      expect(findings, hasLength(1));
      expect(findings.single.reason, QuestionnaireFindingReason.invalidFormat);
      expect(findings.single.message, isNotNull);

      expect(
        validator.validate(questionnaire, _response({'code': '123'})),
        isEmpty,
      );
    });

    test('skips items disabled by enableWhen', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _item('trigger', QuestionnaireItemType.string),
          _item(
            'followUp',
            QuestionnaireItemType.string,
            required: true,
            enableWhen: [
              QuestionnaireEnableWhen(
                question: FhirString('trigger'),
                operator_: QuestionnaireItemOperator.eq,
                answerX: FhirString('yes'),
              ),
            ],
          ),
        ],
      );

      expect(
        validator.validate(questionnaire, _response({'trigger': 'no'})),
        isEmpty,
      );

      final enabled =
          validator.validate(questionnaire, _response({'trigger': 'yes'}));
      expect(enabled.single.linkId, 'followUp');
    });

    test('walks nested groups and records document position', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _item('intro', QuestionnaireItemType.display_),
          _item('outer', QuestionnaireItemType.group, children: [
            _item('first', QuestionnaireItemType.string),
            _item('inner', QuestionnaireItemType.group, children: [
              _item('deep', QuestionnaireItemType.string, required: true),
            ]),
          ]),
        ],
      );

      final findings =
          validator.validate(questionnaire, _response(const {}));

      expect(findings, hasLength(1));
      final finding = findings.single;
      expect(finding.linkId, 'deep');
      // intro(0) outer(1) first(2) inner(3) deep(4)
      expect(finding.documentOrder, 4);
      expect(finding.documentLength, 5);
      // Second top-level item, i.e. the second page in the page view renderer.
      expect(finding.topLevelIndex, 1);
      expect(finding.documentFraction, 1.0);
    });

    test('ignores groups and display items without answers', () {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _item('note', QuestionnaireItemType.display_, required: true),
          _item('section', QuestionnaireItemType.group, required: true),
        ],
      );

      expect(validator.validate(questionnaire, _response(const {})), isEmpty);
    });
  });
}
