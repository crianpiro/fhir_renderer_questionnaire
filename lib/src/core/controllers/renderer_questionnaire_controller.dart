import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:flutter/material.dart';

import '../data/field_behavioral_data.dart';

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
  final Map<String, FieldBehavioralData> indexedItems = {};

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

  void updateReadOnlyMode(bool enableReadOnly) {
    forceReadOnlyView = enableReadOnly;
    onReadOnlyModeChanged?.call();
  }

  /// Generates the current [QuestionnaireResponse] from the renderer's state.
  ///
  /// This method calls the [onGenerateQuestionnaireResponse] callback which collects
  /// the data from the widget tree and triggers validation of required fields.
  QuestionnaireResponse generateQuestionnaireResponse() {
    return onGenerateQuestionnaireResponse?.call() ??
        initialQuestionnaireResponse!;
  }
}
