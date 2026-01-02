import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/widgets.dart';

import 'internal_questionnaire_controller.dart';

/// Controller for managing and accessing questionnaire rendering state.
///
/// Provides a public interface to interact with questionnaire responses and UI controllers
/// for scroll and page navigation. Acts as a facade to the internal questionnaire controller.
final class QuestionnaireRendererController {
  final InternalQuestionnaireController _internalController;

  /// Creates a new questionnaire renderer controller.
  ///
  /// Parameters:
  ///   * [_internalController] - The internal controller managing questionnaire state
  QuestionnaireRendererController(this._internalController);

  /// Gets the currently generated questionnaire response.
  ///
  /// Retrieves the questionnaire response that has been generated based on the current
  /// state and user interactions within the questionnaire.
  ///
  /// Returns:
  ///   The [QuestionnaireResponse] object containing the current responses and state.
  QuestionnaireResponse getGeneratedQuestionnaireResponse() {
    return _internalController.generateQuestionnaireResponse.call();
  }

  /// Gets the scroll controller for list view questionnaire rendering.
  ///
  /// Returns the scroll controller used to manage scrolling in the list view
  /// questionnaire display variant.
  ///
  /// Returns:
  ///   A [ScrollController] if available, `null` if list view mode is not active.
  ScrollController? getScrollController() =>
      _internalController.listViewScrollController;

  /// Gets the page controller for page view questionnaire rendering.
  ///
  /// Returns the page controller used to manage page transitions in the page view
  /// questionnaire display variant.
  ///
  /// Returns:
  ///   A [PageController] if available, `null` if page view mode is not active.
  PageController? getPageController() => _internalController.pageViewController;
}
