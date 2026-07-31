import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:flutter/material.dart';

import '../data/item_behavioral_data.dart';

/// A controller for managing the state and behavior of a FHIR Questionnaire renderer.
///
/// This controller provides access to the underlying scroll controllers, manages
/// field-level data (such as focus nodes and required status), and triggers
/// response generation.
///
/// It can be extended to provide custom controller logic if needed.
class RendererQuestionnaireController {
  /// Callback function to generate the current questionnaire response.
  ///
  /// This is typically set by the `BaseQuestionnaireRenderer` when the renderer is initialized.
  QuestionnaireResponse Function()? onGenerateQuestionnaireResponse;

  void Function()? onReadOnlyModeChanged;

  void Function(QuestionnaireResponse)? onExternalResponseUpdate;

  bool forceReadOnlyView;

  /// The FHIR Questionnaire to be rendered.
  final Questionnaire questionnaire;

  /// The initial questionnaire response.
  QuestionnaireResponse? initialQuestionnaireResponse;

  /// Optional [PageController] for controlling page navigation in [QuestionnairePageViewRenderer].
  final PageController? pageViewController;

  /// Optional [ScrollController] for controlling list scrolling in [QuestionnaireListViewRenderer]
  /// or [QuestionnaireSliversViewRenderer].
  final ScrollController? listViewScrollController;

  /// The initial index to scroll to in the sliver list.
  final int sliversInitialIndex;

  /// A list of global keys for group items, used for auto-scrolling to specific groups.
  final List<GlobalKey> groupBundleKeys = [];

  /// A map of behavioral data for indexed items, keyed by the item's linkId.
  ///
  /// This includes focus nodes and required status, allowing the controller to
  /// manage focus and validation.
  final Map<String, ItemBehavioralData> indexedItems = {};

  /// A map of auxiliary text controllers for items that need multiple text inputs.
  ///
  /// Key format: "linkId_suffix" (e.g., "item1_display" for a secondary display field).
  /// This map is used for items like reference fields that have both a reference
  /// and a display name input.
  final Map<String, TextEditingController> auxiliaryTextControllers = {};

  /// Cache for enableWhen condition evaluation results.
  /// Key format: "linkId:responseHashCode"
  /// Value: whether the item is enabled
  /// This cache is cleared when the response changes.
  final Map<String, bool> _enableWhenCache = {};

  /// Creates a [RendererQuestionnaireController].
  ///
  /// The [questionnaire] parameter is required and defines the structure of the
  /// questionnaire to be rendered.
  ///
  /// The [initialQuestionnaireResponse] can be provided to pre-fill the questionnaire.
  /// If not provided, an initial response will be generated based on the [questionnaire].
  ///
  /// [sliversInitialIndex] determines the initial scroll position when using
  /// [QuestionnaireSliversViewRenderer].
  ///
  /// [listViewScrollController] and [pageViewController] allow external control
  /// over scrolling and pagination.
  RendererQuestionnaireController({
    required this.questionnaire,
    this.sliversInitialIndex = 0,
    this.listViewScrollController,
    this.pageViewController,
    this.initialQuestionnaireResponse,
    this.onGenerateQuestionnaireResponse,
    this.forceReadOnlyView = false,
  }) {
    initialQuestionnaireResponse ??= FhirRendererQuestionnaireResponseUtils
        .generateInitialQuestionnaireResponse(
      questionnaire,
    );
  }

  void updateQuestionnaireResponse(QuestionnaireResponse response) {
    initialQuestionnaireResponse = response;
    onExternalResponseUpdate?.call(response);
  }

  void updateReadOnlyMode(bool enableReadOnly) {
    forceReadOnlyView = enableReadOnly;
    onReadOnlyModeChanged?.call();
  }

  /// Gets a cached enableWhen evaluation result.
  /// Returns null if not cached.
  bool? getCachedEnableWhen(String linkId, int responseHashCode) {
    return _enableWhenCache['$linkId:$responseHashCode'];
  }

  /// Caches an enableWhen evaluation result.
  void cacheEnableWhen(String linkId, int responseHashCode, bool enabled) {
    _enableWhenCache['$linkId:$responseHashCode'] = enabled;
  }

  /// Clears the enableWhen cache. Should be called when the response changes.
  void clearEnableWhenCache() {
    _enableWhenCache.clear();
  }

  /// Generates the current [QuestionnaireResponse] from the renderer's state.
  ///
  /// This method calls the [onGenerateQuestionnaireResponse] callback which collects
  /// the data from the widget tree and triggers validation of required fields.
  QuestionnaireResponse generateQuestionnaireResponse() {
    return onGenerateQuestionnaireResponse?.call() ??
        initialQuestionnaireResponse!;
  }

  /// Disposes of all resources held by this controller.
  ///
  /// This method should be called when the controller is no longer needed,
  /// typically in the dispose method of the widget using this controller.
  /// It cleans up FocusNodes, TextEditingControllers, and other resources
  /// to prevent memory leaks.
  void dispose() {
    // Dispose all FocusNodes and TextEditingControllers
    onGenerateQuestionnaireResponse = null;
    for (final itemData in indexedItems.values) {
      itemData.focusNode.dispose();
      itemData.textController?.dispose();
    }
    indexedItems.clear();
    // Dispose auxiliary text controllers
    for (final controller in auxiliaryTextControllers.values) {
      controller.dispose();
    }
    auxiliaryTextControllers.clear();
    groupBundleKeys.clear();
  }
}
