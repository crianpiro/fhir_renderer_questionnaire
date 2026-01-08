import 'package:fhir_r4/fhir_r4.dart';
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
  RendererQuestionnaireController({
    this.sliversInitialIndex = 0,
    this.listViewScrollController,
    this.pageViewController,
    this.onGenerateQuestionnaireResponse,
  });

  /// Generates the current [QuestionnaireResponse] from the renderer's state.
  ///
  /// This method calls the [onGenerateQuestionnaireResponse] callback which collects
  /// the data from the widget tree and triggers validation of required fields.
  QuestionnaireResponse generateQuestionnaireResponse() {
    return onGenerateQuestionnaireResponse!();
  }
}
