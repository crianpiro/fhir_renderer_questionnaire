import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_open_choice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireOpenChoiceItem', () {
    testWidgets('should render with title text', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('What is your favorite color?'), findsOneWidget);
    });

    testWidgets('should render predefined options', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'red',
              display: 'Red',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'blue',
              display: 'Blue',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
    });

    testWidgets('should render custom text input field',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should have a TextFormField for custom text input
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('should allow entering custom text',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
        repeats: false,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Enter custom text
      await tester.enterText(find.byType(TextFormField), 'Purple');
      await tester.pumpAndSettle();

      // Verify response was updated with custom text
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId == 'color',
      );
      expect(
        responseItem?.answer?.first.valueString,
        equals('Purple'),
      );
    });

    testWidgets('should show "Other (additional answer)" for multi-select',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'hobbies',
        text: 'Select your hobbies',
        repeats: true,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Other (additional answer)'), findsOneWidget);
    });

    testWidgets('should render checkboxes for multi-select',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'hobbies',
        text: 'Select your hobbies',
        repeats: true,
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'reading',
              display: 'Reading',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'sports',
              display: 'Sports',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Multi-select renders CheckboxListTile
      expect(find.byType(CheckboxListTile), findsNWidgets(2));
    });

    testWidgets('should show existing custom text value',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
        repeats: false,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: 'color',
            answer: [
              QuestionnaireResponseAnswer(
                valueString: 'Purple',
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          initialResponse: initialResponse,
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // The custom text field should show the value
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.initialValue, equals('Purple'));
    });

    testWidgets('should clear custom text when emptied',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
        repeats: false,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Enter text then clear it
      await tester.enterText(find.byType(TextFormField), 'Test');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();

      // Response should have no string answer
      final responseItem = capturedResponse?.item?.firstWhere(
        (i) => i.linkId == 'color',
      );
      // Either null or no string type answers
      final stringAnswers = responseItem?.answer?.where(
        (a) => a.valueString != null,
      );
      expect(stringAnswers?.isEmpty ?? true, isTrue);
    });

    testWidgets('should select predefined option when tapped',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createOpenChoiceItem(
        linkId: 'color',
        text: 'What is your favorite color?',
        repeats: false,
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'red',
              display: 'Red',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'blue',
              display: 'Blue',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireOpenChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Tap on "Red" option
      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();

      // Verify response was updated with coding
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId == 'color',
      );
      expect(
        responseItem?.answer?.first.valueCoding?.code,
        equals('red'),
      );
    });
  });
}
