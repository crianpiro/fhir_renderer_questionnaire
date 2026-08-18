import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

void main() {
  group('FhirRendererQuestionnaireUtils - EnableWhen Evaluation', () {
    group('AND Behavior ("all")', () {
      test('should enable item when all conditions are satisfied', () {
        // Create a questionnaire response with two answered questions
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'yes',
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 5,
                ),
              ],
            ),
          ],
        );

        // Create a questionnaire item with AND behavior (all conditions must be true)
        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableBehavior: QuestionnaireEnableBehavior.all,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when all conditions are satisfied');
      });

      test('should disable item when any condition fails', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'yes',
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 3, // Different from expected value
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableBehavior: QuestionnaireEnableBehavior.all,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isFalse, reason: 'Item should be disabled when any condition fails');
      });

      test('should disable item when referenced question has no answer', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'yes',
                ),
              ],
            ),
            // q2 has no answer
            const QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableBehavior: QuestionnaireEnableBehavior.all,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isFalse, reason: 'Item should be disabled when referenced question has no answer');
      });
    });

    group('OR Behavior ("any", default)', () {
      test('should enable item when any condition is satisfied', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'yes',
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 3, // Different from expected
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          // No enableBehavior specified = defaults to "any" (OR logic)
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when any condition is satisfied (OR logic)');
      });

      test('should disable item when all conditions fail', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'no',
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 3,
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isFalse, reason: 'Item should be disabled when all conditions fail');
      });

      test('should enable item when one condition matches and another has no answer', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'q1',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'yes',
                ),
              ],
            ),
            // q2 has no answer
            const QuestionnaireResponseItem(
              linkId: 'q2',
              answer: [],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'q1',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'yes',
            ),
            QuestionnaireEnableWhen(
              question: 'q2',
              operator_: QuestionnaireItemOperator.eq,
              answerInteger: 5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled with OR logic when at least one condition is satisfied');
      });
    });

    group('Edge Cases', () {
      test('should enable item when no enableWhen conditions exist', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [],
        );

        const item = QuestionnaireItem(
          linkId: 'no-conditions',
          type: QuestionnaireItemType.string,
          // No enableWhen conditions
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should always be enabled when no enableWhen conditions exist');
      });

      test('should enable item when enableWhen list is empty', () {
        const response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [],
        );

        const item = QuestionnaireItem(
          linkId: 'empty-conditions',
          type: QuestionnaireItemType.string,
          enableWhen: [], // Empty list
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when enableWhen list is empty');
      });
    });

    group('Numeric Comparisons', () {
      test('should handle greater than operator', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'age',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 25,
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'age',
              operator_: QuestionnaireItemOperator.gt,
              answerInteger: 18,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when numeric value is greater than threshold');
      });

      test('should handle less than or equal operator', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'age',
              answer: [
                QuestionnaireResponseAnswer(
                  valueInteger: 18,
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'age',
              operator_: QuestionnaireItemOperator.le,
              answerInteger: 18,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when numeric value is less than or equal to threshold');
      });

      test('should handle decimal comparisons', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'temperature',
              answer: [
                QuestionnaireResponseAnswer(
                  valueDecimal: 38.5,
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'temperature',
              operator_: QuestionnaireItemOperator.ge,
              answerDecimal: 37.5,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when decimal value meets condition');
      });

      test('should handle quantity decimal values', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'weight',
              answer: [
                QuestionnaireResponseAnswer(
                  valueQuantity: Quantity(
                    value: 98.6,
                    unit: 'kg',
                  ),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'weight',
              operator_: QuestionnaireItemOperator.gt,
              answerQuantity: Quantity(
                value: 90.0,
                unit: 'kg',
              ),
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when quantity decimal value meets condition');
      });
    });

    group('String and Coding Comparisons', () {
      test('should handle string equality', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'color',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'red',
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'color',
              operator_: QuestionnaireItemOperator.eq,
              answerString: 'red',
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when string values match');
      });

      test('should handle coding comparisons', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'diagnosis',
              answer: [
                QuestionnaireResponseAnswer(
                  valueCoding: const Coding(
                    system: 'http://snomed.info/sct',
                    code: '38341003',
                  ),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'diagnosis',
              operator_: QuestionnaireItemOperator.eq,
              answerCoding: const Coding(
                system: 'http://snomed.info/sct',
                code: '38341003',
              ),
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when coding values match');
      });

      test('should handle not equal operator', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'status',
              answer: [
                QuestionnaireResponseAnswer(
                  valueString: 'active',
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'status',
              operator_: QuestionnaireItemOperator.ne,
              answerString: 'inactive',
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when string values do not match');
      });
    });

    group('Boolean Exists Operator', () {
      test('should handle exists operator with true', () {
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: 'hasCondition',
              answer: [
                QuestionnaireResponseAnswer(
                  valueBoolean: true,
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: 'dependent',
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: 'hasCondition',
              operator_: QuestionnaireItemOperator.exists,
              answerBoolean: true,
            ),
          ],
        );

        final result = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
          response,
          item,
        );

        expect(result, isTrue, reason: 'Item should be enabled when exists condition is met');
      });
    });
  });
}
