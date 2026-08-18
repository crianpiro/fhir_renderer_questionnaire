import 'package:flutter_test/flutter_test.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';

void main() {
  group('QuestionnaireResponse.fromJson', () {
    test('reads status, questionnaire link and nested answers', () {
      final response = QuestionnaireResponse.fromJson(const {
        'resourceType': 'QuestionnaireResponse',
        'questionnaire': 'Questionnaire/demographics',
        'status': 'in-progress',
        'subject': {'reference': 'Patient/123', 'display': 'Jane Roe'},
        'item': [
          {
            'linkId': 'group',
            'item': [
              {
                'linkId': 'name',
                'text': 'Full name',
                'answer': [
                  {'valueString': 'Jane Roe'},
                ],
              },
            ],
          },
        ],
      });

      expect(response.status, QuestionnaireResponseStatus.inProgress);
      expect(response.questionnaire, 'Questionnaire/demographics');
      expect(response.subject?.reference, 'Patient/123');

      final nested = response.item!.single.item!.single;
      expect(nested.linkId, 'name');
      expect(nested.answer!.single.valueString, 'Jane Roe');
    });

    test('exposes whichever value[x] is set through `value`', () {
      QuestionnaireResponseAnswer parse(Map<String, Object?> json) =>
          QuestionnaireResponseAnswer.fromJson(json);

      expect(parse(const {'valueString': 'x'}).value, 'x');
      expect(parse(const {'valueBoolean': true}).value, true);
      expect(parse(const {'valueInteger': 7}).value, 7);
      expect(parse(const {'valueDecimal': 1.5}).value, 1.5);
      expect(parse(const {'valueDate': '2024-03'}).value, const FhirDate('2024-03'));
      expect(parse(const {'valueTime': '09:30:00'}).value, const FhirTime('09:30:00'));
      expect(
        parse(const {
          'valueCoding': {'code': 'red'},
        }).value,
        const Coding(code: 'red'),
      );
      expect(parse(const {}).value, isNull);
      expect(parse(const {}).isEmpty, isTrue);
    });

    test('parses an attachment answer', () {
      final answer = QuestionnaireResponseAnswer.fromJson(const {
        'valueAttachment': {
          'contentType': 'application/pdf',
          'title': 'Referral.pdf',
          'size': 2048,
          'data': 'YmFzZTY0',
        },
      });

      expect(answer.valueAttachment?.contentType, 'application/pdf');
      expect(answer.valueAttachment?.title, 'Referral.pdf');
      expect(answer.valueAttachment?.size, 2048);
      expect(answer.valueAttachment?.data, 'YmFzZTY0');
    });
  });

  group('round-trip', () {
    test('preserves unmodelled fields on the response and its items', () {
      const source = {
        'resourceType': 'QuestionnaireResponse',
        'id': 'r1',
        'questionnaire': 'Questionnaire/q1',
        'status': 'completed',
        'meta': {'versionId': '3', 'lastUpdated': '2024-03-15T10:30:00Z'},
        'encounter': {'reference': 'Encounter/456'},
        'item': [
          {
            'linkId': 'a',
            'answer': [
              {
                'valueString': 'yes',
                'id': 'answer-1',
              },
            ],
          },
        ],
      };

      expect(QuestionnaireResponse.fromJson(source).toJson(), equals(source));
    });

    test('preserves a decimal answer written as an integer', () {
      const source = {
        'resourceType': 'QuestionnaireResponse',
        'status': 'completed',
        'item': [
          {
            'linkId': 'score',
            'answer': [
              {'valueDecimal': 3},
            ],
          },
        ],
      };

      final parsed = QuestionnaireResponse.fromJson(source);
      expect(parsed.item!.single.answer!.single.valueDecimal, 3.0);
      expect(parsed.toJson(), equals(source));
    });

    test('survives a questionnaire -> response -> JSON cycle', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'id': 'q1',
        'status': 'active',
        'item': [
          {
            'linkId': 'agree',
            'text': 'Do you agree?',
            'type': 'boolean',
            'initial': [
              {'valueBoolean': true},
            ],
          },
        ],
      });

      final response = FhirRendererQuestionnaireResponseUtils
          .generateInitialQuestionnaireResponse(questionnaire);
      final json = response.toJson();

      expect(json['resourceType'], 'QuestionnaireResponse');
      expect(json['status'], 'in-progress');
      expect(json['questionnaire'], 'Questionnaire/q1');

      // And the JSON parses straight back into an equal response.
      expect(QuestionnaireResponse.fromJson(json), equals(response));
    });
  });

  group('equality', () {
    test('answers with the same value are equal', () {
      expect(
        QuestionnaireResponseAnswer(valueString: 'x'),
        QuestionnaireResponseAnswer(valueString: 'x'),
      );
      expect(
        QuestionnaireResponseAnswer(valueString: 'x').hashCode,
        QuestionnaireResponseAnswer(valueString: 'x').hashCode,
      );
    });

    test('the same value under a different variant is not equal', () {
      // 'true' as a string is not the boolean true.
      expect(
        QuestionnaireResponseAnswer(valueString: 'true'),
        isNot(QuestionnaireResponseAnswer(valueBoolean: true)),
      );
    });

    test('responses differing deep in the item tree are not equal', () {
      QuestionnaireResponse build(String answer) => QuestionnaireResponse(
            status: QuestionnaireResponseStatus.inProgress,
            item: [
              QuestionnaireResponseItem(
                linkId: 'group',
                item: [
                  QuestionnaireResponseItem(
                    linkId: 'name',
                    answer: [QuestionnaireResponseAnswer(valueString: answer)],
                  ),
                ],
              ),
            ],
          );

      expect(build('a'), equals(build('a')));
      expect(build('a'), isNot(equals(build('b'))));
    });
  });
}
