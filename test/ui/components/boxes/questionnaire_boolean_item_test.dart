import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_boolean_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireBooleanItem', () {
    testWidgets('should render with title text', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Do you agree?'), findsOneWidget);
    });

    testWidgets('should render Yes and No radio options',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.byType(RadioListTile<bool>), findsNWidgets(2));
    });

    testWidgets('should select Yes when tapped', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Tap on the "Yes" radio button
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Verify response was updated
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId.valueString == 'consent',
      );
      expect(responseItem?.answer?.first.valueBoolean, equals(FhirBoolean(true)));
    });

    testWidgets('should select No when tapped', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Tap on the "No" radio button
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Verify response was updated
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId.valueString == 'consent',
      );
      expect(responseItem?.answer?.first.valueBoolean, equals(FhirBoolean(false)));
    });

    testWidgets('should show initial value when set to true',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
        initialValue: true,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the RadioListTile widgets
      final radioTiles = tester.widgetList<RadioListTile<bool>>(
        find.byType(RadioListTile<bool>),
      );

      // The "Yes" option should be selected (groupValue == true matches value == true)
      final yesTile = radioTiles.firstWhere((tile) => tile.value == true);
      expect(yesTile.groupValue, equals(true));
    });

    testWidgets('should show initial value when set to false',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
        initialValue: false,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the RadioListTile widgets
      final radioTiles = tester.widgetList<RadioListTile<bool>>(
        find.byType(RadioListTile<bool>),
      );

      // The "No" option should be selected (groupValue == false matches value == false)
      final noTile = radioTiles.firstWhere((tile) => tile.value == false);
      expect(noTile.groupValue, equals(false));
    });

    testWidgets('should render with no selection when no initial value',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the RadioListTile widgets
      final radioTiles = tester.widgetList<RadioListTile<bool>>(
        find.byType(RadioListTile<bool>),
      );

      // Both should have null groupValue (nothing selected)
      for (final tile in radioTiles) {
        expect(tile.groupValue, isNull);
      }
    });

    testWidgets('should show existing response value',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);
      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          WidgetTestHelpers.createBooleanResponseItem(
            linkId: 'consent',
            value: true,
          ),
        ],
      );

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          initialResponse: initialResponse,
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the RadioListTile widgets
      final radioTiles = tester.widgetList<RadioListTile<bool>>(
        find.byType(RadioListTile<bool>),
      );

      // The "Yes" option should be selected
      final yesTile = radioTiles.firstWhere((tile) => tile.value == true);
      expect(yesTile.groupValue, equals(true));
    });

    testWidgets('should change selection from Yes to No',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createBooleanItem(
        linkId: 'consent',
        text: 'Do you agree?',
        initialValue: true,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireBooleanItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Initially Yes is selected
      var radioTiles = tester.widgetList<RadioListTile<bool>>(
        find.byType(RadioListTile<bool>),
      );
      var yesTile = radioTiles.firstWhere((tile) => tile.value == true);
      expect(yesTile.groupValue, equals(true));

      // Tap on "No"
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Verify response changed to false
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId.valueString == 'consent',
      );
      expect(responseItem?.answer?.first.valueBoolean, equals(FhirBoolean(false)));
    });
  });
}
