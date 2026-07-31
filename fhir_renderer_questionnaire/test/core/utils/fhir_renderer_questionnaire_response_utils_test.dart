import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

void main() {
  group('FhirRendererQuestionnaireResponseUtils', () {
    group('findIsolatedItemByLinkId', () {
      test('should find item at root level', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(valueX: FhirString('answer1')),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [
                QuestionnaireResponseAnswer(valueX: FhirString('answer2')),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils.findIsolatedItemByLinkId(
          response,
          'q1',
        );

        expect(result, isNotNull);
        expect(result!.linkId.valueString, equals('q1'));
      });

      test('should find nested item in groups', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('group1'),
              item: [
                QuestionnaireResponseItem(
                  linkId: FhirString('nested_q1'),
                  answer: [
                    QuestionnaireResponseAnswer(valueX: FhirString('nested_answer')),
                  ],
                ),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils.findIsolatedItemByLinkId(
          response,
          'nested_q1',
        );

        expect(result, isNotNull);
        expect(result!.linkId.valueString, equals('nested_q1'));
      });

      test('should return null when item not found', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('q1')),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils.findIsolatedItemByLinkId(
          response,
          'nonexistent',
        );

        expect(result, isNull);
      });
    });

    group('findIsolatedItem', () {
      test('should handle null linkId', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('q1')),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
          response,
          null,
        );

        expect(result, isNull);
      });
    });

    group('setResponseAnswerInQuestionnaireResponse', () {
      test('should set string answer for existing item', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('q1')),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('q1'),
          type: QuestionnaireItemType.string,
        );

        final answer = QuestionnaireResponseAnswer(
          valueX: FhirString('test answer'),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'q1',
        );
        expect(item?.answer?.first.valueString?.valueString, equals('test answer'));
      });

      test('should handle integer answers', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('age')),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('age'),
          type: QuestionnaireItemType.integer,
        );

        final answer = QuestionnaireResponseAnswer(
          valueX: FhirInteger(25),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'age',
        );
        expect(item?.answer?.first.valueInteger, equals(FhirInteger(25)));
      });

      test('should handle decimal answers', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('weight')),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('weight'),
          type: QuestionnaireItemType.decimal,
        );

        final answer = QuestionnaireResponseAnswer(
          valueX: FhirDecimal(75.5),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'weight',
        );
        expect(item?.answer?.first.valueDecimal, equals(FhirDecimal(75.5)));
      });

      test('should handle boolean answers', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('consent')),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('consent'),
          type: QuestionnaireItemType.boolean,
        );

        final answer = QuestionnaireResponseAnswer(
          valueX: FhirBoolean(true),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'consent',
        );
        expect(item?.answer?.first.valueBoolean, equals(FhirBoolean(true)));
      });
    });

    group('setAnswerOptionInQuestionnaireResponse', () {
      test('should set coding answer from answer option', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: FhirString('gender')),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('gender'),
          type: QuestionnaireItemType.choice,
        );

        final answerOption = QuestionnaireAnswerOption(
          valueX: Coding(
            code: FhirCode('male'),
            display: FhirString('Male'),
          ),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setAnswerOptionInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'gender',
        );
        expect(item?.answer?.first.valueCoding?.code?.valueString, equals('male'));
      });
    });

    group('setMultipleAnswerOptionsInQuestionnaireResponse', () {
      test('should add option to existing selections', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('hobbies'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('reading')),
                ),
              ],
            ),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('hobbies'),
          type: QuestionnaireItemType.choice,
          repeats: FhirBoolean(true),
        );

        final answerOption = QuestionnaireAnswerOption(
          valueX: Coding(code: FhirCode('sports')),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'hobbies',
        );
        expect(item?.answer?.length, equals(2));
      });

      test('should remove option if already selected (toggle behavior)', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('hobbies'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('reading')),
                ),
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('sports')),
                ),
              ],
            ),
          ],
        );

        final questionnaireItem = QuestionnaireItem(
          linkId: FhirString('hobbies'),
          type: QuestionnaireItemType.choice,
          repeats: FhirBoolean(true),
        );

        final answerOption = QuestionnaireAnswerOption(
          valueX: Coding(code: FhirCode('sports')),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'hobbies',
        );
        expect(item?.answer?.length, equals(1));
        expect(item?.answer?.first.valueCoding?.code?.valueString, equals('reading'));
      });

      // An "all"/"none" master option carries the FHIR SDC
      // questionnaire-optionExclusive extension. Selecting it must clear every
      // other choice, and selecting a normal option must clear it.
      QuestionnaireItem buildExclusiveItem() => QuestionnaireItem.fromJson({
            'linkId': 'symptoms',
            'type': 'choice',
            'repeats': true,
            'answerOption': [
              {
                'valueCoding': {'code': 'cough'},
              },
              {
                'valueCoding': {'code': 'fever'},
              },
              {
                'extension': [
                  {
                    'url':
                        'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
                    'valueBoolean': true,
                  },
                ],
                'valueCoding': {'code': 'none'},
              },
            ],
          });

      QuestionnaireAnswerOption optionFor(
        QuestionnaireItem item,
        String code,
      ) =>
          item.answerOption!.firstWhere(
            (o) => o.valueCoding?.code?.valueString == code,
          );

      test('selecting an exclusive option clears all other selections', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('symptoms'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('cough')),
                ),
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('fever')),
                ),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          optionFor(questionnaireItem, 'none'),
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'symptoms',
        );
        expect(item?.answer?.length, equals(1));
        expect(
          item?.answer?.first.valueCoding?.code?.valueString,
          equals('none'),
        );
      });

      test('selecting a normal option clears any exclusive selection', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('symptoms'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('none')),
                ),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          optionFor(questionnaireItem, 'cough'),
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'symptoms',
        );
        expect(item?.answer?.length, equals(1));
        expect(
          item?.answer?.first.valueCoding?.code?.valueString,
          equals('cough'),
        );
      });

      test('exclusive option still toggles off when reselected', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('symptoms'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(code: FhirCode('none')),
                ),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          optionFor(questionnaireItem, 'none'),
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId.valueString == 'symptoms',
        );
        expect(item?.answer?.isEmpty, isTrue);
      });
    });

    group('generateInitialQuestionnaireResponse', () {
      test('should generate response from questionnaire', () {
        final questionnaire = Questionnaire(
          status: PublicationStatus.active,
          item: [
            QuestionnaireItem(
              linkId: FhirString('name'),
              type: QuestionnaireItemType.string,
            ),
            QuestionnaireItem(
              linkId: FhirString('age'),
              type: QuestionnaireItemType.integer,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .generateInitialQuestionnaireResponse(questionnaire);

        expect(result.status, equals(QuestionnaireResponseStatus.inProgress));
        expect(result.item?.length, equals(2));
      });

      test('should handle nested group items', () {
        final questionnaire = Questionnaire(
          status: PublicationStatus.active,
          item: [
            QuestionnaireItem(
              linkId: FhirString('demographics'),
              type: QuestionnaireItemType.group,
              item: [
                QuestionnaireItem(
                  linkId: FhirString('name'),
                  type: QuestionnaireItemType.string,
                ),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .generateInitialQuestionnaireResponse(questionnaire);

        expect(result.item?.length, equals(1));

        final group = result.item?.first;
        expect(group?.linkId.valueString, equals('demographics'));
        expect(group?.item?.length, equals(1));

        final nestedItem = group?.item?.first;
        expect(nestedItem?.linkId.valueString, equals('name'));
      });
    });

    group('generateAnswers', () {
      test('should generate answers from initial string value', () {
        final item = QuestionnaireItem(
          linkId: FhirString('name'),
          type: QuestionnaireItemType.string,
          initial: [
            QuestionnaireInitial(valueX: FhirString('John Doe')),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueString?.valueString, equals('John Doe'));
      });

      test('should generate answers from initial integer value', () {
        final item = QuestionnaireItem(
          linkId: FhirString('age'),
          type: QuestionnaireItemType.integer,
          initial: [
            QuestionnaireInitial(valueX: FhirInteger(30)),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueInteger, equals(FhirInteger(30)));
      });

      test('should generate answers from initial boolean value', () {
        final item = QuestionnaireItem(
          linkId: FhirString('consent'),
          type: QuestionnaireItemType.boolean,
          initial: [
            QuestionnaireInitial(valueX: FhirBoolean(true)),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueBoolean, equals(FhirBoolean(true)));
      });

      test('should generate answers from initial coding value', () {
        final item = QuestionnaireItem(
          linkId: FhirString('gender'),
          type: QuestionnaireItemType.choice,
          initial: [
            QuestionnaireInitial(
              valueX: Coding(
                code: FhirCode('female'),
                display: FhirString('Female'),
              ),
            ),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueCoding?.code?.valueString, equals('female'));
      });

      test('should return null for item without initial value', () {
        final item = QuestionnaireItem(
          linkId: FhirString('empty'),
          type: QuestionnaireItemType.string,
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNull);
      });

      test('should return null for display item', () {
        final item = QuestionnaireItem(
          linkId: FhirString('info'),
          type: QuestionnaireItemType.display_,
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNull);
      });
    });
  });
}
