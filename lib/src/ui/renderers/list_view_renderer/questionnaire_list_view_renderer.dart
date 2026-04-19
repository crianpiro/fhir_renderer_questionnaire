import 'package:fhir_renderer_questionnaire/src/ui/renderers/list_view_renderer/questionnaire_list_view.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../layout/base_questionnaire_renderer.dart';

/// A questionnaire renderer widget that displays questionnaire items in a scrollable list view.
///
/// This widget extends [BaseQuestionnaireRenderer] to provide a list-based layout for
/// rendering FHIR questionnaires. Items are displayed vertically in a scrollable list,
/// making it suitable for questionnaires with multiple items.
///
/// The widget is final and cannot be extended.
final class QuestionnaireListViewRenderer extends BaseQuestionnaireRenderer {
  /// Creates a questionnaire list view renderer.
  ///
  /// All parameters are required as specified by [BaseQuestionnaireRenderer].
  ///
  /// Parameters:
  ///   * [rendererController] - The renderer controller instance
  ///   * [choiceItemBuilder] - Optional custom builder for choice items
  ///   * [openChoiceItemBuilder] - Optional custom builder for open choice items
  ///   * [fieldItemBuilder] - Optional custom builder for field items
  ///   * [dateTimeItemBuilder] - Optional custom builder for date/time items
  ///   * [groupItemBuilder] - Optional custom builder for group items
  ///   * [boolItemBuilder] - Optional custom builder for boolean items
  ///   * [displayItemBuilder] - Optional custom builder for display items
  ///   * [referenceItemBuilder] - Optional custom builder for reference items
  ///   * [attachmentItemBuilder] - Optional custom builder for attachment items
  ///   * [useExpansibleGroups] - When `true`, renders group items as
  ///     collapsible `ExpansionTile`-based widgets. Defaults to `false`.
  ///   * [key] - Optional widget key
  const QuestionnaireListViewRenderer(
      {required super.rendererController,
      super.choiceItemBuilder,
      super.openChoiceItemBuilder,
      super.fieldItemBuilder,
      super.dateTimeItemBuilder,
      super.groupItemBuilder,
      super.boolItemBuilder,
      super.displayItemBuilder,
      super.referenceItemBuilder,
      super.attachmentItemBuilder,
      super.key,
      super.useExpansibleGroups});

  /// Creates the mutable state for this widget.
  ///
  /// Returns a [_QuestionnaireListViewRendererState] that manages the state and
  /// rendering of the list view questionnaire.
  ///
  /// Returns:
  ///   A [BaseQuestionnaireState] instance for managing widget state.
  @override
  BaseQuestionnaireState createState() => _QuestionnaireListViewRendererState();
}

/// The state class for [QuestionnaireListViewRenderer].
///
/// Manages the widget state and builds the UI by wrapping the questionnaire in
/// an [InheritedQuestionnaireRenderer] and displaying it in a list view.
final class _QuestionnaireListViewRendererState extends BaseQuestionnaireState {
  /// Builds the widget tree for the list view questionnaire renderer.
  ///
  /// Creates an [InheritedQuestionnaireRenderer] widget to provide questionnaire
  /// context to descendant widgets, then displays the questionnaire in a
  /// [QuestionnaireListView].
  ///
  /// Parameters:
  ///   * [context] - The build context
  ///
  /// Returns:
  ///   A [Widget] representing the list view questionnaire UI.
  @override
  Widget build(BuildContext context) {
    return InheritedQuestionnaireRenderer(
      questionnaireResponse: questionnaireResponse,
      questionnaire: widget.rendererController.questionnaire,
      checkRequiredItems: checkRequiredItems,
      choiceItemBuilder: widget.choiceItemBuilder,
      openChoiceItemBuilder: widget.openChoiceItemBuilder,
      fieldItemBuilder: widget.fieldItemBuilder,
      groupItemBuilder: widget.groupItemBuilder,
      dateTimeItemBuilder: widget.dateTimeItemBuilder,
      boolItemBuilder: widget.boolItemBuilder,
      displayItemBuilder: widget.displayItemBuilder,
      referenceItemBuilder: widget.referenceItemBuilder,
      attachmentItemBuilder: widget.attachmentItemBuilder,
      rendererController: widget.rendererController,
      readOnly: readOnly,
      onResponseChanged: onResponseChanged,
      child: QuestionnaireListView(
          useExpansibleGroups: widget.useExpansibleGroups),
    );
  }
}
