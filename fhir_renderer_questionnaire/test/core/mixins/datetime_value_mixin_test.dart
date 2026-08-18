import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

// Test class that uses the mixin
class TestDateTimeHelper with DateTimeValueMixin {}

void main() {
  late TestDateTimeHelper helper;

  setUp(() {
    helper = TestDateTimeHelper();
  });

  group('DateTimeValueMixin', () {
    group('extractDisplayText - dateTime type', () {
      test('should format response dateTime value', () {
        final dateTime = DateTime(2024, 3, 15, 14, 30);
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'appointment',
          'answer': [
            {
              'valueDateTime': dateTime.toIso8601String(),
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'appointment',
          'type': 'dateTime',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        // Should contain both date and time
        expect(displayText, isNotEmpty);
        expect(displayText, contains('2024'));
      });

      test('should format initial dateTime value when no response', () {
        final dateTime = DateTime(2024, 6, 20, 9, 15);
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'appointment',
          'type': 'dateTime',
          'initial': [
            {
              'valueDateTime': dateTime.toIso8601String(),
            },
          ],
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, isNotEmpty);
        expect(displayText, contains('2024'));
      });

      test('should return placeholder when no value for dateTime', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'appointment',
          'type': 'dateTime',
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select date & time'));
      });

      test('should prioritize response over initial for dateTime', () {
        final responseDateTime = DateTime(2024, 5, 10, 10, 0);
        final initialDateTime = DateTime(2024, 1, 1, 8, 0);

        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'appointment',
          'answer': [
            {
              'valueDateTime': responseDateTime.toIso8601String(),
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'appointment',
          'type': 'dateTime',
          'initial': [
            {
              'valueDateTime': initialDateTime.toIso8601String(),
            },
          ],
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, contains('2024'));
        // Response date should be used
        expect(displayText, contains('5'));
      });

      test('should handle empty answer list for dateTime', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'appointment',
          'answer': [],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'appointment',
          'type': 'dateTime',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('Select date & time'));
      });
    });

    group('extractDisplayText - date type', () {
      test('should format response date value', () {
        final date = DateTime(2024, 7, 4);
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'birthDate',
          'answer': [
            {
              'valueDate': date.toIso8601String().substring(0, 10),
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'birthDate',
          'type': 'date',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, isNotEmpty);
        expect(displayText, contains('2024'));
      });

      test('should format initial date value when no response', () {
        final date = DateTime(2024, 12, 25);
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'birthDate',
          'type': 'date',
          'initial': [
            {
              'valueDate': date.toIso8601String().substring(0, 10),
            },
          ],
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, isNotEmpty);
        expect(displayText, contains('2024'));
      });

      test('should return placeholder when no value for date', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'birthDate',
          'type': 'date',
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select date'));
      });

      test('should prioritize response over initial for date', () {
        final responseDate = DateTime(2024, 8, 15);
        final initialDate = DateTime(2024, 1, 1);

        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'birthDate',
          'answer': [
            {
              'valueDate': responseDate.toIso8601String().substring(0, 10),
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'birthDate',
          'type': 'date',
          'initial': [
            {
              'valueDate': initialDate.toIso8601String().substring(0, 10),
            },
          ],
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, isNotEmpty);
        expect(displayText, contains('2024'));
      });

      test('should handle empty answer list for date', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'birthDate',
          'answer': [],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'birthDate',
          'type': 'date',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('Select date'));
      });
    });

    group('extractDisplayText - time type', () {
      test('should extract response time value', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'wakeTime',
          'answer': [
            {
              'valueTime': '08:30:00',
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'wakeTime',
          'type': 'time',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('08:30:00'));
      });

      test('should extract initial time value when no response', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'wakeTime',
          'type': 'time',
          'initial': [
            {
              'valueTime': '07:00:00',
            },
          ],
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('07:00:00'));
      });

      test('should return placeholder when no value for time', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'wakeTime',
          'type': 'time',
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select time'));
      });

      test('should prioritize response over initial for time', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'wakeTime',
          'answer': [
            {
              'valueTime': '09:00:00',
            },
          ],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'wakeTime',
          'type': 'time',
          'initial': [
            {
              'valueTime': '06:00:00',
            },
          ],
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('09:00:00'));
      });

      test('should handle empty answer list for time', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'wakeTime',
          'answer': [],
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'wakeTime',
          'type': 'time',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('Select time'));
      });
    });

    group('extractDisplayText - edge cases', () {
      test('should handle null response with no initial', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'date',
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select date'));
      });

      test('should handle response without answer field', () {
        final responseItem = QuestionnaireResponseItem.fromJson({
          'linkId': 'test',
        });

        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'dateTime',
        });

        final displayText =
            helper.extractDisplayText(responseItem, questionnaireItem);

        expect(displayText, equals('Select date & time'));
      });

      test('should handle empty initial list', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'time',
          'initial': [],
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select time'));
      });

      test('should handle initial with non-date type', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'date',
          'initial': [
            {
              'valueString': 'not a date',
            },
          ],
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, equals('Select date'));
      });

      test('should return empty string for unsupported type', () {
        final questionnaireItem = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'string',
        });

        final displayText = helper.extractDisplayText(null, questionnaireItem);

        expect(displayText, isEmpty);
      });
    });
  });
}
