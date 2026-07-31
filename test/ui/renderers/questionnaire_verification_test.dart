import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_segments.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_item_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

QuestionnaireItem _string(String linkId, String text, {bool required = false}) =>
    QuestionnaireItem(
      linkId: FhirString(linkId),
      type: QuestionnaireItemType.string,
      text: FhirString(text),
      required_: FhirBoolean(required),
    );

QuestionnaireItem _group(String linkId, String text,
        {required List<QuestionnaireItem> children}) =>
    QuestionnaireItem(
      linkId: FhirString(linkId),
      type: QuestionnaireItemType.group,
      text: FhirString(text),
      item: children,
    );

/// A questionnaire long enough that its tail sits outside the cache extent.
Questionnaire _longQuestionnaire() => Questionnaire(
      status: PublicationStatus.active,
      item: [
        for (var i = 0; i < 40; i++) _string('q$i', 'Question $i'),
        _string('last', 'Last question', required: true),
      ],
    );

void main() {
  group('verification of items that are not rendered', () {
    testWidgets('reports a required item far below the viewport',
        (WidgetTester tester) async {
      final controller =
          RendererQuestionnaireController(questionnaire: _longQuestionnaire());

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireListViewRenderer(rendererController: controller),
        ),
      ));
      await tester.pumpAndSettle();

      // Precondition: the offending item has never been built, so the widget
      // tree holds nothing about it.
      expect(find.text('Last question'), findsNothing);
      expect(controller.indexedItems.containsKey('last'), isFalse);

      controller.generateQuestionnaireResponse();
      await tester.pumpAndSettle();

      expect(controller.lastFindings, hasLength(1));
      expect(controller.lastFindings.single.linkId, 'last');
      expect(
        controller.lastFindings.single.reason,
        QuestionnaireFindingReason.missingRequired,
      );
      // Revealed through the primary scroll controller, without the host
      // having supplied one.
      expect(find.text('Last question'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('scrolls an unbuilt offending item into view',
        (WidgetTester tester) async {
      final controller = RendererQuestionnaireController(
        questionnaire: _longQuestionnaire(),
        listViewScrollController: ScrollController(),
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireListViewRenderer(rendererController: controller),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Last question'), findsNothing);

      controller.generateQuestionnaireResponse();
      await tester.pumpAndSettle();

      expect(find.text('Last question'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('validate() is side-effect free and enableWhen aware',
        (WidgetTester tester) async {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _string('trigger', 'Trigger'),
          QuestionnaireItem(
            linkId: FhirString('conditional'),
            type: QuestionnaireItemType.string,
            text: FhirString('Conditional'),
            required_: FhirBoolean(true),
            enableWhen: [
              QuestionnaireEnableWhen(
                question: FhirString('trigger'),
                operator_: QuestionnaireItemOperator.eq,
                answerX: FhirString('yes'),
              ),
            ],
          ),
        ],
      );

      final controller =
          RendererQuestionnaireController(questionnaire: questionnaire);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireListViewRenderer(rendererController: controller),
        ),
      ));
      await tester.pumpAndSettle();

      // Disabled: not reported, and no required-item highlighting triggered.
      expect(controller.validate(), isEmpty);
      expect(controller.lastFindings, isEmpty);

      await tester.enterText(find.byType(TextFormField).first, 'yes');
      await tester.pumpAndSettle();

      final findings = controller.validate();
      expect(findings.single.linkId, 'conditional');

      controller.dispose();
    });
  });

  group('nested group flattening', () {
    testWidgets('hoists nested group entries into the list',
        (WidgetTester tester) async {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _group('outer', 'Outer group', children: [
            _string('direct', 'Direct child'),
            _group('inner', 'Inner group', children: [
              _string('nested', 'Nested child'),
            ]),
          ]),
        ],
      );

      final controller =
          RendererQuestionnaireController(questionnaire: questionnaire);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireListViewRenderer(rendererController: controller),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Outer group'), findsOneWidget);
      expect(find.text('Inner group'), findsOneWidget);
      expect(find.text('Direct child'), findsOneWidget);
      expect(find.text('Nested child'), findsOneWidget);

      // Both groups contribute their own header entry...
      expect(find.byType(QuestionnaireGroupHeader), findsNWidgets(2));
      // ...and the nested entries re-create the outer group's surface.
      expect(find.byType(QuestionnaireGroupSurface), findsWidgets);

      controller.dispose();
    });
  });

  group('slivers renderer laziness', () {
    testWidgets('builds group children through a lazy SliverList',
        (WidgetTester tester) async {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _group('section', 'Section', children: [
            _string('a', 'Question A'),
            _string('b', 'Question B'),
          ]),
        ],
      );

      final controller =
          RendererQuestionnaireController(questionnaire: questionnaire);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireSliversViewRenderer(rendererController: controller),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SliverList), findsOneWidget);
      expect(find.text('Question A'), findsOneWidget);
      expect(find.text('Question B'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('keeps eager sliver children when a custom builder is set',
        (WidgetTester tester) async {
      final questionnaire = Questionnaire(
        status: PublicationStatus.active,
        item: [
          _group('section', 'Section', children: [
            _string('a', 'Question A'),
          ]),
        ],
      );

      final controller =
          RendererQuestionnaireController(questionnaire: questionnaire);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuestionnaireSliversViewRenderer(
            rendererController: controller,
            fieldItemBuilder: (index, isLastItem, fieldController,
                    selectedResponse, item, onAnswerChanged) =>
                SliverToBoxAdapter(
              child: Text('custom ${item.text?.valueString}'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // A custom builder returns a sliver, which cannot be a SliverList child.
      expect(find.byType(SliverList), findsNothing);
      expect(find.byType(QuestionnaireSliverItemWrapper), findsWidgets);
      expect(find.text('custom Question A'), findsOneWidget);

      controller.dispose();
    });
  });
}
