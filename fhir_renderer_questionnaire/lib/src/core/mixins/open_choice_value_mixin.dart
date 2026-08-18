import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';

import 'choice_base_mixin.dart';

/// Mixin providing open-choice value logic for FHIR questionnaire items.
///
/// Handles open-choice questions that allow both predefined options and custom text input.
/// Extends ChoiceBaseMixin to inherit common functionality.
mixin OpenChoiceValueMixin on ChoiceBaseMixin {

  /// Gets the custom text value (valueString) from response item if exists.
  ///
  /// Returns the string value or null if no string answer exists.
  String? getCustomTextValue(QuestionnaireResponseItem? responseItem) {
    if (responseItem?.answer == null) return null;

    for (final answer in responseItem!.answer!) {
      if (answer.valueString != null) {
        return answer.valueString;
      }
    }
    return null;
  }

  // Note: isOptionSelected, getDisplayValue, and getSelectedCodingValue
  // are inherited from ChoiceBaseMixin
}
