import 'package:fhir_r4/fhir_r4.dart';

/// Base mixin providing common choice value logic for FHIR questionnaire items.
///
/// This mixin consolidates shared functionality used by choice and open-choice
/// components to follow DRY principle.
mixin ChoiceBaseMixin {
  /// Checks if a specific answer option is selected.
  ///
  /// Searches both the response item answers and the initial values to determine
  /// if the given answer option's coding matches any selected values.
  ///
  /// Returns true if the answer option is selected, false otherwise.
  bool isOptionSelected(
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

  /// Gets the selected coding value code (for single-select with radio buttons).
  ///
  /// Returns the code of the first coding answer, or null if none exists.
  String? getSelectedCodingValue(QuestionnaireResponseItem? responseItem) {
    if (responseItem?.answer == null) return null;

    for (final answer in responseItem!.answer!) {
      if (answer.valueX is Coding) {
        return (answer.valueX as Coding).code?.valueString;
      }
    }
    return null;
  }
}
