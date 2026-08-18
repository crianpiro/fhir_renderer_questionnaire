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
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(valueString: 'answer1'),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [
                QuestionnaireResponseAnswer(valueString: 'answer2'),
              ],
            ),
          ],
        );

        final result = FhirRendererQuestionnaireResponseUtils.findIsolatedItemByLinkId(
          response,
          'q1',
        );

        expect(result, isNotNull);
        expect(result!.linkId, equals('q1'));
      });

      test('should find nested item in groups', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'group1',
              item: [
                QuestionnaireResponseItem(
                  linkId: 'nested_q1',
                  answer: [
                    QuestionnaireResponseAnswer(valueString: 'nested_answer'),
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
        expect(result!.linkId, equals('nested_q1'));
      });

      test('should return null when item not found', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'q1'),
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
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'q1'),
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
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'q1'),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'q1',
          type: QuestionnaireItemType.string,
        );

        final answer = QuestionnaireResponseAnswer(
          valueString: 'test answer',
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'q1',
        );
        expect(item?.answer?.first.valueString, equals('test answer'));
      });

      test('should handle integer answers', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'age'),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'age',
          type: QuestionnaireItemType.integer,
        );

        final answer = QuestionnaireResponseAnswer(
          valueInteger: 25,
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'age',
        );
        expect(item?.answer?.first.valueInteger, equals(25));
      });

      test('should handle decimal answers', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'weight'),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'weight',
          type: QuestionnaireItemType.decimal,
        );

        final answer = QuestionnaireResponseAnswer(
          valueDecimal: 75.5,
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'weight',
        );
        expect(item?.answer?.first.valueDecimal, equals(75.5));
      });

      test('should handle boolean answers', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'consent'),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'consent',
          type: QuestionnaireItemType.boolean,
        );

        final answer = QuestionnaireResponseAnswer(
          valueBoolean: true,
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          response,
          questionnaireItem,
          answer,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'consent',
        );
        expect(item?.answer?.first.valueBoolean, equals(true));
      });
    });

    group('setAnswerOptionInQuestionnaireResponse', () {
      test('should set coding answer from answer option', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(linkId: 'gender'),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'gender',
          type: QuestionnaireItemType.choice,
        );

        const answerOption = QuestionnaireAnswerOption(
          valueCoding: Coding(
            code: 'male',
            display: 'Male',
          ),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setAnswerOptionInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'gender',
        );
        expect(item?.answer?.first.valueCoding?.code, equals('male'));
      });
    });

    group('setMultipleAnswerOptionsInQuestionnaireResponse', () {
      test('should add option to existing selections', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'hobbies',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'reading'),
                ),
              ],
            ),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'hobbies',
          type: QuestionnaireItemType.choice,
          repeats: true,
        );

        const answerOption = QuestionnaireAnswerOption(
          valueCoding: Coding(code: 'sports'),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'hobbies',
        );
        expect(item?.answer?.length, equals(2));
      });

      test('should remove option if already selected (toggle behavior)', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'hobbies',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'reading'),
                ),
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'sports'),
                ),
              ],
            ),
          ],
        );

        const questionnaireItem = QuestionnaireItem(
          linkId: 'hobbies',
          type: QuestionnaireItemType.choice,
          repeats: true,
        );

        const answerOption = QuestionnaireAnswerOption(
          valueCoding: Coding(code: 'sports'),
        );

        final result = FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          response,
          questionnaireItem,
          answerOption,
        );

        final item = result.item?.firstWhere(
          (i) => i.linkId == 'hobbies',
        );
        expect(item?.answer?.length, equals(1));
        expect(item?.answer?.first.valueCoding?.code, equals('reading'));
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
            (o) => o.valueCoding?.code == code,
          );

      test('selecting an exclusive option clears all other selections', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'symptoms',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'cough'),
                ),
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'fever'),
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
          (i) => i.linkId == 'symptoms',
        );
        expect(item?.answer?.length, equals(1));
        expect(
          item?.answer?.first.valueCoding?.code,
          equals('none'),
        );
      });

      test('selecting a normal option clears any exclusive selection', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'symptoms',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'none'),
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
          (i) => i.linkId == 'symptoms',
        );
        expect(item?.answer?.length, equals(1));
        expect(
          item?.answer?.first.valueCoding?.code,
          equals('cough'),
        );
      });

      test('exclusive option still toggles off when reselected', () {
        final questionnaireItem = buildExclusiveItem();
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'symptoms',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(code: 'none'),
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
          (i) => i.linkId == 'symptoms',
        );
        expect(item?.answer?.isEmpty, isTrue);
      });
    });

    group('generateInitialQuestionnaireResponse', () {
      test('should generate response from questionnaire', () {
        const questionnaire = Questionnaire(
          status: QuestionnairePublicationStatus.active,
          item: [
            QuestionnaireItem(
              linkId: 'name',
              type: QuestionnaireItemType.string,
            ),
            QuestionnaireItem(
              linkId: 'age',
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
        const questionnaire = Questionnaire(
          status: QuestionnairePublicationStatus.active,
          item: [
            QuestionnaireItem(
              linkId: 'demographics',
              type: QuestionnaireItemType.group,
              item: [
                QuestionnaireItem(
                  linkId: 'name',
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
        expect(group?.linkId, equals('demographics'));
        expect(group?.item?.length, equals(1));

        final nestedItem = group?.item?.first;
        expect(nestedItem?.linkId, equals('name'));
      });
    });

    group('generateAnswers', () {
      test('should generate answers from initial string value', () {
        final item = QuestionnaireItem(
          linkId: 'name',
          type: QuestionnaireItemType.string,
          initial: [
            QuestionnaireInitial(valueString: 'John Doe'),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueString, equals('John Doe'));
      });

      test('should generate answers from initial integer value', () {
        final item = QuestionnaireItem(
          linkId: 'age',
          type: QuestionnaireItemType.integer,
          initial: [
            QuestionnaireInitial(valueInteger: 30),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueInteger, equals(30));
      });

      test('should generate answers from initial boolean value', () {
        final item = QuestionnaireItem(
          linkId: 'consent',
          type: QuestionnaireItemType.boolean,
          initial: [
            QuestionnaireInitial(valueBoolean: true),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueBoolean, equals(true));
      });

      test('should generate answers from initial coding value', () {
        final item = QuestionnaireItem(
          linkId: 'gender',
          type: QuestionnaireItemType.choice,
          initial: [
            QuestionnaireInitial(
              valueCoding: const Coding(
                code: 'female',
                display: 'Female',
              ),
            ),
          ],
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNotNull);
        expect(answers?.length, equals(1));
        expect(answers?.first.valueCoding?.code, equals('female'));
      });

      test('should return null for item without initial value', () {
        const item = QuestionnaireItem(
          linkId: 'empty',
          type: QuestionnaireItemType.string,
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNull);
      });

      test('should return null for display item', () {
        const item = QuestionnaireItem(
          linkId: 'info',
          type: QuestionnaireItemType.display_,
        );

        final answers = FhirRendererQuestionnaireResponseUtils.generateAnswers(item);

        expect(answers, isNull);
      });
    });
  });
}
