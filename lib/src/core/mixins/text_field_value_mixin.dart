import 'package:fhir_r4/fhir_r4.dart';

/// Mixin providing text field value extraction logic for FHIR questionnaire items.
///
/// Handles initial value retrieval for string, text, integer, decimal, quantity, and URL types.
mixin TextFieldValueMixin {
  /// Extracts the initial value from a questionnaire item.
  ///
  /// Returns a string representation of the initial value based on the valueX type:
  /// - FhirString: direct string value
  /// - FhirDecimal: decimal as string
  /// - FhirInteger: integer as string
  /// - Quantity: quantity value as string
  /// - FhirUri: URI as string
  ///
  /// Returns empty string if no initial value is set.
  String getInitialValue(QuestionnaireItem questionnaireItem) {
    if (questionnaireItem.initial != null &&
        questionnaireItem.initial!.isNotEmpty) {
      final initial = questionnaireItem.initial!.first;
      if (initial.valueX is FhirString) {
        return (initial.valueX as FhirString).valueString ?? "";
      } else if (initial.valueX is FhirDecimal) {
        return (initial.valueX as FhirDecimal).valueDouble.toString();
      } else if (initial.valueX is FhirInteger) {
        return (initial.valueX as FhirInteger).valueInt.toString();
      } else if (initial.valueX is Quantity) {
        return (initial.valueX as Quantity).value?.valueDouble?.toString() ??
            "";
      } else if (initial.valueX is FhirUri) {
        return (initial.valueX as FhirUri).valueUri?.toString() ?? "";
      }
    }
    return "";
  }
}
