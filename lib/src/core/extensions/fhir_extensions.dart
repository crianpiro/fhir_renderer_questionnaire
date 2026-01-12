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
}
