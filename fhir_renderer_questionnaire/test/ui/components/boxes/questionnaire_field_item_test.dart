import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_field_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireFieldItem', () {
    group('String type', () {
      testWidgets('should render with title text', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'name',
          text: 'What is your name?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.text('What is your name?'), findsOneWidget);
      });

      testWidgets('should render a TextFormField', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'name',
          text: 'What is your name?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should update response when text is entered',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'name',
          text: 'What is your name?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        QuestionnaireResponse? capturedResponse;

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            onResponseChanged: (response) {
              capturedResponse = response;
            },
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Enter text
        await tester.enterText(find.byType(TextFormField), 'John Doe');
        await tester.pumpAndSettle();

        // Verify response was updated
        expect(capturedResponse, isNotNull);
        final responseItem = capturedResponse!.item?.firstWhere(
          (i) => i.linkId.valueString == 'name',
        );
        expect(
          responseItem?.answer?.first.valueString,
          equals(FhirString('John Doe')),
        );
      });

      testWidgets('should show initial value when set',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'name',
          text: 'What is your name?',
          initialValue: 'Jane Doe',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Verify the text field contains the initial value
        final textField = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );
        expect(textField.controller?.text, equals('Jane Doe'));
      });

      testWidgets('should clear response when text is cleared',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'name',
          text: 'What is your name?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        QuestionnaireResponse? capturedResponse;

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            onResponseChanged: (response) {
              capturedResponse = response;
            },
            child: QuestionnaireFieldItem(
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

        // Response item should have empty answer list (implementation uses [] not null)
        final responseItem = capturedResponse?.item?.firstWhere(
          (i) => i.linkId.valueString == 'name',
        );
        expect(responseItem?.answer, isEmpty);
      });
    });

    group('Text type (multiline)', () {
      testWidgets('should render with multiline support',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'comments',
          text: 'Additional comments',
          type: QuestionnaireItemType.text,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Text type should render without error - TextFormField is present
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Additional comments'), findsOneWidget);
      });
    });

    group('Integer type', () {
      testWidgets('should render integer field', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createIntegerItem(
          linkId: 'age',
          text: 'What is your age?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('What is your age?'), findsOneWidget);
      });
    });

    group('Decimal type', () {
      testWidgets('should render decimal field', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDecimalItem(
          linkId: 'weight',
          text: 'What is your weight?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('What is your weight?'), findsOneWidget);
      });

      testWidgets('should use decimal keyboard for decimal',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createDecimalItem(
          linkId: 'weight',
          text: 'What is your weight?',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Find the underlying TextField (TextFormField wraps TextField)
        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );
        // KeyboardTypeHelper uses signed: true to allow negative decimals
        expect(
          textField.keyboardType,
          equals(const TextInputType.numberWithOptions(signed: true, decimal: true)),
        );
      });
    });

    group('URL type', () {
      testWidgets('should render URL field', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createUrlItem(
          linkId: 'website',
          text: 'Enter your website URL',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Enter your website URL'), findsOneWidget);
      });

      testWidgets('should use URL keyboard', (WidgetTester tester) async {
        final item = WidgetTestHelpers.createUrlItem(
          linkId: 'website',
          text: 'Enter your website URL',
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Find the underlying TextField (TextFormField wraps TextField)
        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );
        expect(textField.keyboardType, equals(TextInputType.url));
      });
    });

    group('Max length', () {
      testWidgets('should respect maxLength setting',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createStringItem(
          linkId: 'code',
          text: 'Enter code',
          maxLength: 10,
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireFieldItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        // Find the underlying TextField (TextFormField wraps TextField)
        final textField = tester.widget<TextField>(
          find.byType(TextField),
        );
        expect(textField.maxLength, equals(10));
      });
    });
  });
}
