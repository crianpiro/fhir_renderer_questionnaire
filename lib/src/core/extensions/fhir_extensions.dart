import 'package:fhir_r4/fhir_r4.dart';

extension FhirRendererQuestionnaireExtensions on Resource {
  FhirCanonical get getFhirCanonical =>
      FhirCanonical('${resourceType.name}/$id');
}
