import 'package:fhir_r4/fhir_r4.dart';

/// Default regex validation patterns for FHIR questionnaire item types.
///
/// These patterns are used as fallbacks when a questionnaire item doesn't
/// specify a custom regex pattern via FHIR extensions. They ensure basic
/// data type validation for numeric and URL fields.
class DefaultValidationPatterns {
  DefaultValidationPatterns._();

  /// Integer validation: positive or negative whole numbers
  /// Examples: 42, -17, 0, 100
  static const String integer = r'^-?\d+$';

  /// Decimal validation: numbers with optional decimal point
  /// Examples: 3.14, -0.5, 42, 100.00
  static const String decimal = r'^-?\d+(\.\d+)?$';

  /// URL validation: basic URL format requiring http:// or https://
  /// Examples: https://example.com, http://test.org/path
  static const String url = r'^https?://[^\s/$.?#].[^\s]*$';

  /// Quantity validation: same as decimal (validates the numeric value)
  /// The unit is stored separately in FHIR quantity objects
  /// Examples: 5.5, 120, -10.25
  static const String quantity = r'^-?\d+(\.\d+)?$';

  /// Default error messages for each type
  static final Map<QuestionnaireItemType, String> defaultErrorMessages = {
    QuestionnaireItemType.integer: 'Must be a valid integer',
    QuestionnaireItemType.decimal: 'Must be a valid decimal number',
    QuestionnaireItemType.url:
        'Must be a valid URL starting with http:// or https://',
    QuestionnaireItemType.quantity: 'Must be a valid number',
  };

  /// Gets the default regex pattern for a given questionnaire item type.
  ///
  /// Returns null for types that don't have default validation (text, string).
  static String? getPatternForType(QuestionnaireItemType? type) {
    if (type == null) return null;

    switch (type) {
      case QuestionnaireItemType.integer:
        return integer;
      case QuestionnaireItemType.decimal:
        return decimal;
      case QuestionnaireItemType.url:
        return url;
      case QuestionnaireItemType.quantity:
        return quantity;
      default:
        return null; // text, string, and other types have no default validation
    }
  }

  /// Gets the default error message for a given questionnaire item type.
  ///
  /// Returns null for types without default validation.
  static String? getErrorMessageForType(QuestionnaireItemType? type) {
    if (type == null) return null;
    return defaultErrorMessages[type];
  }

  /// Checks if a questionnaire item type has default validation.
  static bool hasDefaultValidation(QuestionnaireItemType? type) {
    return getPatternForType(type) != null;
  }
}
