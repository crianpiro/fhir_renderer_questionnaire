import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultValidationPatterns', () {
    group('getPatternForType', () {
      test('should return integer pattern for integer type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.integer,
        );
        expect(pattern, equals(r'^-?\d+$'));
      });

      test('should return decimal pattern for decimal type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.decimal,
        );
        expect(pattern, equals(r'^-?\d+(\.\d+)?$'));
      });

      test('should return url pattern for url type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.url,
        );
        expect(pattern, equals(r'^https?://[^\s/$.?#].[^\s]*$'));
      });

      test('should return quantity pattern for quantity type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.quantity,
        );
        expect(pattern, equals(r'^-?\d+(\.\d+)?$'));
      });

      test('should return null for text type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.text,
        );
        expect(pattern, isNull);
      });

      test('should return null for string type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.string,
        );
        expect(pattern, isNull);
      });

      test('should return null for boolean type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(
          QuestionnaireItemType.boolean,
        );
        expect(pattern, isNull);
      });

      test('should return null for null type', () {
        final pattern = DefaultValidationPatterns.getPatternForType(null);
        expect(pattern, isNull);
      });
    });

    group('getErrorMessageForType', () {
      test('should return error message for integer type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(
          QuestionnaireItemType.integer,
        );
        expect(message, equals('Must be a valid integer'));
      });

      test('should return error message for decimal type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(
          QuestionnaireItemType.decimal,
        );
        expect(message, equals('Must be a valid decimal number'));
      });

      test('should return error message for url type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(
          QuestionnaireItemType.url,
        );
        expect(
          message,
          equals('Must be a valid URL starting with http:// or https://'),
        );
      });

      test('should return error message for quantity type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(
          QuestionnaireItemType.quantity,
        );
        expect(message, equals('Must be a valid number'));
      });

      test('should return null for text type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(
          QuestionnaireItemType.text,
        );
        expect(message, isNull);
      });

      test('should return null for null type', () {
        final message = DefaultValidationPatterns.getErrorMessageForType(null);
        expect(message, isNull);
      });
    });

    group('hasDefaultValidation', () {
      test('should return true for integer type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.integer,
        );
        expect(hasValidation, isTrue);
      });

      test('should return true for decimal type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.decimal,
        );
        expect(hasValidation, isTrue);
      });

      test('should return true for url type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.url,
        );
        expect(hasValidation, isTrue);
      });

      test('should return true for quantity type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.quantity,
        );
        expect(hasValidation, isTrue);
      });

      test('should return false for text type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.text,
        );
        expect(hasValidation, isFalse);
      });

      test('should return false for string type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.string,
        );
        expect(hasValidation, isFalse);
      });

      test('should return false for boolean type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(
          QuestionnaireItemType.boolean,
        );
        expect(hasValidation, isFalse);
      });

      test('should return false for null type', () {
        final hasValidation = DefaultValidationPatterns.hasDefaultValidation(null);
        expect(hasValidation, isFalse);
      });
    });

    group('pattern validation tests', () {
      test('integer pattern should accept valid integers', () {
        final pattern = RegExp(DefaultValidationPatterns.integer);

        expect(pattern.hasMatch('42'), isTrue);
        expect(pattern.hasMatch('-17'), isTrue);
        expect(pattern.hasMatch('0'), isTrue);
        expect(pattern.hasMatch('100'), isTrue);
        expect(pattern.hasMatch('999999'), isTrue);
      });

      test('integer pattern should reject invalid integers', () {
        final pattern = RegExp(DefaultValidationPatterns.integer);

        expect(pattern.hasMatch('3.14'), isFalse);
        expect(pattern.hasMatch('abc'), isFalse);
        expect(pattern.hasMatch('12.0'), isFalse);
        expect(pattern.hasMatch('1.5'), isFalse);
        expect(pattern.hasMatch(''), isFalse);
      });

      test('decimal pattern should accept valid decimals', () {
        final pattern = RegExp(DefaultValidationPatterns.decimal);

        expect(pattern.hasMatch('3.14'), isTrue);
        expect(pattern.hasMatch('-0.5'), isTrue);
        expect(pattern.hasMatch('42'), isTrue);
        expect(pattern.hasMatch('100.00'), isTrue);
        expect(pattern.hasMatch('0.123456'), isTrue);
        expect(pattern.hasMatch('-999.999'), isTrue);
      });

      test('decimal pattern should reject invalid decimals', () {
        final pattern = RegExp(DefaultValidationPatterns.decimal);

        expect(pattern.hasMatch('abc'), isFalse);
        expect(pattern.hasMatch('3.14.15'), isFalse);
        expect(pattern.hasMatch(''), isFalse);
        expect(pattern.hasMatch('.5'), isFalse);
      });

      test('url pattern should accept valid URLs', () {
        final pattern = RegExp(DefaultValidationPatterns.url);

        expect(pattern.hasMatch('https://example.com'), isTrue);
        expect(pattern.hasMatch('http://test.org/path'), isTrue);
        expect(pattern.hasMatch('https://api.example.com/v1/users'), isTrue);
        expect(pattern.hasMatch('http://localhost:8080'), isTrue);
      });

      test('url pattern should reject invalid URLs', () {
        final pattern = RegExp(DefaultValidationPatterns.url);

        expect(pattern.hasMatch('example.com'), isFalse);
        expect(pattern.hasMatch('ftp://example.com'), isFalse);
        expect(pattern.hasMatch('not a url'), isFalse);
        expect(pattern.hasMatch(''), isFalse);
      });

      test('quantity pattern should accept valid quantities', () {
        final pattern = RegExp(DefaultValidationPatterns.quantity);

        expect(pattern.hasMatch('5.5'), isTrue);
        expect(pattern.hasMatch('120'), isTrue);
        expect(pattern.hasMatch('-10.25'), isTrue);
        expect(pattern.hasMatch('0'), isTrue);
        expect(pattern.hasMatch('100.0'), isTrue);
      });

      test('quantity pattern should reject invalid quantities', () {
        final pattern = RegExp(DefaultValidationPatterns.quantity);

        expect(pattern.hasMatch('abc'), isFalse);
        expect(pattern.hasMatch('12.5.3'), isFalse);
        expect(pattern.hasMatch(''), isFalse);
      });
    });
  });
}
