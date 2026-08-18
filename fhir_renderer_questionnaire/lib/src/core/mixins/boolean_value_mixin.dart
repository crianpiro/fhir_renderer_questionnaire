import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';

/// Mixin providing boolean value extraction logic for FHIR questionnaire items.
///
/// Handles initial and selected value retrieval for boolean type questions.
mixin BooleanValueMixin {
  /// Determines the initial or currently selected boolean value.
  ///
  /// Priority order:
  /// 1. Selected response item answer (if exists)
  /// 2. Initial value from questionnaire item definition
  /// 3. null (no value selected)
  ///
  /// Returns null if neither a response nor initial value is available.
  bool? getInitialOrSelectedValue(
    QuestionnaireResponseItem? responseItem,
    QuestionnaireItem questionnaireItem,
  ) {
    return responseItem?.answer?.firstOrNull?.valueBoolean ??
        questionnaireItem.initial?.firstOrNull?.valueBoolean;
  }
}
