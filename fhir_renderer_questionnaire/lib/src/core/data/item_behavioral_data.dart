import 'package:flutter/widgets.dart';

/// Holds behavioral and state data for a questionnaire item during rendering.
///
/// This class encapsulates all the runtime state and behavioral information
/// needed for a questionnaire item, including validation, focus management,
/// and item relationships.
///
/// Used internally by the renderer to manage item-level state.
final class ItemBehavioralData {
  /// The position of this item within its parent group or questionnaire.
  final int index;

  /// Whether this item should be visually marked as required.
  /// Combines the item's `required` field with enableWhen conditions.
  final bool markAsRequired;

  /// List of linkIds that this item depends on via enableWhen conditions.
  /// Used to track conditional dependencies for efficient re-evaluation.
  final List<String>? dependentOn;

  /// Focus node for this item, used to manage focus state in forms.
  /// Properly disposed when the renderer is disposed.
  final FocusNode focusNode;

  /// Text editing controller for text field items (string, text, integer, etc).
  /// Null for non-text-input items. Properly disposed when the renderer is disposed.
  final TextEditingController? textController;

  /// Regular expression pattern for validating field input.
  /// Extracted from FHIR extension: http://hl7.org/fhir/StructureDefinition/regex
  /// If null, may fall back to default patterns based on item type.
  final String? regexValidationPattern;

  /// Error message to display when regex validation fails.
  /// Extracted from FHIR extension: http://hl7.org/fhir/StructureDefinition/entryFormat
  /// If null, uses default error messages.
  final String? regexValidationError;

  /// Creates an instance of [ItemBehavioralData].
  ///
  /// The [index], [markAsRequired], and [focusNode] parameters are required.
  /// Other parameters are optional based on the item type and configuration.
  ItemBehavioralData({
    required this.index,
    required this.markAsRequired,
    required this.focusNode,
    this.textController,
    this.dependentOn,
    this.regexValidationPattern,
    this.regexValidationError,
  });

  /// Creates a copy of this [ItemBehavioralData] with optional field overrides.
  ///
  /// This is useful for updating specific fields while maintaining others.
  ItemBehavioralData copyWith({
    int? index,
    bool? markAsRequired,
    FocusNode? focusNode,
    List<String>? dependentOn,
    TextEditingController? textController,
    String? regexValidationPattern,
    String? regexValidationError,
  }) =>
      ItemBehavioralData(
        index: index ?? this.index,
        focusNode: focusNode ?? this.focusNode,
        dependentOn: dependentOn ?? this.dependentOn,
        markAsRequired: markAsRequired ?? this.markAsRequired,
        textController: textController ?? this.textController,
        regexValidationPattern: regexValidationPattern ?? this.regexValidationPattern,
        regexValidationError: regexValidationError ?? this.regexValidationError,
      );
}
