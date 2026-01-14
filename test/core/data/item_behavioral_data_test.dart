import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/widgets.dart';
import 'package:test/test.dart';

void main() {
  group('ItemBehavioralData', () {
    late FocusNode focusNode;
    late TextEditingController textController;

    setUp(() {
      focusNode = FocusNode();
      textController = TextEditingController();
    });

    tearDown(() {
      focusNode.dispose();
      textController.dispose();
    });

    group('constructor', () {
      test('should create instance with required parameters', () {
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        expect(data.index, equals(0));
        expect(data.markAsRequired, isTrue);
        expect(data.focusNode, equals(focusNode));
        expect(data.textController, isNull);
        expect(data.dependentOn, isNull);
        expect(data.regexValidationPattern, isNull);
        expect(data.regexValidationError, isNull);
      });

      test('should create instance with all parameters', () {
        final data = ItemBehavioralData(
          index: 5,
          markAsRequired: false,
          focusNode: focusNode,
          textController: textController,
          dependentOn: ['item1', 'item2'],
          regexValidationPattern: r'^\d+$',
          regexValidationError: 'Must be a number',
        );

        expect(data.index, equals(5));
        expect(data.markAsRequired, isFalse);
        expect(data.focusNode, equals(focusNode));
        expect(data.textController, equals(textController));
        expect(data.dependentOn, equals(['item1', 'item2']));
        expect(data.regexValidationPattern, equals(r'^\d+$'));
        expect(data.regexValidationError, equals('Must be a number'));
      });

      test('should handle empty dependentOn list', () {
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          dependentOn: [],
        );

        expect(data.dependentOn, isEmpty);
      });

      test('should handle multiple dependencies', () {
        final dependencies = ['q1', 'q2', 'q3', 'q4'];
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          dependentOn: dependencies,
        );

        expect(data.dependentOn, equals(dependencies));
        expect(data.dependentOn?.length, equals(4));
      });
    });

    group('copyWith', () {
      test('should create copy with updated index', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        final copy = original.copyWith(index: 5);

        expect(copy.index, equals(5));
        expect(copy.markAsRequired, equals(original.markAsRequired));
        expect(copy.focusNode, equals(original.focusNode));
      });

      test('should create copy with updated markAsRequired', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        final copy = original.copyWith(markAsRequired: false);

        expect(copy.index, equals(original.index));
        expect(copy.markAsRequired, isFalse);
        expect(copy.focusNode, equals(original.focusNode));
      });

      test('should create copy with updated focusNode', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        final newFocusNode = FocusNode();
        final copy = original.copyWith(focusNode: newFocusNode);

        expect(copy.focusNode, equals(newFocusNode));
        expect(copy.focusNode, isNot(equals(original.focusNode)));

        newFocusNode.dispose();
      });

      test('should create copy with updated textController', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        final newController = TextEditingController(text: 'test');
        final copy = original.copyWith(textController: newController);

        expect(copy.textController, equals(newController));
        expect(copy.textController?.text, equals('test'));

        newController.dispose();
      });

      test('should create copy with updated dependentOn', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          dependentOn: ['item1'],
        );

        final copy = original.copyWith(dependentOn: ['item2', 'item3']);

        expect(copy.dependentOn, equals(['item2', 'item3']));
        expect(copy.dependentOn, isNot(equals(original.dependentOn)));
      });

      test('should create copy with updated regexValidationPattern', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          regexValidationPattern: r'^\d+$',
        );

        final copy = original.copyWith(regexValidationPattern: r'^[a-z]+$');

        expect(copy.regexValidationPattern, equals(r'^[a-z]+$'));
        expect(copy.regexValidationPattern, isNot(equals(original.regexValidationPattern)));
      });

      test('should create copy with updated regexValidationError', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          regexValidationError: 'Error 1',
        );

        final copy = original.copyWith(regexValidationError: 'Error 2');

        expect(copy.regexValidationError, equals('Error 2'));
        expect(copy.regexValidationError, isNot(equals(original.regexValidationError)));
      });

      test('should create copy with multiple updated fields', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          dependentOn: ['item1'],
        );

        final copy = original.copyWith(
          index: 10,
          markAsRequired: false,
          dependentOn: ['item2', 'item3'],
          regexValidationPattern: r'^\d+$',
          regexValidationError: 'Must be numeric',
        );

        expect(copy.index, equals(10));
        expect(copy.markAsRequired, isFalse);
        expect(copy.dependentOn, equals(['item2', 'item3']));
        expect(copy.regexValidationPattern, equals(r'^\d+$'));
        expect(copy.regexValidationError, equals('Must be numeric'));
        expect(copy.focusNode, equals(original.focusNode));
      });

      test('should preserve original values when not specified in copyWith', () {
        final original = ItemBehavioralData(
          index: 5,
          markAsRequired: true,
          focusNode: focusNode,
          textController: textController,
          dependentOn: ['item1', 'item2'],
          regexValidationPattern: r'^\d+$',
          regexValidationError: 'Error',
        );

        final copy = original.copyWith();

        expect(copy.index, equals(original.index));
        expect(copy.markAsRequired, equals(original.markAsRequired));
        expect(copy.focusNode, equals(original.focusNode));
        expect(copy.textController, equals(original.textController));
        expect(copy.dependentOn, equals(original.dependentOn));
        expect(copy.regexValidationPattern, equals(original.regexValidationPattern));
        expect(copy.regexValidationError, equals(original.regexValidationError));
      });

      test('should handle null to non-null updates', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
        );

        final copy = original.copyWith(
          textController: textController,
          dependentOn: ['item1'],
          regexValidationPattern: r'^\d+$',
          regexValidationError: 'Error',
        );

        expect(copy.textController, equals(textController));
        expect(copy.dependentOn, equals(['item1']));
        expect(copy.regexValidationPattern, equals(r'^\d+$'));
        expect(copy.regexValidationError, equals('Error'));
      });

      test('should create independent copy', () {
        final original = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          dependentOn: ['item1'],
        );

        final copy = original.copyWith(index: 1);

        // Verify they are different instances
        expect(identical(original, copy), isFalse);

        // But share same focusNode reference
        expect(identical(original.focusNode, copy.focusNode), isTrue);
      });
    });

    group('edge cases', () {
      test('should handle zero index', () {
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: false,
          focusNode: focusNode,
        );

        expect(data.index, equals(0));
      });

      test('should handle negative index', () {
        final data = ItemBehavioralData(
          index: -1,
          markAsRequired: true,
          focusNode: focusNode,
        );

        expect(data.index, equals(-1));
      });

      test('should handle large index values', () {
        final data = ItemBehavioralData(
          index: 999999,
          markAsRequired: true,
          focusNode: focusNode,
        );

        expect(data.index, equals(999999));
      });

      test('should handle empty regex pattern', () {
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          regexValidationPattern: '',
        );

        expect(data.regexValidationPattern, isEmpty);
      });

      test('should handle empty error message', () {
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          regexValidationError: '',
        );

        expect(data.regexValidationError, isEmpty);
      });

      test('should handle complex regex patterns', () {
        const complexPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
        final data = ItemBehavioralData(
          index: 0,
          markAsRequired: true,
          focusNode: focusNode,
          regexValidationPattern: complexPattern,
        );

        expect(data.regexValidationPattern, equals(complexPattern));
      });
    });
  });
}
