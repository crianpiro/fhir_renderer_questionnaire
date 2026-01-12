import 'package:fhir_r4/fhir_r4.dart';

/// Example questionnaire demonstrating regex validation using FHIR extensions.
///
/// This questionnaire showcases how to use the standard FHIR regex extension
/// (http://hl7.org/fhir/StructureDefinition/regex) to validate user input
/// against specific patterns.
Questionnaire regexValidationExample = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "regex-validation-example",
  "status": "active",
  "title": "Regex Validation Example",
  "item": [
    {
      "linkId": "email",
      "text": "Email Address",
      "type": "string",
      "required": true,
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Please enter a valid email address (e.g., user@example.com)"
        }
      ]
    },
    {
      "linkId": "phone",
      "text": "Phone Number (US Format)",
      "type": "string",
      "required": false,
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Format: (123) 456-7890 or 123-456-7890"
        }
      ]
    },
    {
      "linkId": "zipcode",
      "text": "ZIP Code",
      "type": "string",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^\d{5}(-\d{4})?$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Format: 12345 or 12345-6789"
        }
      ]
    },
    {
      "linkId": "url-field",
      "text": "Website URL",
      "type": "url",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^https?://[^\s/$.?#].[^\s]*$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Must start with http:// or https://"
        }
      ]
    },
    {
      "linkId": "date-ddmmyyyy",
      "text": "Date (DD/MM/YYYY)",
      "type": "string",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/\d{4}$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Format: DD/MM/YYYY (e.g., 31/12/2025)"
        }
      ]
    },
    {
      "linkId": "alphanumeric",
      "text": "Alphanumeric Code (6 characters)",
      "type": "string",
      "maxLength": 6,
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^[A-Z0-9]{6}$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString":
              "Must be exactly 6 uppercase letters or numbers (e.g., ABC123)"
        }
      ]
    },
    {
      "linkId": "notes",
      "text": "Additional Notes (No validation)",
      "type": "text"
    }
  ]
});
