import 'package:fhir_renderer_questionnaire/src/ui/renderers/page_view_renderer/questionnaire_page_view.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../layout/base_questionnaire_renderer.dart';

/// A questionnaire renderer widget that displays questionnaire items in a paginated view.
///
/// This widget extends [BaseQuestionnaireRenderer] to provide a page-based layout for
/// rendering FHIR questionnaires. Items are displayed one or more per page, allowing
/// users to navigate through pages, making it suitable for step-by-step questionnaires.
///
/// The widget is final and cannot be extended.
final class QuestionnairePageViewRenderer extends BaseQuestionnaireRenderer {
  final void Function(int)? onPageChanged;

  /// Creates a questionnaire page view renderer.
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
  ///   * [key] - Optional widget key
  const QuestionnairePageViewRenderer({
    required super.rendererController,
    super.choiceItemBuilder,
    super.openChoiceItemBuilder,
    super.fieldItemBuilder,
    super.dateTimeItemBuilder,
    super.groupItemBuilder,
    super.boolItemBuilder,
    super.displayItemBuilder,
    this.onPageChanged,
    super.key,
  });

  /// Creates the mutable state for this widget.
  ///
  /// Returns a [_QuestionnairePageViewRendererState] that manages the state and
  /// rendering of the page view questionnaire.
  ///
  /// Returns:
  ///   A [BaseQuestionnaireState] instance for managing widget state.
  @override
  BaseQuestionnaireState createState() => _QuestionnairePageViewRendererState();
}

/// The state class for [QuestionnairePageViewRenderer].
///
/// Manages the widget state and builds the UI by wrapping the questionnaire in
/// an [InheritedQuestionnaireRenderer] and displaying it in a page view.
final class _QuestionnairePageViewRendererState extends BaseQuestionnaireState {
  /// Builds the widget tree for the page view questionnaire renderer.
  ///
  /// Creates an [InheritedQuestionnaireRenderer] widget to provide questionnaire
  /// context to descendant widgets, then displays the questionnaire in a
  /// [QuestionnairePageView]. Also provides the renderer controller instance to
  /// the parent widget via callback.
  ///
  /// Parameters:
  ///   * [context] - The build context
  ///
  /// Returns:
  ///   A [Widget] representing the page view questionnaire UI.
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
      rendererController: widget.rendererController,
      onResponseChanged: onResponseChanged,
      readOnly: readOnly,
      child: const QuestionnairePageView(),
    );
  }
}
