import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnaireSliversViewRenderer', () {
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
            body: QuestionnaireSliversViewRenderer(
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

    testWidgets('should use CustomScrollView', (WidgetTester tester) async {
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
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireSliversViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);

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
            body: QuestionnaireSliversViewRenderer(
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
              QuestionnaireItem(
                linkId: 'age',
                type: QuestionnaireItemType.integer,
                text: 'Age',
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
            body: QuestionnaireSliversViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Demographics'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);

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
            body: QuestionnaireSliversViewRenderer(
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
            body: QuestionnaireSliversViewRenderer(
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
            body: QuestionnaireSliversViewRenderer(
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

    testWidgets('should support ScrollController',
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

      final scrollController = ScrollController();
      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
        listViewScrollController: scrollController,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireSliversViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without error with scroll controller
      expect(find.text('Name'), findsOneWidget);

      scrollController.dispose();
      controller.dispose();
    });

    testWidgets('should render in read-only mode', (WidgetTester tester) async {
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
            body: QuestionnaireSliversViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

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
            body: QuestionnaireSliversViewRenderer(
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

    testWidgets('should handle boolean items', (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'consent',
            type: QuestionnaireItemType.boolean,
            text: 'Do you agree?',
          ),
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnaireSliversViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Do you agree?'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      // Select Yes
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      final response = controller.generateQuestionnaireResponse();
      final consentItem = response.item?.firstWhere(
        (i) => i.linkId == 'consent',
      );
      expect(consentItem?.answer?.first.valueBoolean, equals(true));

      controller.dispose();
    });
  });
}
