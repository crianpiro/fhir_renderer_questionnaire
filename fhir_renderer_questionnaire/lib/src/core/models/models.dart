/// The package's own FHIR R4 models.
///
/// These replace the `fhir_r4` package: this library models only the
/// Questionnaire and QuestionnaireResponse resources and the datatypes they
/// use, so the package carries no heavyweight FHIR dependency.
///
/// Everything crosses the boundary as JSON:
///
/// ```dart
/// final questionnaire = Questionnaire.fromJson(jsonDecode(source));
/// final json = response.toJson();
/// ```
///
/// Fields outside the rendered subset are preserved verbatim through a
/// parse/serialize round-trip rather than being dropped.
library;

export 'fhir_data_types.dart';
export 'fhir_primitives.dart';
export 'questionnaire.dart';
export 'questionnaire_enums.dart';
export 'questionnaire_response.dart';
