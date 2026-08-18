import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestChoiceHelper with ChoiceBaseMixin {}

void main() {
  late TestChoiceHelper helper;

  setUp(() {
    helper = TestChoiceHelper();
  });

  group('ChoiceBaseMixin', () {
    group('isOptionSelected', () {
      test('should return true when option is in response answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
          'answer': [
            {
              'valueCoding': {
                'code': 'male',
                'display': 'Male',
              },
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'male',
            'display': 'Male',
          },
        });

        expect(
          helper.isOptionSelected(responseItem, questionnaireItem, answerOption),
          isTrue,
        );
      });

      test('should return false when option is not in response answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
          'answer': [
            {
              'valueCoding': {
                'code': 'male',
                'display': 'Male',
              },
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'female',
            'display': 'Female',
          },
        });

        expect(
          helper.isOptionSelected(responseItem, questionnaireItem, answerOption),
          isFalse,
        );
      });

      test('should check initial values when no response', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
          'initial': [
            {
              'valueCoding': {
                'code': 'female',
                'display': 'Female',
              },
            },
          ],
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'female',
            'display': 'Female',
          },
        });

        expect(
          helper.isOptionSelected(null, questionnaireItem, answerOption),
          isTrue,
        );
      });

      test('should return false when no response and no initial values', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'male',
            'display': 'Male',
          },
        });

        expect(
          helper.isOptionSelected(null, questionnaireItem, answerOption),
          isFalse,
        );
      });

      test('should handle multiple answers and match one', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'symptoms',
          'answer': [
            {
              'valueCoding': {'code': 'fever'},
            },
            {
              'valueCoding': {'code': 'cough'},
            },
            {
              'valueCoding': {'code': 'fatigue'},
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'symptoms',
          'type': 'choice',
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {'code': 'cough'},
        });

        expect(
          helper.isOptionSelected(responseItem, questionnaireItem, answerOption),
          isTrue,
        );
      });

      test('should return false for empty answer list', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
          'answer': [],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
        });

        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {'code': 'male'},
        });

        expect(
          helper.isOptionSelected(responseItem, questionnaireItem, answerOption),
          isFalse,
        );
      });
    });

    group('getDisplayValue', () {
      test('should return display value when available', () {
        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'male',
            'display': 'Male',
          },
        });

        expect(helper.getDisplayValue(answerOption), equals('Male'));
      });

      test('should return code when display is not available', () {
        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'male',
          },
        });

        expect(helper.getDisplayValue(answerOption), equals('male'));
      });

      test('should return -- when neither display nor code available', () {
        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {},
        });

        expect(helper.getDisplayValue(answerOption), equals('--'));
      });

      test('should prioritize display over code', () {
        final answerOption = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {
            'code': 'M',
            'display': 'Male',
          },
        });

        expect(helper.getDisplayValue(answerOption), equals('Male'));
      });
    });

    group('getSelectedCodingValue', () {
      test('should return code from first coding answer', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
          'answer': [
            {
              'valueCoding': {
                'code': 'male',
                'display': 'Male',
              },
            },
          ],
        });

        expect(helper.getSelectedCodingValue(responseItem), equals('male'));
      });

      test('should return null when no answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
        });

        expect(helper.getSelectedCodingValue(responseItem), isNull);
      });

      test('should return null for null response item', () {
        expect(helper.getSelectedCodingValue(null), isNull);
      });

      test('should return null when answer list is empty', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'gender',
          'answer': [],
        });

        expect(helper.getSelectedCodingValue(responseItem), isNull);
      });

      test('should return code from first answer with multiple answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'multi',
          'answer': [
            {
              'valueCoding': {'code': 'first'},
            },
            {
              'valueCoding': {'code': 'second'},
            },
          ],
        });

        expect(helper.getSelectedCodingValue(responseItem), equals('first'));
      });

      test('should handle answer without coding', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
          'answer': [
            {
              'valueString': 'text answer',
            },
          ],
        });

        expect(helper.getSelectedCodingValue(responseItem), isNull);
      });
    });
  });
}
