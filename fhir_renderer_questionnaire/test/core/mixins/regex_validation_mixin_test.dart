import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestValidationHelper with RegexValidationMixin {}

void main() {
  late TestValidationHelper helper;

  setUp(() {
    helper = TestValidationHelper();
  });

  group('RegexValidationMixin', () {
    group('validateInput with custom patterns', () {
      test('should return null for valid input with custom pattern', () {
        final result = helper.validateInput(
          '555-1234',
          r'^\d{3}-\d{4}$',
          'Invalid phone format',
        );

        expect(result, isNull);
      });

      test('should return error message for invalid input with custom pattern', () {
        final result = helper.validateInput(
          'abc-defg',
          r'^\d{3}-\d{4}$',
          'Invalid phone format',
        );

        expect(result, equals('Invalid phone format'));
      });

      test('should return null for empty input', () {
        final result = helper.validateInput(
          '',
          r'^\d{3}-\d{4}$',
          'Invalid format',
        );

        expect(result, isNull);
      });

      test('should return null for null input', () {
        final result = helper.validateInput(
          null,
          r'^\d{3}-\d{4}$',
          'Invalid format',
        );

        expect(result, isNull);
      });

      test('should return default error message when custom message is null', () {
        final result = helper.validateInput(
          'invalid',
          r'^\d+$',
          null,
        );

        expect(result, equals('Invalid format'));
      });

      test('should handle complex regex patterns', () {
        final emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

        expect(
          helper.validateInput('test@example.com', emailPattern, 'Invalid email'),
          isNull,
        );
        expect(
          helper.validateInput('invalid-email', emailPattern, 'Invalid email'),
          equals('Invalid email'),
        );
      });
    });

    group('validateInput with default patterns', () {
      test('should use default integer pattern when no custom pattern provided', () {
        final result = helper.validateInput(
          '123',
          null,
          null,
          itemType: QuestionnaireItemType.integer,
        );

        expect(result, isNull);
      });

      test('should validate integer with default pattern', () {
        expect(
          helper.validateInput('42', null, null, itemType: QuestionnaireItemType.integer),
          isNull,
        );
        expect(
          helper.validateInput('-17', null, null, itemType: QuestionnaireItemType.integer),
          isNull,
        );
        expect(
          helper.validateInput('3.14', null, null, itemType: QuestionnaireItemType.integer),
          isNotNull,
        );
        expect(
          helper.validateInput('abc', null, null, itemType: QuestionnaireItemType.integer),
          isNotNull,
        );
      });

      test('should validate decimal with default pattern', () {
        expect(
          helper.validateInput('3.14', null, null, itemType: QuestionnaireItemType.decimal),
          isNull,
        );
        expect(
          helper.validateInput('-0.5', null, null, itemType: QuestionnaireItemType.decimal),
          isNull,
        );
        expect(
          helper.validateInput('42', null, null, itemType: QuestionnaireItemType.decimal),
          isNull,
        );
        expect(
          helper.validateInput('abc', null, null, itemType: QuestionnaireItemType.decimal),
          isNotNull,
        );
      });

      test('should validate URL with default pattern', () {
        expect(
          helper.validateInput('https://example.com', null, null, itemType: QuestionnaireItemType.url),
          isNull,
        );
        expect(
          helper.validateInput('http://test.org', null, null, itemType: QuestionnaireItemType.url),
          isNull,
        );
        expect(
          helper.validateInput('invalid-url', null, null, itemType: QuestionnaireItemType.url),
          isNotNull,
        );
        expect(
          helper.validateInput('example.com', null, null, itemType: QuestionnaireItemType.url),
          isNotNull,
        );
      });

      test('should validate quantity with default pattern', () {
        expect(
          helper.validateInput('5.5', null, null, itemType: QuestionnaireItemType.quantity),
          isNull,
        );
        expect(
          helper.validateInput('120', null, null, itemType: QuestionnaireItemType.quantity),
          isNull,
        );
        expect(
          helper.validateInput('abc', null, null, itemType: QuestionnaireItemType.quantity),
          isNotNull,
        );
      });

      test('should not validate string and text types by default', () {
        expect(
          helper.validateInput('any text', null, null, itemType: QuestionnaireItemType.string),
          isNull,
        );
        expect(
          helper.validateInput('any text', null, null, itemType: QuestionnaireItemType.text),
          isNull,
        );
      });

      test('should use default error message for integer', () {
        final result = helper.validateInput(
          '3.14',
          null,
          null,
          itemType: QuestionnaireItemType.integer,
        );

        expect(result, equals('Must be a valid integer'));
      });

      test('should use default error message for decimal', () {
        final result = helper.validateInput(
          'abc',
          null,
          null,
          itemType: QuestionnaireItemType.decimal,
        );

        expect(result, equals('Must be a valid decimal number'));
      });

      test('should use default error message for URL', () {
        final result = helper.validateInput(
          'not-a-url',
          null,
          null,
          itemType: QuestionnaireItemType.url,
        );

        expect(result, equals('Must be a valid URL starting with http:// or https://'));
      });

      test('should use default error message for quantity', () {
        final result = helper.validateInput(
          'invalid',
          null,
          null,
          itemType: QuestionnaireItemType.quantity,
        );

        expect(result, equals('Must be a valid number'));
      });
    });

    group('validateInput priority', () {
      test('should prioritize custom pattern over default pattern', () {
        // Custom pattern that requires exactly 5 digits
        final result = helper.validateInput(
          '12345',
          r'^\d{5}$',
          'Must be exactly 5 digits',
          itemType: QuestionnaireItemType.integer, // Has default pattern
        );

        expect(result, isNull);

        // This would pass default integer pattern but not custom
        final result2 = helper.validateInput(
          '123',
          r'^\d{5}$',
          'Must be exactly 5 digits',
          itemType: QuestionnaireItemType.integer,
        );

        expect(result2, equals('Must be exactly 5 digits'));
      });

      test('should use custom error message with default pattern', () {
        final result = helper.validateInput(
          'abc',
          null,
          'Custom error: only numbers allowed',
          itemType: QuestionnaireItemType.integer,
        );

        expect(result, equals('Custom error: only numbers allowed'));
      });

      test('should fall back to default when custom pattern is empty string', () {
        final result = helper.validateInput(
          '42',
          '',
          null,
          itemType: QuestionnaireItemType.integer,
        );

        expect(result, isNull);
      });
    });

    group('validateInput edge cases', () {
      test('should return null when no pattern and no item type', () {
        final result = helper.validateInput('anything', null, null);

        expect(result, isNull);
      });

      test('should handle invalid regex pattern gracefully', () {
        final result = helper.validateInput(
          'test',
          '[invalid regex',
          'Error message',
        );

        expect(result, isNull); // Returns null on regex error
      });

      test('should handle whitespace in input', () {
        expect(
          helper.validateInput('  ', null, null, itemType: QuestionnaireItemType.integer),
          isNotNull,
        );
        expect(
          helper.validateInput('  123  ', r'^\d+$', 'Invalid'),
          isNotNull, // Doesn't match due to spaces
        );
      });

      test('should validate negative numbers for integer', () {
        expect(
          helper.validateInput('-42', null, null, itemType: QuestionnaireItemType.integer),
          isNull,
        );
        expect(
          helper.validateInput('--42', null, null, itemType: QuestionnaireItemType.integer),
          isNotNull,
        );
      });

      test('should validate negative numbers for decimal', () {
        expect(
          helper.validateInput('-3.14', null, null, itemType: QuestionnaireItemType.decimal),
          isNull,
        );
        expect(
          helper.validateInput('-.5', null, null, itemType: QuestionnaireItemType.decimal),
          isNotNull,
        );
      });

      test('should handle very long input', () {
        final longNumber = '1' * 100;
        expect(
          helper.validateInput(longNumber, null, null, itemType: QuestionnaireItemType.integer),
          isNull,
        );
      });
    });
  });
}
