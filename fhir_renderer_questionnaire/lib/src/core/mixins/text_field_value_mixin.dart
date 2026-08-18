import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/material.dart';

/// Mixin providing text field value extraction logic for FHIR questionnaire items.
///
/// Handles initial value retrieval for string, text, integer, decimal, quantity, and URL types.
mixin TextFieldValueMixin {
  /// Shared outlined [InputDecoration] used by default field widgets.
  ///
  /// Provides a rounded [OutlineInputBorder] and allows error text to wrap
  /// across two lines. Use with [InputDecoration.copyWith] to layer labels,
  /// hints, or prefix/suffix widgets on top.
  InputDecoration get getOutlineInputDecoration => InputDecoration(
      errorMaxLines: 2,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));

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
    final initial = questionnaireItem.initial?.firstOrNull;
    if (initial == null) return "";

    return initial.valueString ??
        initial.valueDecimal?.toString() ??
        initial.valueInteger?.toString() ??
        initial.valueQuantity?.value?.toString() ??
        initial.valueUri ??
        "";
  }
}
