import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  group('KeyboardTypeHelper', () {
    group('getKeyboardType', () {
      test('should return number keyboard for integer type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.integer,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, isA<TextInputType>());
        expect(keyboardType, equals(const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        )));
      });

      test('should return decimal keyboard for decimal type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.decimal,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, equals(const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        )));
      });

      test('should return decimal keyboard for quantity type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.quantity,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, equals(const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        )));
      });

      test('should return URL keyboard for url type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.url,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, equals(TextInputType.url));
      });

      test('should return multiline keyboard for text type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.text,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, equals(TextInputType.multiline));
      });

      test('should return text keyboard for string type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.string,
        );

        expect(keyboardType, isNotNull);
        expect(keyboardType, equals(TextInputType.text));
      });

      test('should return null for boolean type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.boolean,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for choice type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.choice,
        );

        expect(keyboardType, isNull);
      });


      test('should return null for date type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.date,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for dateTime type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.dateTime,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for time type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.time,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for group type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.group,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for attachment type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.attachment,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for reference type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(
          QuestionnaireItemType.reference,
        );

        expect(keyboardType, isNull);
      });

      test('should return null for null type', () {
        final keyboardType = KeyboardTypeHelper.getKeyboardType(null);
        expect(keyboardType, isNull);
      });
    });

    group('getTextInputAction', () {
      test('should return newline for text type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.text,
        );

        expect(action, equals(TextInputAction.newline));
      });

      test('should return next for string type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.string,
        );

        expect(action, equals(TextInputAction.next));
      });

      test('should return next for integer type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.integer,
        );

        expect(action, equals(TextInputAction.next));
      });

      test('should return next for decimal type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.decimal,
        );

        expect(action, equals(TextInputAction.next));
      });

      test('should return next for url type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.url,
        );

        expect(action, equals(TextInputAction.next));
      });

      test('should return next for quantity type', () {
        final action = KeyboardTypeHelper.getTextInputAction(
          QuestionnaireItemType.quantity,
        );

        expect(action, equals(TextInputAction.next));
      });

      test('should return null for null type', () {
        final action = KeyboardTypeHelper.getTextInputAction(null);
        expect(action, isNull);
      });
    });

    group('getInputFormatters', () {
      test('should return integer formatter for integer type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.integer,
        );

        expect(formatters, isNotNull);
        expect(formatters, isNotEmpty);
        expect(formatters?.length, equals(1));
        expect(formatters?.first, isA<FilteringTextInputFormatter>());
      });

      test('should return decimal formatter for decimal type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.decimal,
        );

        expect(formatters, isNotNull);
        expect(formatters, isNotEmpty);
        expect(formatters?.length, equals(1));
        expect(formatters?.first, isA<FilteringTextInputFormatter>());
      });

      test('should return decimal formatter for quantity type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.quantity,
        );

        expect(formatters, isNotNull);
        expect(formatters, isNotEmpty);
        expect(formatters?.length, equals(1));
        expect(formatters?.first, isA<FilteringTextInputFormatter>());
      });

      test('should return null for string type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.string,
        );

        expect(formatters, isNull);
      });

      test('should return null for text type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.text,
        );

        expect(formatters, isNull);
      });

      test('should return null for url type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(
          QuestionnaireItemType.url,
        );

        expect(formatters, isNull);
      });

      test('should return null for null type', () {
        final formatters = KeyboardTypeHelper.getInputFormatters(null);
        expect(formatters, isNull);
      });
    });

    group('hasSpecificKeyboardType', () {
      test('should return true for types with specific keyboard', () {
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.integer),
          isTrue,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.decimal),
          isTrue,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.url),
          isTrue,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.text),
          isTrue,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.string),
          isTrue,
        );
      });

      test('should return false for types without specific keyboard', () {
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.boolean),
          isFalse,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(QuestionnaireItemType.choice),
          isFalse,
        );
        expect(
          KeyboardTypeHelper.hasSpecificKeyboardType(null),
          isFalse,
        );
      });
    });
  });
}
