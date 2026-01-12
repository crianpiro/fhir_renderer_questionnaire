import 'package:fhir_r4/fhir_r4.dart';

/// Mixin providing choice/coding value extraction logic for FHIR questionnaire items.
///
/// Handles single-select choice questions with coding values.
mixin ChoiceValueMixin {
  /// Determines the initial or currently selected choice code.
  ///
  /// Priority order:
  /// 1. Selected response item answer coding (if exists)
  /// 2. Initial value from questionnaire item definition
  /// 3. null (no value selected)
  ///
  /// Returns the code string of the selected/initial coding, or null if none.
  String? getInitialOrSelectedValue(
    QuestionnaireResponseItem? responseItem,
    QuestionnaireItem questionnaireItem,
  ) {
    if (responseItem != null) {
      return responseItem.answer?.firstOrNull?.valueCoding?.code?.valueString;
    } else if (questionnaireItem.initial != null &&
        questionnaireItem.initial!.isNotEmpty &&
        questionnaireItem.initial!.first.valueX is Coding &&
        (questionnaireItem.initial!.first.valueX as Coding).code?.valueString !=
            null) {
      return (questionnaireItem.initial!.first.valueX as Coding)
          .code
          ?.valueString;
    }
    return null;
  }
}
