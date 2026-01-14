import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_date_time_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireDateTimeItem', () {
    group('Date type', () {
      testWidgets('should render with title text', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.text('What is your date of birth?'), findsOneWidget);
      });

      testWidgets('should render a date picker button',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show placeholder text when no date is selected',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Should show placeholder text when no date selected
        expect(find.text('Select date'), findsOneWidget);
      });

      testWidgets('should show calendar icon for date type',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Implementation uses calendar_month for date types
        expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      });
    });

    group('DateTime type', () {
      testWidgets('should render datetime picker button',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'appointment',
          text: 'When is your appointment?',
          type: QuestionnaireItemType.dateTime,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show datetime icon for datetime type',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'appointment',
          text: 'When is your appointment?',
          type: QuestionnaireItemType.dateTime,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Implementation uses calendar_month for datetime types
        expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      });
    });

    group('Time type', () {
      testWidgets('should render time picker button',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'wakeup',
          text: 'What time do you wake up?',
          type: QuestionnaireItemType.time,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show time icon for time type',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'wakeup',
          text: 'What time do you wake up?',
          type: QuestionnaireItemType.time,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Implementation uses av_timer for time types
        expect(find.byIcon(Icons.av_timer), findsOneWidget);
      });
    });

    group('Existing response', () {
      testWidgets('should show existing date value',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        final initialResponse = QuestionnaireResponse(
          status: QuestionnaireResponseStatus.inProgress,
          item: [
            QuestionnaireResponseItem(
              linkId: FhirString('birthdate'),
              answer: [
                QuestionnaireResponseAnswer(
                  valueX: FhirDate.fromString('2000-01-15'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            initialResponse: initialResponse,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Should show the formatted date
        expect(find.textContaining('2000'), findsOneWidget);
      });
    });

    group('Button interaction', () {
      testWidgets('should be tappable', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDateItem(
          linkId: 'birthdate',
          text: 'What is your date of birth?',
          type: QuestionnaireItemType.date,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireDateTimeItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Tap the button - this should open the date picker
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Date picker dialog should be shown
        expect(find.byType(DatePickerDialog), findsOneWidget);
      });
    });
  });
}
