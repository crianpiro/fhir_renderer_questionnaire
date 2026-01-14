import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_display_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireDisplayItem', () {
    testWidgets('should render display text', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createDisplayItem(
        linkId: 'info',
        text: 'Please read the following instructions carefully.',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireDisplayItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(
        find.text('Please read the following instructions carefully.'),
        findsOneWidget,
      );
    });

    testWidgets('should render empty text when text is null',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createDisplayItem(
        linkId: 'info',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireDisplayItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(QuestionnaireDisplayItem), findsOneWidget);
    });

    testWidgets('should be read-only and not interactive',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createDisplayItem(
        linkId: 'info',
        text: 'Information text',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireDisplayItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Display items should not have interactive elements
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.byType(Radio), findsNothing);
    });

    testWidgets('should render with bold title style',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createDisplayItem(
        linkId: 'info',
        text: 'Important Notice',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireDisplayItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Important Notice'));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should render multiple display items in sequence',
        (WidgetTester tester) async {
      final item1 = WidgetTestHelpers.createDisplayItem(
        linkId: 'info1',
        text: 'First instruction',
      );
      final item2 = WidgetTestHelpers.createDisplayItem(
        linkId: 'info2',
        text: 'Second instruction',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item1, item2]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: Column(
            children: [
              QuestionnaireDisplayItem(
                questionnaireItem: item1,
                index: 0,
                isLastItem: false,
              ),
              QuestionnaireDisplayItem(
                questionnaireItem: item2,
                index: 1,
                isLastItem: true,
              ),
            ],
          ),
        ),
      );

      expect(find.text('First instruction'), findsOneWidget);
      expect(find.text('Second instruction'), findsOneWidget);
      expect(find.byType(QuestionnaireDisplayItem), findsNWidgets(2));
    });

    testWidgets('should apply rounded bottom border when isLastItem is true',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createDisplayItem(
        linkId: 'info',
        text: 'Last item',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireDisplayItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the Container with BoxDecoration that has border radius
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundRoundedContainer = false;
      for (final container in containers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.borderRadius != null) {
            foundRoundedContainer = true;
            break;
          }
        }
      }
      expect(foundRoundedContainer, isTrue);
    });
  });
}
