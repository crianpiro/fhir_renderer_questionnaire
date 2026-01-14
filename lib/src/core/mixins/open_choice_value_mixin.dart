import 'package:fhir_r4/fhir_r4.dart';

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
      if (answer.valueX is FhirString) {
        return (answer.valueX as FhirString).valueString;
      }
    }
    return null;
  }

  // Note: isOptionSelected, getDisplayValue, and getSelectedCodingValue
  // are inherited from ChoiceBaseMixin
}
