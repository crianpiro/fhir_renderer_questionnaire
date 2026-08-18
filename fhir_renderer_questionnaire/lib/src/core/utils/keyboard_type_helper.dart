import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/services.dart';

/// Helper class to determine the appropriate keyboard type for questionnaire item types.
///
/// Provides optimized keyboard configurations for different FHIR questionnaire field types,
/// improving user experience by showing the most relevant keyboard for each input type.
class KeyboardTypeHelper {
  KeyboardTypeHelper._();

  /// Gets the appropriate TextInputType for a given questionnaire item type.
  ///
  /// Returns the most suitable keyboard type based on the expected input:
  /// - `integer`: Number keyboard (no decimal point)
  /// - `decimal`: Decimal keyboard (with decimal point)
  /// - `quantity`: Decimal keyboard (numeric values)
  /// - `url`: URL keyboard (with .com, /, etc.)
  /// - `text`: Multiline text keyboard
  /// - `string`: Default text keyboard
  ///
  /// Returns null for types without specific keyboard requirements.
  static TextInputType? getKeyboardType(QuestionnaireItemType? type) {
    if (type == null) return null;

    switch (type) {
      case QuestionnaireItemType.integer:
        // Number keyboard without decimal point
        // Allows negative numbers with minus sign
        return const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        );

      case QuestionnaireItemType.decimal:
      case QuestionnaireItemType.quantity:
        // Number keyboard with decimal point
        // Allows negative numbers and decimal values
        return const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        );

      case QuestionnaireItemType.url:
        // URL keyboard with .com, /, etc.
        return TextInputType.url;

      case QuestionnaireItemType.text:
        // Multiline text input
        return TextInputType.multiline;

      case QuestionnaireItemType.string:
        // Single line text input
        return TextInputType.text;

      default:
        // No specific keyboard type for other types
        return null;
    }
  }

  /// Gets the appropriate text input action for a given questionnaire item type.
  ///
  /// Returns:
  /// - `TextInputAction.newline` for multiline text fields
  /// - `TextInputAction.next` for other fields (to move to next field)
  static TextInputAction? getTextInputAction(QuestionnaireItemType? type) {
    if (type == null) return null;

    switch (type) {
      case QuestionnaireItemType.text:
        // For multiline text, allow new line
        return TextInputAction.newline;

      default:
        // For other fields, move to next field
        return TextInputAction.next;
    }
  }

  /// Gets the appropriate input formatters for a given questionnaire item type.
  ///
  /// Returns formatters that restrict input to valid characters:
  /// - `integer`: Only digits and minus sign
  /// - `decimal`/`quantity`: Digits, minus sign, and decimal point
  /// - Other types: No restrictions
  static List<TextInputFormatter>? getInputFormatters(
      QuestionnaireItemType? type) {
    if (type == null) return null;

    switch (type) {
      case QuestionnaireItemType.integer:
        // Allow only digits and minus sign (at start)
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
        ];

      case QuestionnaireItemType.decimal:
      case QuestionnaireItemType.quantity:
        // Allow digits, minus sign (at start), and single decimal point
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ];

      default:
        // No input restrictions for other types
        return null;
    }
  }

  /// Checks if a questionnaire item type should have a specific keyboard type.
  static bool hasSpecificKeyboardType(QuestionnaireItemType? type) {
    return getKeyboardType(type) != null;
  }
}
