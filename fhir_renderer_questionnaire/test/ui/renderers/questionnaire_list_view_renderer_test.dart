import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnaireListViewRenderer', () {
    testWidgets('should render a basic questionnaire',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'name',
            type: QuestionnaireItemType.string,
            text: 'What is your name?',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('What is your name?'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should render multiple items', (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'name',
            type: QuestionnaireItemType.string,
            text: 'Name',
          ),
          QuestionnaireItem(
            linkId: 'age',
            type: QuestionnaireItemType.integer,
            text: 'Age',
          ),
          QuestionnaireItem(
            linkId: 'consent',
            type: QuestionnaireItemType.boolean,
            text: 'Do you consent?',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Do you consent?'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should render groups with nested items',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'demographics',
            type: QuestionnaireItemType.group,
            text: 'Demographics',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Full Name',
              ),
            ],
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Demographics'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should build group children lazily while scrolling',
        (WidgetTester tester) async {
      final questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'bigGroup',
            type: QuestionnaireItemType.group,
            text: 'Big Group',
            item: List.generate(
              60,
              (i) => QuestionnaireItem(
                linkId: 'q$i',
                type: QuestionnaireItemType.string,
                text: 'Question $i',
              ),
            ),
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The group is flattened into one list entry per question, so items far
      // below the viewport must not be built yet.
      expect(find.text('Question 0'), findsOneWidget);
      expect(find.text('Question 59'), findsNothing);

      // After scrolling to the bottom the last question is built and visible.
      await tester.scrollUntilVisible(
        find.text('Question 59'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Question 59'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should update response when answering questions',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'name',
            type: QuestionnaireItemType.string,
            text: 'What is your name?',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pumpAndSettle();

      // Generate response
      final response = controller.generateQuestionnaireResponse();
      final nameItem = response.item?.firstWhere(
        (i) => i.linkId == 'name',
      );
      expect(
        nameItem?.answer?.first.valueString,
        equals('John Doe'),
      );

      controller.dispose();
    });

    testWidgets('should render display items', (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'instructions',
            type: QuestionnaireItemType.display_,
            text: 'Please read carefully.',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Please read carefully.'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should render choice items', (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'gender',
            type: QuestionnaireItemType.choice,
            text: 'Gender',
            answerOption: [
              QuestionnaireAnswerOption(
                valueCoding: Coding(
                  code: 'male',
                  display: 'Male',
                ),
              ),
              QuestionnaireAnswerOption(
                valueCoding: Coding(
                  code: 'female',
                  display: 'Female',
                ),
              ),
            ],
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should use custom builder when provided',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'custom',
            type: QuestionnaireItemType.display_,
            text: 'Custom Item',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
              displayItemBuilder: (index, isLastItem, item) {
                return Container(
                  key: const Key('custom_display'),
                  child: Text('Custom: ${item.text}'),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom_display')), findsOneWidget);
      expect(find.text('Custom: Custom Item'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should render in read-only mode when configured',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'name',
            type: QuestionnaireItemType.string,
            text: 'Name',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
        forceReadOnlyView: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without errors in read-only mode
      expect(find.text('Name'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should prefill with initial response',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'name',
            type: QuestionnaireItemType.string,
            text: 'Name',
          ),
        ],
      );

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: 'name',
            answer: [
              QuestionnaireResponseAnswer(
                valueString: 'Jane Doe',
              ),
            ],
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
        initialQuestionnaireResponse: initialResponse,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The text field should contain the initial value
      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, equals('Jane Doe'));

      controller.dispose();
    });

    testWidgets('should use ListView.builder for rendering',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'item1',
            type: QuestionnaireItemType.string,
            text: 'Item 1',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireListViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should use ListView for efficient rendering
      expect(find.byType(ListView), findsOneWidget);

      controller.dispose();
    });
  });
}
