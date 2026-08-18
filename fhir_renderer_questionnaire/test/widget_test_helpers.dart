import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/item_behavioral_data.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/inherited_questionnaire_renderer.dart';
import 'package:flutter/material.dart';

/// Test helper class for creating mock FHIR data and test widgets
class WidgetTestHelpers {
  /// Creates a minimal questionnaire with a single item
  static Questionnaire createQuestionnaire({
    required List<QuestionnaireItem> items,
    String? id,
    String? title,
  }) {
    return Questionnaire(
      id: id,
      status: QuestionnairePublicationStatus.active,
      title: title,
      item: items,
    );
  }

  /// Creates a boolean questionnaire item
  static QuestionnaireItem createBooleanItem({
    required String linkId,
    String? text,
    bool? required,
    bool? initialValue,
  }) {
    // Use fromJson for items with initial values
    final json = <String, dynamic>{
      'linkId': linkId,
      'type': 'boolean',
      if (text != null) 'text': text,
      if (required != null) 'required': required,
      if (initialValue != null)
        'initial': [
          {'valueBoolean': initialValue}
        ],
    };
    return QuestionnaireItem.fromJson(json);
  }

  /// Creates a string/text field questionnaire item
  static QuestionnaireItem createStringItem({
    required String linkId,
    String? text,
    bool? required,
    String? initialValue,
    QuestionnaireItemType type = QuestionnaireItemType.string,
    int? maxLength,
  }) {
    final typeStr = _itemTypeToString(type);
    final json = <String, dynamic>{
      'linkId': linkId,
      'type': typeStr,
      if (text != null) 'text': text,
      if (required != null) 'required': required,
      if (maxLength != null) 'maxLength': maxLength,
      if (initialValue != null)
        'initial': [
          {'valueString': initialValue}
        ],
    };
    return QuestionnaireItem.fromJson(json);
  }

  /// Creates a display questionnaire item
  static QuestionnaireItem createDisplayItem({
    required String linkId,
    String? text,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: QuestionnaireItemType.display_,
      text: text,
    );
  }

  /// Creates a choice questionnaire item
  static QuestionnaireItem createChoiceItem({
    required String linkId,
    String? text,
    bool? required,
    bool? repeats,
    List<QuestionnaireAnswerOption>? answerOptions,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: QuestionnaireItemType.choice,
      text: text,
      required_: required,
      repeats: repeats,
      answerOption: answerOptions ??
          [
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'option1',
                display: 'Option 1',
              ),
            ),
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'option2',
                display: 'Option 2',
              ),
            ),
          ],
    );
  }

  /// Creates an open-choice questionnaire item
  static QuestionnaireItem createOpenChoiceItem({
    required String linkId,
    String? text,
    bool? required,
    bool? repeats,
    List<QuestionnaireAnswerOption>? answerOptions,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: QuestionnaireItemType.openChoice,
      text: text,
      required_: required,
      repeats: repeats,
      answerOption: answerOptions ??
          [
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'option1',
                display: 'Option 1',
              ),
            ),
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'option2',
                display: 'Option 2',
              ),
            ),
          ],
    );
  }

  /// Creates a date questionnaire item
  static QuestionnaireItem createDateItem({
    required String linkId,
    String? text,
    bool? required,
    QuestionnaireItemType type = QuestionnaireItemType.date,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: type,
      text: text,
      required_: required,
    );
  }

  /// Creates a group questionnaire item
  static QuestionnaireItem createGroupItem({
    required String linkId,
    String? text,
    List<QuestionnaireItem>? items,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: QuestionnaireItemType.group,
      text: text,
      item: items,
    );
  }

  /// Creates an integer questionnaire item
  static QuestionnaireItem createIntegerItem({
    required String linkId,
    String? text,
    bool? required,
    int? initialValue,
  }) {
    final json = <String, dynamic>{
      'linkId': linkId,
      'type': 'integer',
      if (text != null) 'text': text,
      if (required != null) 'required': required,
      if (initialValue != null)
        'initial': [
          {'valueInteger': initialValue}
        ],
    };
    return QuestionnaireItem.fromJson(json);
  }

  /// Creates a decimal questionnaire item
  static QuestionnaireItem createDecimalItem({
    required String linkId,
    String? text,
    bool? required,
    double? initialValue,
  }) {
    final json = <String, dynamic>{
      'linkId': linkId,
      'type': 'decimal',
      if (text != null) 'text': text,
      if (required != null) 'required': required,
      if (initialValue != null)
        'initial': [
          {'valueDecimal': initialValue}
        ],
    };
    return QuestionnaireItem.fromJson(json);
  }

  /// Creates a URL questionnaire item
  static QuestionnaireItem createUrlItem({
    required String linkId,
    String? text,
    bool? required,
  }) {
    return QuestionnaireItem(
      linkId: linkId,
      type: QuestionnaireItemType.url,
      text: text,
      required_: required,
    );
  }

  /// Creates an initial QuestionnaireResponse for a questionnaire
  static QuestionnaireResponse createEmptyResponse(Questionnaire questionnaire) {
    return QuestionnaireResponse(
      status: QuestionnaireResponseStatus.inProgress,
      questionnaire: questionnaire.id != null
          ? 'Questionnaire/${questionnaire.id}'
          : null,
      item: questionnaire.item
          ?.map((item) => QuestionnaireResponseItem(
                linkId: item.linkId,
              ))
          .toList(),
    );
  }

  /// Creates a response item with a boolean answer
  static QuestionnaireResponseItem createBooleanResponseItem({
    required String linkId,
    required bool value,
  }) {
    return QuestionnaireResponseItem(
      linkId: linkId,
      answer: [
        QuestionnaireResponseAnswer(valueBoolean: value),
      ],
    );
  }

  /// Creates a response item with a string answer
  static QuestionnaireResponseItem createStringResponseItem({
    required String linkId,
    required String value,
  }) {
    return QuestionnaireResponseItem(
      linkId: linkId,
      answer: [
        QuestionnaireResponseAnswer(valueString: value),
      ],
    );
  }

  /// Helper to convert QuestionnaireItemType to JSON string
  static String _itemTypeToString(QuestionnaireItemType type) {
    switch (type) {
      case QuestionnaireItemType.string:
        return 'string';
      case QuestionnaireItemType.text:
        return 'text';
      case QuestionnaireItemType.integer:
        return 'integer';
      case QuestionnaireItemType.decimal:
        return 'decimal';
      case QuestionnaireItemType.url:
        return 'url';
      case QuestionnaireItemType.boolean:
        return 'boolean';
      case QuestionnaireItemType.date:
        return 'date';
      case QuestionnaireItemType.dateTime:
        return 'dateTime';
      case QuestionnaireItemType.time:
        return 'time';
      case QuestionnaireItemType.choice:
        return 'choice';
      case QuestionnaireItemType.openChoice:
        return 'open-choice';
      case QuestionnaireItemType.quantity:
        return 'quantity';
      case QuestionnaireItemType.group:
        return 'group';
      case QuestionnaireItemType.display_:
        return 'display';
      default:
        return 'string';
    }
  }
}

