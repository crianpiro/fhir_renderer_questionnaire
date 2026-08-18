import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnairePageViewRenderer', () {
    testWidgets('should render first page on initial load',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'Page 1',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Name',
              ),
            ],
          ),
          QuestionnaireItem(
            linkId: 'page2',
            type: QuestionnaireItemType.group,
            text: 'Page 2',
            item: [
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
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // First page should be visible
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should use PageView for navigation',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'Page 1',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Name',
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
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should navigate between pages with swipe',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'First Page',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Name',
              ),
            ],
          ),
          QuestionnaireItem(
            linkId: 'page2',
            type: QuestionnaireItemType.group,
            text: 'Second Page',
            item: [
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
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on first page
      expect(find.text('First Page'), findsOneWidget);

      // Swipe left to go to next page
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // Now on second page
      expect(find.text('Second Page'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should allow PageController navigation',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'First Page',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Name',
              ),
            ],
          ),
          QuestionnaireItem(
            linkId: 'page2',
            type: QuestionnaireItemType.group,
            text: 'Second Page',
            item: [
              QuestionnaireItem(
                linkId: 'age',
                type: QuestionnaireItemType.integer,
                text: 'Age',
              ),
            ],
          ),
        ],
      );

      final pageController = PageController();
      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
        pageViewController: pageController,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to page 2 programmatically
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      await tester.pumpAndSettle();

      expect(find.text('Second Page'), findsOneWidget);

      pageController.dispose();
      controller.dispose();
    });

    testWidgets('should render non-group items as pages',
        (WidgetTester tester) async {
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
        ],
      );

      final controller = RendererQuestionnaireController(
        questionnaire: questionnaire,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should update response across pages',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'Page 1',
            item: [
              QuestionnaireItem(
                linkId: 'name',
                type: QuestionnaireItemType.string,
                text: 'Name',
              ),
            ],
          ),
          QuestionnaireItem(
            linkId: 'page2',
            type: QuestionnaireItemType.group,
            text: 'Page 2',
            item: [
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
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter name on first page
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pumpAndSettle();

      // Verify response is updated
      final response = controller.generateQuestionnaireResponse();
      final nameItem = FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
        response,
        'name',
      );
      expect(nameItem?.answer?.first.valueString, equals('John Doe'));

      controller.dispose();
    });

    testWidgets('should use custom builder when provided',
        (WidgetTester tester) async {
      const questionnaire = Questionnaire(
        status: QuestionnairePublicationStatus.active,
        item: [
          QuestionnaireItem(
            linkId: 'page1',
            type: QuestionnaireItemType.group,
            text: 'Page 1',
            item: [
              QuestionnaireItem(
                linkId: 'info',
                type: QuestionnaireItemType.display_,
                text: 'Info',
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
            body: QuestionnairePageViewRenderer(
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
      expect(find.text('Custom: Info'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should render in read-only mode',
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
            body: QuestionnairePageViewRenderer(
              rendererController: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);

      controller.dispose();
    });
  });
}
