import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestOpenChoiceHelper with ChoiceBaseMixin, OpenChoiceValueMixin {}

void main() {
  late TestOpenChoiceHelper helper;

  setUp(() {
    helper = TestOpenChoiceHelper();
  });

  group('OpenChoiceValueMixin', () {
    group('getCustomTextValue', () {
      test('should extract string value from response', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'occupation',
          'answer': [
            {
              'valueString': 'Software Engineer',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('Software Engineer'),
        );
      });

      test('should return null when no answer', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'occupation',
        });

        expect(helper.getCustomTextValue(responseItem), isNull);
      });

      test('should return null for null response item', () {
        expect(helper.getCustomTextValue(null), isNull);
      });

      test('should return null when answer list is empty', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'occupation',
          'answer': [],
        });

        expect(helper.getCustomTextValue(responseItem), isNull);
      });

      test('should find string value among multiple answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'symptoms',
          'answer': [
            {
              'valueCoding': {
                'code': 'fever',
                'display': 'Fever',
              },
            },
            {
              'valueString': 'Other symptoms',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('Other symptoms'),
        );
      });

      test('should return first string value when multiple string answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
          'answer': [
            {
              'valueString': 'First answer',
            },
            {
              'valueString': 'Second answer',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('First answer'),
        );
      });

      test('should return null when no string answers exist', () {
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

        expect(helper.getCustomTextValue(responseItem), isNull);
      });

      test('should handle multiple non-string answers', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'multi',
          'answer': [
            {
              'valueCoding': {'code': 'option1'},
            },
            {
              'valueInteger': 42,
            },
            {
              'valueBoolean': true,
            },
          ],
        });

        expect(helper.getCustomTextValue(responseItem), isNull);
      });

      test('should extract empty string value', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'note',
          'answer': [
            {
              'valueString': '',
            },
          ],
        });

        expect(helper.getCustomTextValue(responseItem), equals(''));
      });

      test('should extract string with whitespace', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'comment',
          'answer': [
            {
              'valueString': '  spaces around  ',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('  spaces around  '),
        );
      });

      test('should extract string with special characters', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'special',
          'answer': [
            {
              'valueString': 'Text with !@#\$%^&*() symbols',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('Text with !@#\$%^&*() symbols'),
        );
      });

      test('should extract multiline string value', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'description',
          'answer': [
            {
              'valueString': 'Line 1\nLine 2\nLine 3',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('Line 1\nLine 2\nLine 3'),
        );
      });

      test('should prioritize string when mixed with coding', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'ethnicity',
          'answer': [
            {
              'valueCoding': {
                'code': 'other',
                'display': 'Other',
              },
            },
            {
              'valueString': 'Custom ethnicity description',
            },
          ],
        });

        expect(
          helper.getCustomTextValue(responseItem),
          equals('Custom ethnicity description'),
        );
      });

      test('should handle answer with integer instead of string', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
          'answer': [
            {
              'valueInteger': 123,
            },
          ],
        });

        expect(helper.getCustomTextValue(responseItem), isNull);
      });
    });
  });
}
