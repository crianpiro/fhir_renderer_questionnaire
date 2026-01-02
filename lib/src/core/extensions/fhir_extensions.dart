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
