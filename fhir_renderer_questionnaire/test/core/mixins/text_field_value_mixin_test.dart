import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestTextFieldHelper with TextFieldValueMixin {}

void main() {
  late TestTextFieldHelper helper;

  setUp(() {
    helper = TestTextFieldHelper();
  });

  group('TextFieldValueMixin', () {
    group('getInitialValue', () {
      test('should extract string initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
          'initial': [
            {
              'valueString': 'John Doe',
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('John Doe'));
      });

      test('should extract integer initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'age',
          'type': 'integer',
          'initial': [
            {
              'valueInteger': 25,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('25'));
      });

      test('should extract decimal initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'weight',
          'type': 'decimal',
          'initial': [
            {
              'valueDecimal': 72.5,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('72.5'));
      });

      test('should extract quantity initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'height',
          'type': 'quantity',
          'initial': [
            {
              'valueQuantity': {
                'value': 180.5,
                'unit': 'cm',
              },
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('180.5'));
      });

      test('should extract URI initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'website',
          'type': 'url',
          'initial': [
            {
              'valueUri': 'https://example.com',
            },
          ],
        });

        expect(
            helper.getInitialValue(questionnaireItem),
            equals('https://example.com'));
      });

      test('should return empty string when no initial value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
        });

        expect(helper.getInitialValue(questionnaireItem), equals(''));
      });

      test('should return empty string when initial list is empty', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
          'initial': [],
        });

        expect(helper.getInitialValue(questionnaireItem), equals(''));
      });

      test('should return empty string for unsupported value type', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'string',
          'initial': [
            {
              'valueBoolean': true,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals(''));
      });

      test('should use first value when multiple initial values', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'multi',
          'type': 'string',
          'initial': [
            {
              'valueString': 'first',
            },
            {
              'valueString': 'second',
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('first'));
      });

      test('should handle quantity with null value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'quantity',
          'initial': [
            {
              'valueQuantity': {
                'unit': 'kg',
              },
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals(''));
      });

      test('should extract negative integer value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'temperature',
          'type': 'integer',
          'initial': [
            {
              'valueInteger': -5,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('-5'));
      });

      test('should extract negative decimal value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'balance',
          'type': 'decimal',
          'initial': [
            {
              'valueDecimal': -123.45,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('-123.45'));
      });

      test('should extract zero integer value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'count',
          'type': 'integer',
          'initial': [
            {
              'valueInteger': 0,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('0'));
      });

      test('should extract zero decimal value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'score',
          'type': 'decimal',
          'initial': [
            {
              'valueDecimal': 0.0,
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals('0.0'));
      });

      test('should handle empty string value', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'note',
          'type': 'string',
          'initial': [
            {
              'valueString': '',
            },
          ],
        });

        expect(helper.getInitialValue(questionnaireItem), equals(''));
      });

      test('should handle string with spaces', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'fullName',
          'type': 'string',
          'initial': [
            {
              'valueString': '  John   Doe  ',
            },
          ],
        });

        expect(
            helper.getInitialValue(questionnaireItem),
            equals('  John   Doe  '));
      });
    });
  });
}
