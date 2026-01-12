/// Mixin providing regex validation logic for FHIR questionnaire text field items.
///
/// Handles validation of text input against regex patterns defined in FHIR extensions.
/// Uses the standard FHIR regex extension: http://hl7.org/fhir/StructureDefinition/regex
mixin RegexValidationMixin {
  /// Validates the input against a regex pattern.
  ///
  /// Returns an error message if validation fails, null if valid.
  ///
  /// Parameters:
  /// - [value]: The input value to validate
  /// - [regexPattern]: The regex pattern to match against (from FHIR extension)
  /// - [errorMessage]: Custom error message to display (optional, defaults to 'Invalid format')
  ///
  /// Behavior:
  /// - Returns null for empty/null values (not considered invalid)
  /// - Returns null if no regex pattern is provided (no validation needed)
  /// - Returns error message if value doesn't match the pattern
  /// - Returns null if regex pattern is invalid (graceful degradation)
  String? validateInput(
    String? value,
    String? regexPattern,
    String? errorMessage,
  ) {
    // Empty values are not considered invalid (use required field for that)
    if (value == null || value.isEmpty) return null;

    // No pattern means no validation needed
    if (regexPattern == null || regexPattern.isEmpty) return null;

    try {
      final regex = RegExp(regexPattern);
      if (!regex.hasMatch(value)) {
        return errorMessage ?? 'Invalid format';
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
  bool isValid(String? value, String? regexPattern) {
    return validateInput(value, regexPattern, null) == null;
  }
}
