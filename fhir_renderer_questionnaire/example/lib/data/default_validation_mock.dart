import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';

/// Example questionnaire demonstrating DEFAULT validation for field types.
///
/// This questionnaire showcases automatic validation that happens WITHOUT
/// needing to specify regex extensions. The library automatically validates:
/// - integer: whole numbers only
/// - decimal: numbers with optional decimal point
/// - url: valid HTTP/HTTPS URLs
/// - quantity: numeric values
///
/// Compare this with regex_validation_mock.dart which shows CUSTOM validation.
Questionnaire defaultValidationExample = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "default-validation-example",
  "status": "active",
  "title": "Default Validation Example",
  "item": [
    {
      "linkId": "age",
      "text": "Age (years)",
      "type": "integer",
      "required": true,
      // No extension needed! Automatically validates integers
    },
    {
      "linkId": "height",
      "text": "Height (meters)",
      "type": "decimal",
      "required": false,
      // No extension needed! Automatically validates decimals
    },
    {
      "linkId": "weight",
      "text": "Weight",
      "type": "quantity",
      "required": false,
      // No extension needed! Automatically validates numeric quantity
    },
    {
      "linkId": "website",
      "text": "Personal Website",
      "type": "url",
      "required": false,
      // No extension needed! Automatically validates URLs
    },
    {
      "linkId": "negative-test",
      "text": "Temperature (celsius, can be negative)",
      "type": "decimal",
      "required": false,
      // Accepts negative numbers: -10.5, 36.6, etc.
    },
    {
      "linkId": "bio",
      "text": "Biography",
      "type": "text",
      // No validation for text fields - accepts anything
    },
    {
      "linkId": "custom-integer",
      "text": "Custom Integer (Age 0-120)",
      "type": "integer",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^([0-9]|[1-9][0-9]|1[01][0-9]|120)$",
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Age must be between 0 and 120",
        },
      ],
      // Custom regex OVERRIDES the default integer validation
      // This shows you can be more specific when needed
    },
    {
      "linkId": "notes",
      "text": "Additional Notes",
      "type": "string",
      // No validation for string fields
    },
  ],
});
