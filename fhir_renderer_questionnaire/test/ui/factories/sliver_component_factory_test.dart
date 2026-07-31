import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_attachment_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_boolean_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_choice_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_date_time_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_display_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_field_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_group_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_open_choice_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_reference_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/factories/sliver_component_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SliverComponentFactory', () {
    late SliverComponentFactory factory;

    setUp(() {
      factory = const SliverComponentFactory();
    });

    QuestionnaireItem createItem(QuestionnaireItemType type, String linkId) {
      return QuestionnaireItem(
        linkId: FhirString(linkId),
        type: type,
        text: FhirString('Test Item'),
      );
    }

    test('should create sliver display item', () {
      final item = createItem(QuestionnaireItemType.display_, 'display-1');
      final widget = factory.createDisplayItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverDisplayItem>());
    });

    test('should create sliver boolean item', () {
      final item = createItem(QuestionnaireItemType.boolean, 'bool-1');
      final widget = factory.createBooleanItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverBooleanItem>());
    });

    test('should create sliver field item', () {
      final item = createItem(QuestionnaireItemType.string, 'string-1');
      final widget = factory.createFieldItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverFieldItem>());
    });

    test('should create sliver date time item', () {
      final item = createItem(QuestionnaireItemType.date, 'date-1');
      final widget = factory.createDateTimeItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverDateTimeItem>());
    });

    test('should create sliver choice item', () {
      final item = QuestionnaireItem(
        linkId: FhirString('choice-1'),
        type: QuestionnaireItemType.choice,
        text: FhirString('Test Choice'),
        answerOption: [
          QuestionnaireAnswerOption(
            valueX: Coding(
              code: FhirCode('opt1'),
              display: FhirString('Option 1'),
            ),
          ),
        ],
      );
      final widget = factory.createChoiceItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverChoiceItem>());
    });

    test('should create sliver open choice item', () {
      final item = QuestionnaireItem(
        linkId: FhirString('open-choice-1'),
        type: QuestionnaireItemType.openChoice,
        text: FhirString('Test Open Choice'),
        answerOption: [
          QuestionnaireAnswerOption(
            valueX: Coding(
              code: FhirCode('opt1'),
              display: FhirString('Option 1'),
            ),
          ),
        ],
      );
      final widget = factory.createOpenChoiceItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverOpenChoiceItem>());
    });

    test('should create sliver group item', () {
      final item = QuestionnaireItem(
        linkId: FhirString('group-1'),
        type: QuestionnaireItemType.group,
        text: FhirString('Test Group'),
        item: [
          createItem(QuestionnaireItemType.string, 'nested-1'),
        ],
      );
      final widget = factory.createGroupItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverGroupItem>());
    });

    test('should create sliver attachment item', () {
      final item = createItem(QuestionnaireItemType.attachment, 'attachment-1');
      final widget = factory.createAttachmentItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverAttachmentItem>());
    });

    test('should create sliver reference item', () {
      final item = createItem(QuestionnaireItemType.reference, 'ref-1');
      final widget = factory.createReferenceItem(0, false, item);
      expect(widget, isA<QuestionnaireSliverReferenceItem>());
    });

    test('should create unimplemented item with type name', () {
      final widget = factory.createUnimplementedItem('quantity', false);
      expect(widget, isNotNull);
    });

    test('should create sliver item wrapper', () {
      final item = createItem(QuestionnaireItemType.string, 'wrapped-1');
      final widget = factory.createItemWrapper(
        index: 0,
        questionnaireItem: item,
        isLastItem: false,
      );
      expect(widget, isNotNull);
    });

    test('should pass isLastItem flag to sliver display item', () {
      final item = createItem(QuestionnaireItemType.display_, 'display-1');
      final widget = factory.createDisplayItem(0, true, item)
          as QuestionnaireSliverDisplayItem;
      expect(widget.isLastItem, isTrue);
    });

    test('should pass isLastItem flag to sliver boolean item', () {
      final item = createItem(QuestionnaireItemType.boolean, 'bool-1');
      final widget = factory.createBooleanItem(0, true, item)
          as QuestionnaireSliverBooleanItem;
      expect(widget.isLastItem, isTrue);
    });

    test('should pass index to sliver field item', () {
      final item = createItem(QuestionnaireItemType.string, 'string-1');
      final widget = factory.createFieldItem(5, false, item)
          as QuestionnaireSliverFieldItem;
      expect(widget.index, equals(5));
    });

    test('should pass questionnaire item to sliver date time item', () {
      final item = createItem(QuestionnaireItemType.date, 'date-1');
      final widget = factory.createDateTimeItem(0, false, item)
          as QuestionnaireSliverDateTimeItem;
      expect(widget.questionnaireItem.linkId.valueString, equals('date-1'));
    });
  });
}
