import 'package:fhir_r4/fhir_r4.dart';

Questionnaire example = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "long-all-item-types-questionnaire",
  "status": "active",
  "title": "Comprehensive FHIR Questionnaire",
  "description":
      "A long questionnaire covering all FHIR R4 QuestionnaireItem types with initial values for testing and demonstration.",
  "item": [
    {
      "linkId": "intro",
      "type": "display",
      "text": "Welcome! Please complete the following health questionnaire.",
    },
    {
      "linkId": "demographics",
      "type": "group",
      "text": "Demographics",
      "item": [
        {
          "linkId": "name",
          "type": "string",
          "text": "Full name",
          "initial": [
            {"valueString": "Jane Doe"},
          ],
        },
        {
          "linkId": "age",
          "type": "integer",
          "text": "Age",
          "initial": [
            {"valueInteger": 42},
          ],
        },
        {
          "linkId": "dob",
          "type": "date",
          "text": "Date of birth",
          "initial": [
            {"valueDate": "1982-04-17"},
          ],
        },
        {
          "linkId": "gender",
          "type": "choice",
          "text": "Gender",
          "answerOption": [
            {
              "valueCoding": {"code": "female", "display": "Female"},
            },
            {
              "valueCoding": {"code": "male", "display": "Male"},
            },
            {
              "valueCoding": {"code": "other", "display": "Other"},
            },
          ],
          "initial": [
            {
              "valueCoding": {"code": "female", "display": "Female"},
            },
          ],
        },
      ],
    },
    {
      "linkId": "contact",
      "type": "group",
      "text": "Contact Information",
      "item": [
        {
          "linkId": "email",
          "type": "string",
          "text": "Email address",
          "initial": [
            {"valueString": "jane.doe@example.com"},
          ],
        },
        {"linkId": "phone", "type": "string", "text": "Phone number"},
        {
          "linkId": "website",
          "type": "url",
          "text": "Personal website",
          "initial": [
            {"valueUri": "https://example.com"},
          ],
        },
      ],
    },
    {
      "linkId": "vitals",
      "type": "group",
      "text": "Vital Signs",
      "item": [
        {
          "linkId": "height",
          "type": "decimal",
          "text": "Height (meters)",
          "initial": [
            {"valueDecimal": 1.65},
          ],
        },
        {
          "linkId": "weight",
          "type": "quantity",
          "text": "Weight",
          "initial": [
            {
              "valueQuantity": {
                "value": 68,
                "unit": "kg",
                "system": "http://unitsofmeasure.org",
                "code": "kg",
              },
            },
          ],
        },
        {
          "linkId": "bpKnown",
          "type": "boolean",
          "text": "Do you know your blood pressure?",
          "initial": [
            {"valueBoolean": true},
          ],
        },
      ],
    },
    {
      "linkId": "appointments",
      "type": "group",
      "text": "Appointments",
      "item": [
        {
          "linkId": "lastVisit",
          "type": "dateTime",
          "text": "Last medical appointment",
          "initial": [
            {"valueDateTime": "2024-09-15T14:00:00Z"},
          ],
        },
        {
          "linkId": "preferredTime",
          "type": "time",
          "text": "Preferred appointment time",
          "initial": [
            {"valueTime": "10:30:00"},
          ],
        },
      ],
    },
    {
      "linkId": "lifestyle",
      "type": "group",
      "text": "Lifestyle",
      "item": [
        {
          "linkId": "smoker",
          "type": "boolean",
          "text": "Do you smoke?",
          "initial": [
            {"valueBoolean": false},
          ],
        },
        {
          "linkId": "alcohol",
          "type": "choice",
          "text": "Alcohol consumption",
          "answerOption": [
            {
              "valueCoding": {"code": "none", "display": "None"},
            },
            {
              "valueCoding": {"code": "moderate", "display": "Moderate"},
            },
            {
              "valueCoding": {"code": "high", "display": "High"},
            },
          ],
        },
        {
          "linkId": "exercise",
          "type": "open-choice",
          "text": "Preferred exercise",
          "answerOption": [
            {
              "valueCoding": {"code": "walking", "display": "Walking"},
            },
            {
              "valueCoding": {"code": "swimming", "display": "Swimming"},
            },
          ],
          "initial": [
            {
              "valueCoding": {"code": "walking", "display": "Walking"},
            },
          ],
        },
      ],
    },
    {
      "linkId": "clinicalNotes",
      "type": "group",
      "text": "Clinical Notes",
      "item": [
        {
          "linkId": "notes",
          "type": "text",
          "text": "Additional notes",
          "initial": [
            {"valueString": "Patient reports mild seasonal allergies."},
          ],
        },
        {
          "linkId": "attachments",
          "type": "attachment",
          "text": "Upload supporting documents",
        },
      ],
    },
    {
      "linkId": "careTeam",
      "type": "group",
      "text": "Care Team",
      "item": [
        {
          "linkId": "primaryPhysician",
          "type": "reference",
          "text": "Primary care physician",
          "reference": ["Practitioner"],
        },
      ],
    },
    {
      "linkId": "closing",
      "type": "display",
      "text": "Thank you for completing this questionnaire.",
    },
  ],
});
