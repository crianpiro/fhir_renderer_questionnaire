import 'package:fhir_r4/fhir_r4.dart';

/// Mixin providing open-choice (multi-select) value logic for FHIR questionnaire items.
///
/// Handles multi-select choice questions where multiple answers can be selected.
mixin OpenChoiceValueMixin {
  /// Checks if a specific answer option is initially selected or currently selected.
  ///
  /// Searches both the response item answers and the initial values to determine
  /// if the given answer option's coding matches any selected values.
  ///
  /// Returns true if the answer option is selected, false otherwise.
  bool isInitialOrSelectedValue(
    QuestionnaireResponseItem? responseItem,
    QuestionnaireItem questionnaireItem,
    QuestionnaireAnswerOption answerOption,
  ) {
    return responseItem?.answer?.any(
          (answer) =>
              answer.valueCoding?.code?.valueString ==
              answerOption.valueCoding?.code?.valueString,
        ) ??
        questionnaireItem.initial != null &&
            questionnaireItem.initial!.any(
              (initial) =>
                  initial.valueX is Coding &&
                  (initial.valueX as Coding).code?.valueString ==
                      answerOption.valueCoding?.code?.valueString,
            );
  }

  /// Extracts the display value from an answer option.
  ///
  /// Priority order:
  /// 1. Coding display value
  /// 2. Coding code value
  /// 3. "--" (fallback if neither exists)
  ///
  /// Returns the most appropriate display string for the answer option.
  String getDisplayValue(QuestionnaireAnswerOption answerOption) {
    return answerOption.valueCoding?.display?.valueString ??
        answerOption.valueCoding?.code?.valueString ??
        "--";
  }
}
