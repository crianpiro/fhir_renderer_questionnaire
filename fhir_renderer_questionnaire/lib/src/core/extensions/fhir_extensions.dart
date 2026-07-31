import 'package:fhir_r4/fhir_r4.dart';

/// Extensions for FHIR [Resource] to enhance functionality specific to
/// FHIR Renderer Questionnaire.
extension FhirRendererQuestionnaireExtensions on Resource {
  /// Creates a [FhirCanonical] URI pointing to the resource type and its ID.
  ///
  /// Combines the [resourceType] and the [id] of the resource to form
  /// a canonical URL string, useful for referencing the resource.
  FhirCanonical get getFhirCanonical =>
      FhirCanonical('${resourceType.name}/$id');
}

/// Extensions for FHIR [QuestionnaireItem] to resolve display text.
extension QuestionnaireItemDisplayExtensions on QuestionnaireItem {
  /// Title shown for the item, falling back to its first code when `text` is
  /// absent and to an empty string when neither is present.
  String get displayTitle =>
      text?.valueString ?? code?.firstOrNull?.code?.valueString ?? "";
}

/// Extensions for FHIR [QuestionnaireItem] to extract validation-related extensions.
extension QuestionnaireItemValidationExtensions on QuestionnaireItem {
  /// Extracts the regex validation pattern from the FHIR extension.
  ///
  /// Looks for the standard FHIR regex extension:
  /// http://hl7.org/fhir/StructureDefinition/regex
  ///
  /// Returns the regex pattern string if found, null otherwise.
  String? get regexValidationPattern {
    if (extension_?.isEmpty ?? true) return null;

    for (final ext in extension_!) {
      if (ext.url.toString() == 'http://hl7.org/fhir/StructureDefinition/regex') {
        if (ext.valueString != null) {
          return ext.valueString!.valueString;
        }
      }
    }

    return null;
  }

  /// Extracts a custom validation error message from the FHIR extension.
  ///
  /// Looks for a custom extension for validation error messages.
  /// This is optional and falls back to a default message if not found.
  ///
  /// Returns the error message string if found, null for default message.
  String? get regexValidationErrorMessage {
    if (extension_?.isEmpty ?? true) return null;

    // Look for entryFormat extension which can provide hint text
    for (final ext in extension_!) {
      if (ext.url.toString() == 'http://hl7.org/fhir/StructureDefinition/entryFormat') {
        if (ext.valueString != null) {
          return ext.valueString!.valueString;
        }
      }
    }

    return null;
  }

  /// Extracts the questionnaire-itemControl extension code.
  ///
  /// Looks for the FHIR SDC extension:
  /// http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl
  ///
  /// Supported control codes:
  /// - 'drop-down': Dropdown/select menu
  /// - 'radio-button': Radio buttons (default for single-select choice)
  /// - 'check-box': Checkboxes (default for multi-select choice)
  /// - 'autocomplete': Searchable dropdown with type-ahead
  ///
  /// Returns the control code string if found, null otherwise.
  String? get itemControlCode {
    if (extension_?.isEmpty ?? true) return null;

    for (final ext in extension_!) {
      if (ext.url.toString() ==
          'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl') {
        return ext.valueCodeableConcept?.coding?.firstOrNull?.code?.valueString;
      }
    }

    return null;
  }
}

/// Extensions for FHIR [QuestionnaireAnswerOption] to extract SDC behavior flags.
extension QuestionnaireAnswerOptionExtensions on QuestionnaireAnswerOption {
  /// Whether this answer option is mutually exclusive with all others.
  ///
  /// Looks for the standard FHIR SDC extension:
  /// http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive
  ///
  /// In a multi-select (repeats) item, selecting an exclusive option clears
  /// every other selection, and selecting any non-exclusive option clears the
  /// exclusive ones. This implements the "all"/"none" master option behavior.
  ///
  /// Returns true when the extension is present and set to true, false otherwise.
  bool get isOptionExclusive {
    if (extension_?.isEmpty ?? true) return false;

    for (final ext in extension_!) {
      if (ext.url.toString() ==
          'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive') {
        return ext.valueBoolean?.valueBoolean ?? false;
      }
    }

    return false;
  }
}
