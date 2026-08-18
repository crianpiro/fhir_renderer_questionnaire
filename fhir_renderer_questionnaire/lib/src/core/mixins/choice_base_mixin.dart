import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';

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
              answer.valueCoding?.code ==
              answerOption.valueCoding?.code,
        ) ??
        questionnaireItem.initial != null &&
            questionnaireItem.initial!.any(
              (initial) =>
                  initial.valueCoding != null &&
                  initial.valueCoding?.code == answerOption.valueCoding?.code,
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
    return answerOption.valueCoding?.display ??
        answerOption.valueCoding?.code ??
        "--";
  }

  /// Gets the selected coding value code (for single-select with radio buttons).
  ///
  /// Returns the code of the first coding answer, or null if none exists.
  String? getSelectedCodingValue(QuestionnaireResponseItem? responseItem) {
    if (responseItem?.answer == null) return null;

    for (final answer in responseItem!.answer!) {
      if (answer.valueCoding != null) {
        return answer.valueCoding?.code;
      }
    }
    return null;
  }
}