/// A test wrapper widget that provides the InheritedQuestionnaireRenderer context
class TestQuestionnaireWrapper extends StatefulWidget {
  final Widget child;
  final Questionnaire questionnaire;
  final QuestionnaireResponse? initialResponse;
  final bool readOnly;
  final void Function(QuestionnaireResponse)? onResponseChanged;

  const TestQuestionnaireWrapper({
    super.key,
    required this.child,
    required this.questionnaire,
    this.initialResponse,
    this.readOnly = false,
    this.onResponseChanged,
  });

  @override
  State<TestQuestionnaireWrapper> createState() =>
      _TestQuestionnaireWrapperState();
}

class _TestQuestionnaireWrapperState extends State<TestQuestionnaireWrapper> {
  late QuestionnaireResponse _response;
  late RendererQuestionnaireController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RendererQuestionnaireController(
      questionnaire: widget.questionnaire,
      initialQuestionnaireResponse: widget.initialResponse,
      forceReadOnlyView: widget.readOnly,
    );
    _response = widget.initialResponse ??
        WidgetTestHelpers.createEmptyResponse(widget.questionnaire);

    // Pre-populate indexed items for all questionnaire items
    _populateIndexedItems(widget.questionnaire.item);
  }

  void _populateIndexedItems(List<QuestionnaireItem>? items,
      [int startIndex = 0]) {
    if (items == null) return;
    int index = startIndex;
    for (final item in items) {
      final linkId = item.linkId;
      if (!_controller.indexedItems.containsKey(linkId)) {
        _controller.indexedItems[linkId] = ItemBehavioralData(
          index: index,
          markAsRequired: false,
          focusNode: FocusNode(),
        );
        index++;
      }
      // Handle nested items in groups
      if (item.item != null) {
        _populateIndexedItems(item.item, index);
      }
    }
  }

  void _onResponseChanged(QuestionnaireResponse response) {
    setState(() {
      _response = response;
    });
    widget.onResponseChanged?.call(response);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InheritedQuestionnaireRenderer(
          questionnaire: widget.questionnaire,
          questionnaireResponse: _response,
          rendererController: _controller,
          checkRequiredItems: false,
          readOnly: widget.readOnly,
          onResponseChanged: _onResponseChanged,
          child: widget.child,
        ),
      ),
    );
  }
}
