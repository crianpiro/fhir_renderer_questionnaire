import 'package:fhir_r4/fhir_r4.dart';
import '../validation/default_validation_patterns.dart';

/// Mixin providing regex validation logic for FHIR questionnaire text field items.
///
/// Handles validation of text input against regex patterns defined in FHIR extensions
/// or default patterns for specific field types (integer, decimal, URL, quantity).
/// Uses the standard FHIR regex extension: http://hl7.org/fhir/StructureDefinition/regex
mixin RegexValidationMixin {
  /// Validates the input against a regex pattern with support for default patterns.
  ///
  /// Returns an error message if validation fails, null if valid.
  ///
  /// Parameters:
  /// - [value]: The input value to validate
  /// - [customPattern]: Custom regex pattern from FHIR extension (takes precedence)
  /// - [customErrorMessage]: Custom error message for the pattern
  /// - [itemType]: The questionnaire item type (used for default validation)
  ///
  /// Validation Priority:
  /// 1. If customPattern is provided, uses that
  /// 2. Otherwise, checks for default pattern based on itemType
  /// 3. If no pattern available, no validation is performed
  ///
  /// Behavior:
  /// - Returns null for empty/null values (not considered invalid)
  /// - Returns null if no pattern is available (no validation needed)
  /// - Returns error message if value doesn't match the pattern
  /// - Returns null if regex pattern is invalid (graceful degradation)
  String? validateInput(
    String? value,
    String? customPattern,
    String? customErrorMessage, {
    QuestionnaireItemType? itemType,
  }) {
    // Empty values are not considered invalid (use required field for that)
    if (value == null || value.isEmpty) return null;

    // Determine which pattern and error message to use
    String? patternToUse = customPattern;
    String? errorMessageToUse = customErrorMessage;

    // If no custom pattern, check for default pattern based on item type
    if ((patternToUse == null || patternToUse.isEmpty) && itemType != null) {
      patternToUse = DefaultValidationPatterns.getPatternForType(itemType);
      // Only use default error message if no custom message was provided
      if (patternToUse != null && errorMessageToUse == null) {
        errorMessageToUse =
            DefaultValidationPatterns.getErrorMessageForType(itemType);
      }
    }

    // No pattern means no validation needed
    if (patternToUse == null || patternToUse.isEmpty) return null;

    try {
      final regex = RegExp(patternToUse);
      if (!regex.hasMatch(value)) {
        return errorMessageToUse ?? 'Invalid format';
      }
    } catch (e) {
      // Invalid regex pattern - don't break the UI, just skip validation
      // In production, this could be logged for debugging
      return null;
    }

    return null;
  }

  /// Validates the input and returns whether it's valid.
  ///
  /// Convenience method that returns a boolean instead of an error message.
  bool isValid(
    String? value,
    String? customPattern, {
    QuestionnaireItemType? itemType,
  }) {
    return validateInput(
          value,
          customPattern,
          null,
          itemType: itemType,
        ) ==
        null;
  }
}
