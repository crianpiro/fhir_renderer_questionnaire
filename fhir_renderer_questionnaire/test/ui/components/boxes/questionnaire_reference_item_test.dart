import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_reference_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireReferenceItem', () {
    QuestionnaireItem createReferenceItem({
      required String linkId,
      String? text,
    }) {
      return QuestionnaireItem(
        linkId: FhirString(linkId),
        type: QuestionnaireItemType.reference,
        text: text != null ? FhirString(text) : null,
      );
    }

    testWidgets('should render with title text', (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Select a practitioner'), findsOneWidget);
    });

    testWidgets('should render reference input field',
        (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should have two TextFormFields (reference and display name)
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should show reference field label',
        (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Resource Reference'), findsOneWidget);
      expect(find.text('Display Name (Optional)'), findsOneWidget);
    });

    testWidgets('should show link icon', (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display existing reference value',
        (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: FhirString('practitioner'),
            answer: [
              QuestionnaireResponseAnswer(
                valueX: Reference(
                  reference: FhirString('Practitioner/123'),
                  display: FhirString('Dr. Jane Smith'),
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          initialResponse: initialResponse,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should display the reference card with the current reference
      expect(find.text('Current Reference'), findsOneWidget);
      expect(find.text('Practitioner'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);
      // "Dr. Jane Smith" appears twice: once in the text field and once in the card
      expect(find.text('Dr. Jane Smith'), findsNWidgets(2));
    });

    testWidgets('should show allowed types hint for practitioner in text',
        (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select your practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.textContaining('Practitioner'), findsWidgets);
    });

    testWidgets('should update response when reference is entered',
        (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
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
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Find the first TextFormField (reference field)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Practitioner/456');
      await tester.pumpAndSettle();

      // Verify response was updated
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId.valueString == 'practitioner',
      );
      expect(
        responseItem?.answer?.first.valueReference?.reference?.valueString,
        equals('Practitioner/456'),
      );
    });

    testWidgets('should show helper text', (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Format: ResourceType/id'), findsOneWidget);
      expect(
        find.text('Human-readable label for the reference'),
        findsOneWidget,
      );
    });

    testWidgets('should show hint text in fields', (WidgetTester tester) async {
      final item = createReferenceItem(
        linkId: 'practitioner',
        text: 'Select a practitioner',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireReferenceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(
        find.text('e.g., Practitioner/123 or Patient/456'),
        findsOneWidget,
      );
      expect(find.text('e.g., Dr. Jane Smith'), findsOneWidget);
    });
  });
}
