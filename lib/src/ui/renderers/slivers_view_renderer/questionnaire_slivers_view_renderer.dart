import 'package:fhir_renderer_questionnaire/src/ui/renderers/slivers_view_renderer/questionnaire_slivers_view.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../layout/base_questionnaire_renderer.dart';

/// A questionnaire renderer widget that displays questionnaire items using slivers.
///
/// This widget extends [BaseQuestionnaireRenderer] to provide a sliver-based layout for
/// rendering FHIR questionnaires. Slivers provide advanced scrolling capabilities with
/// better performance for complex layouts. This is suitable for questionnaires with
/// custom scroll behavior like sticky headers or parallax effects.
///
/// The widget is final and cannot be extended.
final class QuestionnaireSliversViewRenderer extends BaseQuestionnaireRenderer {
  /// Creates a questionnaire slivers view renderer.
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
  const QuestionnaireSliversViewRenderer({
    required super.rendererController,
    super.choiceItemBuilder,
    super.openChoiceItemBuilder,
    super.fieldItemBuilder,
    super.dateTimeItemBuilder,
    super.groupItemBuilder,
    super.boolItemBuilder,
    super.displayItemBuilder,
    super.referenceItemBuilder,
    super.key,
  });

  /// Creates the mutable state for this widget.
  ///
  /// Returns a [_QuestionnaireSliversViewRendererState] that manages the state and
  /// rendering of the slivers view questionnaire.
  ///
  /// Returns:
  ///   A [BaseQuestionnaireState] instance for managing widget state.
  @override
  BaseQuestionnaireState createState() =>
      _QuestionnaireSliversViewRendererState();
}

/// The state class for [QuestionnaireSliversViewRenderer].
///
/// Manages the widget state and builds the UI by wrapping the questionnaire in
/// an [InheritedQuestionnaireRenderer] and displaying it using slivers for
/// advanced scrolling behavior.
final class _QuestionnaireSliversViewRendererState
    extends BaseQuestionnaireState {
  /// Builds the widget tree for the slivers view questionnaire renderer.
  ///
  /// Creates an [InheritedQuestionnaireRenderer] widget to provide questionnaire
  /// context to descendant widgets, then displays the questionnaire using slivers
  /// via [QuestionnaireSliversView]. Also provides the renderer controller instance
  /// to the parent widget via callback.
  ///
  /// Parameters:
  ///   * [context] - The build context
  ///
  /// Returns:
  ///   A [Widget] representing the slivers view questionnaire UI.
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
      rendererController: widget.rendererController,
      onResponseChanged: onResponseChanged,
      readOnly: readOnly,
      child: const QuestionnaireSliversView(),
    );
  }
}
