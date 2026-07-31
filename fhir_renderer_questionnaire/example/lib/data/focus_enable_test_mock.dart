import 'package:fhir_r4/fhir_r4.dart';

/// Test questionnaire for focus behavior and enableWhen logic
/// This mock demonstrates:
/// - Multiple text field items to test focus retention during typing
/// - EnableWhen behavior triggered by text field values
/// - Different field types (string, integer, text)
Questionnaire focusAndEnableWhenTest = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "focus-and-enable-when-test",
  "status": "active",
  "title": "Focus & EnableWhen Test Questionnaire",
  "description":
      "Test questionnaire for verifying focus retention and enableWhen behavior with field items",
  "item": [
    {
      "linkId": "intro",
      "type": "display",
      "text":
          "This questionnaire tests focus behavior and conditional fields (enableWhen)",
    },
    {
      "linkId": "personal_info",
      "type": "group",
      "text": "Personal Information",
      "item": [
        {
          "linkId": "full_name",
          "type": "string",
          "text": "Full Name",
          "required": true,
          "maxLength": 100,
        },
        {
          "linkId": "email",
          "type": "string",
          "text": "Email Address",
          "required": true,
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/regex",
              "valueString":
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
            },
          ],
        },
        {"linkId": "age", "type": "integer", "text": "Age", "required": true},
        {
          "linkId": "city",
          "type": "string",
          "text": "City (Type 'Other' to enable additional field)",
          "required": false,
        },
        {
          "linkId": "city_specify",
          "type": "string",
          "text": "Please specify your city",
          "required": false,
          "enableWhen": [
            {"question": "city", "operator": "=", "answerString": "Other"},
          ],
        },
      ],
    },
    {
      "linkId": "preferences",
      "type": "group",
      "text": "Preferences & Feedback",
      "item": [
        {
          "linkId": "interest_level",
          "type": "choice",
          "text": "What is your interest level?",
          "answerOption": [
            {
              "valueCoding": {"code": "low", "display": "Low"},
            },
            {
              "valueCoding": {"code": "medium", "display": "Medium"},
            },
            {
              "valueCoding": {"code": "high", "display": "High"},
            },
          ],
        },
        {
          "linkId": "high_interest_reason",
          "type": "text",
          "text": "Why are you highly interested? (Please explain in detail)",
          "enableWhen": [
            {
              "question": "interest_level",
              "operator": "=",
              "answerCoding": {"code": "high", "display": "High"},
            },
          ],
        },
        {
          "linkId": "additional_comments",
          "type": "text",
          "text": "Additional Comments (Test multi-line focus)",
          "required": false,
        },
      ],
    },
    {
      "linkId": "conditional_section",
      "type": "group",
      "text": "Conditional Questions Section",
      "item": [
        {
          "linkId": "trigger_field",
          "type": "string",
          "text": "Type 'unlock' to enable hidden questions",
          "required": false,
        },
        {
          "linkId": "hidden_question_1",
          "type": "string",
          "text": "Hidden Question 1: What is your favorite color?",
          "enableWhen": [
            {
              "question": "trigger_field",
              "operator": "=",
              "answerString": "unlock",
            },
          ],
        },
        {
          "linkId": "hidden_question_2",
          "type": "integer",
          "text": "Hidden Question 2: How many years of experience?",
          "enableWhen": [
            {
              "question": "trigger_field",
              "operator": "=",
              "answerString": "unlock",
            },
          ],
        },
        {
          "linkId": "secondary_trigger",
          "type": "string",
          "text": "Type 'admin' to enable admin field",
          "enableWhen": [
            {
              "question": "trigger_field",
              "operator": "=",
              "answerString": "unlock",
            },
          ],
        },
        {
          "linkId": "admin_field",
          "type": "text",
          "text": "Admin Notes (requires both 'unlock' and 'admin')",
          "enableBehavior": "all",
          "enableWhen": [
            {
              "question": "trigger_field",
              "operator": "=",
              "answerString": "unlock",
            },
            {
              "question": "secondary_trigger",
              "operator": "=",
              "answerString": "admin",
            },
          ],
        },
      ],
    },
    {
      "linkId": "choice_openchoice_tests",
      "type": "group",
      "text": "Choice & Open-Choice Tests (repeats behavior)",
      "item": [
        {
          "linkId": "choice_single",
          "type": "choice",
          "text": "Favorite Color (single selection - radio buttons)",
          "repeats": false,
          "answerOption": [
            {
              "valueCoding": {"code": "red", "display": "Red"},
            },
            {
              "valueCoding": {"code": "blue", "display": "Blue"},
            },
            {
              "valueCoding": {"code": "green", "display": "Green"},
            },
          ],
        },
        {
          "linkId": "choice_multiple",
          "type": "choice",
          "text": "Hobbies (multiple selection - checkboxes)",
          "repeats": true,
          "answerOption": [
            {
              "valueCoding": {"code": "reading", "display": "Reading"},
            },
            {
              "valueCoding": {"code": "sports", "display": "Sports"},
            },
            {
              "valueCoding": {"code": "music", "display": "Music"},
            },
            {
              "valueCoding": {"code": "cooking", "display": "Cooking"},
            },
          ],
        },
        {
          "linkId": "openchoice_single",
          "type": "open-choice",
          "text": "Preferred Programming Language (single + custom text)",
          "repeats": false,
          "answerOption": [
            {
              "valueCoding": {"code": "dart", "display": "Dart"},
            },
            {
              "valueCoding": {"code": "python", "display": "Python"},
            },
            {
              "valueCoding": {"code": "javascript", "display": "JavaScript"},
            },
          ],
        },
        {
          "linkId": "openchoice_multiple",
          "type": "open-choice",
          "text": "Skills (multiple + custom text)",
          "repeats": true,
          "answerOption": [
            {
              "valueCoding": {"code": "flutter", "display": "Flutter"},
            },
            {
              "valueCoding": {"code": "react", "display": "React"},
            },
            {
              "valueCoding": {"code": "nodejs", "display": "Node.js"},
            },
          ],
        },
      ],
    },
    {
      "linkId": "dropdown_tests",
      "type": "group",
      "text": "Dropdown Widget Tests (itemControl extension)",
      "item": [
        {
          "linkId": "country_dropdown",
          "type": "choice",
          "text": "Select Country (dropdown - single select)",
          "repeats": false,
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "drop-down",
                    "display": "Drop down",
                  },
                ],
              },
            },
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "us", "display": "United States"},
            },
            {
              "valueCoding": {"code": "uk", "display": "United Kingdom"},
            },
            {
              "valueCoding": {"code": "ca", "display": "Canada"},
            },
            {
              "valueCoding": {"code": "au", "display": "Australia"},
            },
            {
              "valueCoding": {"code": "de", "display": "Germany"},
            },
            {
              "valueCoding": {"code": "fr", "display": "France"},
            },
          ],
        },
        {
          "linkId": "languages_dropdown",
          "type": "choice",
          "text": "Select Languages (dropdown - multi select)",
          "repeats": true,
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "drop-down",
                    "display": "Drop down",
                  },
                ],
              },
            },
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "en", "display": "English"},
            },
            {
              "valueCoding": {"code": "es", "display": "Spanish"},
            },
            {
              "valueCoding": {"code": "fr", "display": "French"},
            },
            {
              "valueCoding": {"code": "de", "display": "German"},
            },
            {
              "valueCoding": {"code": "zh", "display": "Chinese"},
            },
            {
              "valueCoding": {"code": "ja", "display": "Japanese"},
            },
          ],
        },
        {
          "linkId": "department_dropdown",
          "type": "open-choice",
          "text": "Department (dropdown with custom option)",
          "repeats": false,
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "drop-down",
                    "display": "Drop down",
                  },
                ],
              },
            },
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "cardiology", "display": "Cardiology"},
            },
            {
              "valueCoding": {"code": "neurology", "display": "Neurology"},
            },
            {
              "valueCoding": {"code": "oncology", "display": "Oncology"},
            },
            {
              "valueCoding": {"code": "pediatrics", "display": "Pediatrics"},
            },
          ],
        },
      ],
    },
    {
      "linkId": "validation_tests",
      "type": "group",
      "text": "Field Validation Tests",
      "item": [
        {
          "linkId": "phone_number",
          "type": "string",
          "text": "Phone Number (format: XXX-XXX-XXXX)",
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/regex",
              "valueString": r"^\d{3}-\d{3}-\d{4}$",
            },
          ],
        },
        {
          "linkId": "postal_code",
          "type": "string",
          "text": "Postal Code (5 digits)",
          "maxLength": 5,
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/regex",
              "valueString": r"^\d{5}$",
            },
          ],
        },
        {"linkId": "website", "type": "url", "text": "Website URL"},
        {
          "linkId": "quantity_test",
          "type": "decimal",
          "text": "Enter a decimal value (e.g., 3.14)",
        },
      ],
    },
    {
      "linkId": "new_types_section",
      "type": "group",
      "text": "New FHIR Types (Attachment & Reference)",
      "item": [
        {
          "linkId": "profile_photo",
          "type": "attachment",
          "text": "Upload Profile Photo",
          "required": false,
        },
        {
          "linkId": "supporting_documents",
          "type": "attachment",
          "text": "Supporting Documents (can attach multiple)",
          "required": false,
          "repeats": true,
        },
        {
          "linkId": "referring_practitioner",
          "type": "reference",
          "text": "Referring Practitioner",
          "required": false,
        },
        {
          "linkId": "primary_care_physician",
          "type": "reference",
          "text": "Primary Care Physician",
          "required": false,
        },
        {
          "linkId": "related_patient",
          "type": "reference",
          "text": "Related Patient (e.g., Parent/Guardian)",
          "required": false,
        },
      ],
    },
  ],
});
