import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestBooleanHelper with BooleanValueMixin {}

void main() {
  late TestBooleanHelper helper;

  setUp(() {
    helper = TestBooleanHelper();
  });

  group('BooleanValueMixin', () {
    group('getInitialOrSelectedValue', () {
      test('should return selected value when response exists', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'consent',
          'answer': [
            {
              'valueBoolean': true,
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'consent',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isTrue,
        );
      });

      test('should return false when response is false', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'consent',
          'answer': [
            {
              'valueBoolean': false,
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'consent',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isFalse,
        );
      });

      test('should return initial value when no response', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'terms',
          'type': 'boolean',
          'initial': [
            {
              'valueBoolean': true,
            },
          ],
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isTrue,
        );
      });

      test('should return false initial value when specified', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'terms',
          'type': 'boolean',
          'initial': [
            {
              'valueBoolean': false,
            },
          ],
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isFalse,
        );
      });

      test('should prioritize response over initial value', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'consent',
          'answer': [
            {
              'valueBoolean': false,
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'consent',
          'type': 'boolean',
          'initial': [
            {
              'valueBoolean': true,
            },
          ],
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isFalse,
        );
      });

      test('should return null when no response and no initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'optional',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isNull,
        );
      });

      test('should return null for null response with no initial', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isNull,
        );
      });

      test('should return null when response has empty answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'consent',
          'answer': [],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'consent',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isNull,
        );
      });

      test('should return null when response has no answer field', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'consent',
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'consent',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isNull,
        );
      });

      test('should handle initial with empty list', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'boolean',
          'initial': [],
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isNull,
        );
      });

      test('should return null when initial contains non-boolean value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'boolean',
          'initial': [
            {
              'valueString': 'not a boolean',
            },
          ],
        });

        expect(
          helper.getInitialOrSelectedValue(null, questionnaireItem),
          isNull,
        );
      });

      test('should use first answer when multiple answers exist', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'multi',
          'answer': [
            {
              'valueBoolean': true,
            },
            {
              'valueBoolean': false,
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'multi',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isTrue,
        );
      });

      test('should handle response with null answer valueBoolean', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
          'answer': [
            {
              'valueInteger': 123, // Wrong type
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'boolean',
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isNull,
        );
      });

      test('should fallback to initial when response answer is wrong type', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
          'answer': [
            {
              'valueString': 'text',
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'boolean',
          'initial': [
            {
              'valueBoolean': true,
            },
          ],
        });

        expect(
          helper.getInitialOrSelectedValue(responseItem, questionnaireItem),
          isTrue,
        );
      });
    });
  });
}
