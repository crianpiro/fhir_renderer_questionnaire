import 'package:flutter/widgets.dart';

final class ItemBehavioralData {
  final int index;
  final bool markAsRequired;
  final List<String>? dependentOn;
  final FocusNode focusNode;
  final TextEditingController? textController;

  /// Regular expression pattern for validating field input.
  /// Extracted from FHIR extension: http://hl7.org/fhir/StructureDefinition/regex
  final String? regexValidationPattern;

  /// Error message to display when regex validation fails.
  final String? regexValidationError;

  ItemBehavioralData({
    required this.index,
    required this.markAsRequired,
    required this.focusNode,
    this.textController,
    this.dependentOn,
    this.regexValidationPattern,
    this.regexValidationError,
  });

  ItemBehavioralData copyWith({
    int? index,
    bool? enabled,
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
