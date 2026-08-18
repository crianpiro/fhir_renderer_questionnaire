import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_attachment_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_boolean_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_choice_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_date_time_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_display_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_field_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_open_choice_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_reference_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoxComponentFactory', () {
    late BoxComponentFactory factory;

    setUp(() {
      factory = const BoxComponentFactory();
    });

    QuestionnaireItem createItem(QuestionnaireItemType type, String linkId) {
      return QuestionnaireItem(
        linkId: linkId,
        type: type,
        text: 'Test Item',
      );
    }

    test('should create display item', () {
      final item = createItem(QuestionnaireItemType.display_, 'display-1');
      final widget = factory.createDisplayItem(0, false, item);
      expect(widget, isA<QuestionnaireDisplayItem>());
    });

    test('should create boolean item', () {
      final item = createItem(QuestionnaireItemType.boolean, 'bool-1');
      final widget = factory.createBooleanItem(0, false, item);
      expect(widget, isA<QuestionnaireBooleanItem>());
    });

    test('should create field item', () {
      final item = createItem(QuestionnaireItemType.string, 'string-1');
      final widget = factory.createFieldItem(0, false, item);
      expect(widget, isA<QuestionnaireFieldItem>());
    });

    test('should create date time item', () {
      final item = createItem(QuestionnaireItemType.date, 'date-1');
      final widget = factory.createDateTimeItem(0, false, item);
      expect(widget, isA<QuestionnaireDateTimeItem>());
    });

    test('should create choice item', () {
      const item = QuestionnaireItem(
        linkId: 'choice-1',
        type: QuestionnaireItemType.choice,
        text: 'Test Choice',
        answerOption: [
          QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'opt1',
              display: 'Option 1',
            ),
          ),
        ],
      );
      final widget = factory.createChoiceItem(0, false, item);
      expect(widget, isA<QuestionnaireChoiceItem>());
    });

    test('should create open choice item', () {
      const item = QuestionnaireItem(
        linkId: 'open-choice-1',
        type: QuestionnaireItemType.openChoice,
        text: 'Test Open Choice',
        answerOption: [
          QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'opt1',
              display: 'Option 1',
            ),
          ),
        ],
      );
      final widget = factory.createOpenChoiceItem(0, false, item);
      expect(widget, isA<QuestionnaireOpenChoiceItem>());
    });

    test('should create group item', () {
      final item = QuestionnaireItem(
        linkId: 'group-1',
        type: QuestionnaireItemType.group,
        text: 'Test Group',
        item: [
          createItem(QuestionnaireItemType.string, 'nested-1'),
        ],
      );
      final widget = factory.createGroupItem(0, false, item);
      expect(widget, isA<QuestionnaireGroupItem>());
    });

    test('should create attachment item', () {
      final item = createItem(QuestionnaireItemType.attachment, 'attachment-1');
      final widget = factory.createAttachmentItem(0, false, item);
      expect(widget, isA<QuestionnaireAttachmentItem>());
    });

    test('should create reference item', () {
      final item = createItem(QuestionnaireItemType.reference, 'ref-1');
      final widget = factory.createReferenceItem(0, false, item);
      expect(widget, isA<QuestionnaireReferenceItem>());
    });

    test('should create unimplemented item with type name', () {
      final widget = factory.createUnimplementedItem('quantity', false);
      expect(widget, isNotNull);
    });

    test('should create item wrapper', () {
      final item = createItem(QuestionnaireItemType.string, 'wrapped-1');
      final widget = factory.createItemWrapper(
        index: 0,
        questionnaireItem: item,
        isLastItem: false,
      );
      expect(widget, isNotNull);
    });

    test('should pass isLastItem flag to display item', () {
      final item = createItem(QuestionnaireItemType.display_, 'display-1');
      final widget = factory.createDisplayItem(0, true, item)
          as QuestionnaireDisplayItem;
      expect(widget.isLastItem, isTrue);
    });

    test('should pass isLastItem flag to boolean item', () {
      final item = createItem(QuestionnaireItemType.boolean, 'bool-1');
      final widget =
          factory.createBooleanItem(0, true, item) as QuestionnaireBooleanItem;
      expect(widget.isLastItem, isTrue);
    });

    test('should pass index to field item', () {
      final item = createItem(QuestionnaireItemType.string, 'string-1');
      final widget =
          factory.createFieldItem(5, false, item) as QuestionnaireFieldItem;
      expect(widget.index, equals(5));
    });

    test('should pass questionnaire item to date time item', () {
      final item = createItem(QuestionnaireItemType.date, 'date-1');
      final widget = factory.createDateTimeItem(0, false, item)
          as QuestionnaireDateTimeItem;
      expect(widget.questionnaireItem.linkId, equals('date-1'));
    });
  });
}
