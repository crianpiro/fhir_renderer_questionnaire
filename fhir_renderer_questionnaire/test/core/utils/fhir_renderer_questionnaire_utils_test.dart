import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('yes'),
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(5),
                ),
              ],
            ),
          ],
        );

        // Create a questionnaire item with AND behavior (all conditions must be true)
        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableBehavior: EnableWhenBehavior('all'),
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('yes'),
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(3), // Different from expected value
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableBehavior: EnableWhenBehavior('all'),
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('yes'),
                ),
              ],
            ),
            // q2 has no answer
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableBehavior: EnableWhenBehavior('all'),
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('yes'),
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(3), // Different from expected
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          // No enableBehavior specified = defaults to "any" (OR logic)
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('no'),
                ),
              ],
            ),
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(3),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
              linkId: FhirString('q1'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('yes'),
                ),
              ],
            ),
            // q2 has no answer
            QuestionnaireResponseItem(
              linkId: FhirString('q2'),
              answer: [],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('q1'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('yes'),
            ),
            QuestionnaireEnableWhen(
              question: FhirString('q2'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirInteger(5),
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
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('no-conditions'),
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
        final response = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('empty-conditions'),
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
              linkId: FhirString('age'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(25),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('age'),
              operator_: QuestionnaireItemOperator.gt,
              answerX: FhirInteger(18),
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
              linkId: FhirString('age'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirInteger(18),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('age'),
              operator_: QuestionnaireItemOperator.le,
              answerX: FhirInteger(18),
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
              linkId: FhirString('temperature'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirDecimal(38.5),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('temperature'),
              operator_: QuestionnaireItemOperator.ge,
              answerX: FhirDecimal(37.5),
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
              linkId: FhirString('weight'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Quantity(
                    value: FhirDecimal(98.6),
                    unit: FhirString('kg'),
                  ),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('weight'),
              operator_: QuestionnaireItemOperator.gt,
              answerX: Quantity(
                value: FhirDecimal(90.0),
                unit: FhirString('kg'),
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
              linkId: FhirString('color'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('red'),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('color'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: FhirString('red'),
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
              linkId: FhirString('diagnosis'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: Coding(
                    system: FhirUri('http://snomed.info/sct'),
                    code: FhirCode('38341003'),
                  ),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('diagnosis'),
              operator_: QuestionnaireItemOperator.eq,
              answerX: Coding(
                system: FhirUri('http://snomed.info/sct'),
                code: FhirCode('38341003'),
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
              linkId: FhirString('status'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirString('active'),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('status'),
              operator_: QuestionnaireItemOperator.ne,
              answerX: FhirString('inactive'),
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
              linkId: FhirString('hasCondition'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirBoolean(true),
                ),
              ],
            ),
          ],
        );

        final item = QuestionnaireItem(
          linkId: FhirString('dependent'),
          type: QuestionnaireItemType.string,
          enableWhen: [
            QuestionnaireEnableWhen(
              question: FhirString('hasCondition'),
              operator_: QuestionnaireItemOperator.exists,
              answerX: FhirBoolean(true),
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
