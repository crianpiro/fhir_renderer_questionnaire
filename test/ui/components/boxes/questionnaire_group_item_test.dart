import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireGroupItem', () {
    testWidgets('should render group title', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'demographics',
        text: 'Demographics',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'name',
            text: 'Name',
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      expect(find.text('Demographics'), findsOneWidget);
    });

    testWidgets('should render nested items', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'demographics',
        text: 'Demographics',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'name',
            text: 'Full Name',
          ),
          WidgetTestHelpers.createIntegerItem(
            linkId: 'age',
            text: 'Age',
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
    });

    testWidgets('should render with border decoration',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'demographics',
        text: 'Demographics',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'name',
            text: 'Name',
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      // Group items should have a Container with BoxDecoration for border
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundBorderedContainer = false;
      for (final container in containers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.border != null) {
            foundBorderedContainer = true;
            break;
          }
        }
      }
      expect(foundBorderedContainer, isTrue);
    });

    testWidgets('should render empty group with no items',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'empty_group',
        text: 'Empty Group',
        items: [],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      expect(find.text('Empty Group'), findsOneWidget);
      // Should still render without errors
      expect(find.byType(QuestionnaireGroupItem), findsOneWidget);
    });

    testWidgets('should render nested groups', (WidgetTester tester) async {
      final nestedGroup = WidgetTestHelpers.createGroupItem(
        linkId: 'address',
        text: 'Address',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'street',
            text: 'Street',
          ),
          WidgetTestHelpers.createStringItem(
            linkId: 'city',
            text: 'City',
          ),
        ],
      );

      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'contact_info',
        text: 'Contact Information',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'email',
            text: 'Email',
          ),
          nestedGroup,
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
      expect(find.text('Street'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);
    });

    testWidgets('should render header with primary container color',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'demographics',
        text: 'Demographics',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'name',
            text: 'Name',
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      // Header should have a colored background from primaryContainer
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundColoredContainer = false;
      for (final container in containers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color != null) {
            foundColoredContainer = true;
            break;
          }
        }
      }
      expect(foundColoredContainer, isTrue);
    });

    testWidgets('should handle multiple item types within group',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createGroupItem(
        linkId: 'patient_info',
        text: 'Patient Information',
        items: [
          WidgetTestHelpers.createStringItem(
            linkId: 'name',
            text: 'Full Name',
          ),
          WidgetTestHelpers.createBooleanItem(
            linkId: 'consent',
            text: 'Do you consent?',
          ),
          WidgetTestHelpers.createDisplayItem(
            linkId: 'info',
            text: 'Please read carefully.',
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: SingleChildScrollView(
            child: QuestionnaireGroupItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        ),
      );

      expect(find.text('Patient Information'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Do you consent?'), findsOneWidget);
      expect(find.text('Please read carefully.'), findsOneWidget);
    });
  });
}
