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

Questionnaire anamneseExample = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "b7783c76-2d73-4af0-a83a-8734c6742b71",
  "meta": {"versionId": "224", "lastUpdated": "2026-01-11T11:33:40.370+01:00"},
  "language": "de",
  "extension": [
    {
      "url": "http://nursit-institute.com/fhir/StructureDefinition/last-editor",
      "valueString": "2023-02-21 14:53:56|designerse",
    },
    {
      "url":
          "http://nursit-institute.com/fhir/StructureDefinition/mobile-visible",
      "valueBoolean": true,
    },
    {
      "url":
          "http://nursit-institute.com/fhir/StructureDefinition/mobile-readonly",
      "valueBoolean": true,
    },
  ],
  "url": "http://nursit-institute.com/Questionnaires/CareITAnamnesisSempaAkut",
  "version": "1.0.2",
  "name": "CareITAnamnesisSempaAkut",
  "title": "Grundinformationen",
  "status": "active",
  "item": [
    {
      "linkId": "NIT_SVAnT_g1",
      "text": "Allgemeine Situation der gepflegten Person",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_100",
          "text":
              "Was belastet Sie aktuell? Welche Unterstützung oder Informationen suchen Sie? ",
          "type": "text",
          "required": true,
          "maxLength": 450,
        },
        {
          "linkId": "NIT_SVAnT_101",
          "text": "Wen unterstützen Sie?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ehepartner*in / Partner*in",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_101_01",
                "display": "Ehepartner*in / Partner*in",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "(Schwieger)-Elternteil",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_101_02",
                "display": "(Schwieger)-Elternteil",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Kind",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_101_03", "display": "Kind"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Eine andere Person und zwar",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 99,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_101_99",
                "display": "Eine andere Person und zwar",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_102",
          "text": "Name der Person",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_101",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_101_99",
                "display": "Eine andere Person und zwar",
              },
            },
          ],
          "maxLength": 45,
        },
        {
          "linkId": "NIT_SVAnT_103",
          "text": "Welches Geschlecht hat die von Ihnen unterstützte Person?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiblich",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_103_01",
                "display": "Weiblich",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Männlich",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_103_02",
                "display": "Männlich",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Divers",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_103_03", "display": "Divers"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Keine Angabe",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 4,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_103_04",
                "display": "Keine Angabe",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_104",
          "text": "Wie alt ist die von Ihnen unterstützte Person? (Jahre alt)",
          "type": "integer",
          "maxLength": 3,
        },
        {
          "linkId": "NIT_SVAnT_105",
          "text": "Wo lebt die von Ihnen unterstützte Person? (PLZ eintragen)",
          "type": "integer",
          "maxLength": 5,
        },
        {
          "linkId": "NIT_SVAnT_106",
          "text": "Wie lebt die von Ihnen unterstützte Person?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Zu Hause, allein",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_106_00",
                "display": "Zu Hause, allein",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Zu Hause, mit Anderen",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_106_01",
                "display": "Zu Hause, mit Anderen",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Pflegeheim",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_106_02",
                "display": "Pflegeheim",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Anders",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 99,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_106_99", "display": "Anders"},
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_107",
          "text": "Anders:",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_106",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_106_99", "display": "Anders"},
            },
          ],
          "maxLength": 25,
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g2",
      "text": "Gesundheit & Pflegegrad",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_200",
          "text": "Welche Erkrankungen hat die von Ihnen unterstützte Person?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "keine",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_200_00", "display": "keine"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Demenz",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_200_01", "display": "Demenz"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Parkinson",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_02",
                "display": "Parkinson",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Diabetes",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_03",
                "display": "Diabetes",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Psychische Erkrankung (z.B. Depression)",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_04",
                "display": "Psychische Erkrankung (z.B. Depression)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Multiple Sklerose",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_05",
                "display": "Multiple Sklerose",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Rheuma",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_200_06", "display": "Rheuma"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Arthrose",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_07",
                "display": "Arthrose",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Lungenerkrankung ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_08",
                "display": "Lungenerkrankung ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Herz-Kreislauf-Erkrankung",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_09",
                "display": "Herz-Kreislauf-Erkrankung",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Schlaganfall",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_10",
                "display": "Schlaganfall",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Andere",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_200_99", "display": "Andere"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_200_98",
                "display": "Weiß ich nicht",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_201",
          "text": "Andere:",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_200",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_200_99", "display": "Andere"},
            },
          ],
          "maxLength": 45,
        },
        {
          "linkId": "NIT_SVAnT_202",
          "text":
              "Hat die von Ihnen unterstützte Person einen anerkannten Pflegegrad?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Nein",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_202_00", "display": "Nein"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, Pflegegrad 1",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_01",
                "display": "Ja, Pflegegrad 1",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, Pflegegrad 2",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_02",
                "display": "Ja, Pflegegrad 2",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, Pflegegrad 3",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_03",
                "display": "Ja, Pflegegrad 3",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, Pflegegrad 4",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 4,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_04",
                "display": "Ja, Pflegegrad 4",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, Pflegegrad 5",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 5,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_05",
                "display": "Ja, Pflegegrad 5",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "ist beantragt ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 6,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_06",
                "display": "ist beantragt ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_202_98",
                "display": "Weiß ich nicht",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_203",
          "text": "Wie ist die von Ihnen unterstützte Person versichert?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Gesetzlich versichert",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_203_00",
                "display": "Gesetzlich versichert",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Privat versichert",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_203_01",
                "display": "Privat versichert",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_203_02",
                "display": "Weiß ich nicht",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_204",
          "text": "Name der Krankenkasse: ",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_203",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_203_00",
                "display": "Gesetzlich versichert",
              },
            },
            {
              "question": "NIT_SVAnT_203",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_203_01",
                "display": "Privat versichert",
              },
            },
          ],
          "enableBehavior": "any",
          "maxLength": 45,
        },
        {
          "linkId": "NIT_SVAnT_205",
          "text": "Liegt eine Schwerbehinderung vor?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Nein",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_205_00", "display": "Nein"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_205_01", "display": "Ja"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_205_02",
                "display": "Weiß ich nicht",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "beantragt",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_205_03",
                "display": "beantragt",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_206",
          "text": "Welche Merkzeichen?",
          "type": "open-choice",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_205",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_205_01", "display": "Ja"},
            },
          ],
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "G",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_00", "display": "G"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "aG",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_01", "display": "aG"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "BI",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_02", "display": "BI"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "GI",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_03", "display": "GI"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "TBI",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_04", "display": "TBI"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "B",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_05", "display": "B"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "RF",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_06", "display": "RF"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "1.Kl",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_07", "display": "1.Kl"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "T",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_08", "display": "T"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "EB",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_09", "display": "EB"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "VB",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_206_10", "display": "VB"},
            },
          ],
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g3",
      "text": "Wohn- & Lebensumfeld der gepflegten Person",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_300",
          "text": "Welche Hilfsmittel werden genutzt? ",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Keine",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_300_00", "display": "Keine"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Hausnotrufsystem",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_01",
                "display": "Hausnotrufsystem ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Pflege- und/oder Duschstuhl ",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_02",
                "display": "Pflege- und/oder Duschstuhl ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Transfer-/e Aufstehhilfen (z. B. Drehscheiben, Rutschbretter, Transfergurte) ",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_03",
                "display":
                    "Transfer-/e Aufstehhilfen (z. B. Drehscheiben, Rutschbretter, Transfergurte) ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Gehhilfen (Rollator, Gehstöcke, Gehgestelle, Krücken)",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_04",
                "display":
                    "Gehhilfen (Rollator, Gehstöcke, Gehgestelle, Krücken)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Mobilitätshilfen (Rollstuhl, Elektromobil)",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_05",
                "display": "Mobilitätshilfen (Rollstuhl, Elektromobil)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Toilettenhilfen (z. B. Toilettenstuhl, Toilettensitzerhöhung, Haltegriffe)",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_06",
                "display":
                    "Toilettenhilfen (z. B. Toilettenstuhl, Toilettensitzerhöhung, Haltegriffe)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Intimwaschsysteme (z.B. Dusch-WC)",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_07",
                "display": "Intimwaschsysteme (z.B. Dusch-WC)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Hörgerät ",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_08",
                "display": "Hörgerät ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Zahnprothese ",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_300_09",
                "display": "Zahnprothese ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Andere",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_300_99", "display": "Andere"},
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_301",
          "text": "Welche?",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_300",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_300_99", "display": "Andere"},
            },
          ],
          "maxLength": 90,
        },
        {
          "linkId": "NIT_SVAnT_302",
          "text":
              "Gibt es Barrieren in der Wohnung, die die Person nicht selbstständig überwinden kann (z.B. Badewanne, Treppen)? ",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Nein",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_302_00", "display": "Nein"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, und zwar",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_302_01",
                "display": "Ja, und zwar",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_302_02",
                "display": "Weiß ich nicht",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ich bin unsicher",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_302_03",
                "display": "Ich bin unsicher",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_303",
          "text": "Welche?",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_302",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_302_01",
                "display": "Ja, und zwar",
              },
            },
          ],
          "maxLength": 45,
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g4",
      "text": "Vorsorge",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_400",
          "text": "Welche der Vorsorgereglungen liegen vor?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Keine",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_400_00", "display": "Keine"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Patientenverfügung",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_400_01",
                "display": "Patientenverfügung",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Vorsorgevollmacht",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_400_02",
                "display": "Vorsorgevollmacht",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Betreuungsverfügung",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_400_03",
                "display": "Betreuungsverfügung",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiß ich nicht",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_400_04",
                "display": "Weiß ich nicht",
              },
            },
          ],
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g5",
      "text": "Unterstützungsbedarf der gepflegten Person",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_500",
          "text":
              "Ist die unterstützte Person in allen Bereichen selbstständig?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_500_00", "display": "Ja"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_500_01", "display": "Nein"},
            },
          ],
          "initial": [
            {
              "valueCoding": {"code": "NIT_SVAnT_500_00"},
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_501",
          "text": "Wobei unterstützen Sie regelmäßig?",
          "type": "open-choice",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_500",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_500_01", "display": "Nein"},
            },
          ],
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Körperpflege",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_01",
                "display": "Körperpflege",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "An- und Auskleiden",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_02",
                "display": "An- und Auskleiden",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ausscheidung",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_03",
                "display": "Ausscheidung",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Baden und Duschen",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_04",
                "display": "Baden und Duschen",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Essen und Trinken",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_05",
                "display": "Essen und Trinken",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Gehen",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_501_06", "display": "Gehen"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Transfer Bett / Stuhl",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_07",
                "display": "Transfer Bett / Stuhl",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ortswechsel (Auto / Tram)",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_08",
                "display": "Ortswechsel (Auto / Tram)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Einkaufen",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_09",
                "display": "Einkaufen",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Kochen",
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_501_10", "display": "Kochen"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Hausarbeit",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_11",
                "display": "Hausarbeit",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Medikamenteneinnahme",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_12",
                "display": "Medikamenteneinnahme",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Soziale Kontakte",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_13",
                "display": "Soziale Kontakte",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Emotionale Instabilität",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_14",
                "display": "Emotionale Instabilität",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weiteres",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_501_99",
                "display": "Weiteres",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_502",
          "text": "Weitere Bereiche:",
          "type": "text",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_501",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_501_99",
                "display": "Weiteres",
              },
            },
          ],
          "maxLength": 90,
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g6",
      "text": "Zu Ihrer Situation",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_600",
          "text": "Wo leben Sie?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Im selben Haushalt",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_600_01",
                "display": "Im selben Haushalt",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "In der Nähe",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_600_02",
                "display": "In der Nähe",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Mehr als 1h entfernt",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_600_03",
                "display": "Mehr als 1h entfernt",
              },
            },
          ],
          "initial": [
            {
              "valueCoding": {"code": "NIT_SVAn_08_01"},
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_601",
          "text":
              "Wie viel Zeit nimmt die Unterstützung ungefähr in Anspruch? (Stunden pro Woche)",
          "type": "integer",
          "repeats": false,
          "maxLength": 3,
        },
        {
          "linkId": "NIT_SVAnT_602",
          "text":
              "Welche Unterstützung haben Sie bei der Versorgung der Person?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Keine Unterstützung",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_602_00",
                "display": "Keine Unterstützung",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Unterstützung von Verwandten, Bekannten",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_602_01",
                "display": "Unterstützung von Verwandten, Bekannten",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Ehrenamtliche Unterstützung (Nachbarschaftshilfe, Betreuungsdienste)",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_602_02",
                "display":
                    "Ehrenamtliche Unterstützung (Nachbarschaftshilfe, Betreuungsdienste)",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Unterstützung professioneller Dienstleister",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_602_03",
                "display": "Unterstützung professioneller Dienstleister ",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_603",
          "text": "Professioneller Dienstleister?",
          "type": "open-choice",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_602",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_602_03",
                "display": "Unterstützung professioneller Dienstleister ",
              },
            },
          ],
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Hausnotruf",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_01",
                "display": "Hausnotruf",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Betreuungsdienst/Alltagshilfe/Haushaltshilfe",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_02",
                "display": "Betreuungsdienst/Alltagshilfe/Haushaltshilfe",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Krankentransport",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_03",
                "display": "Krankentransport",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Essen auf Rädern/Mahlzeiten-Dienst",
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_04",
                "display": "Essen auf Rädern/Mahlzeiten-Dienst",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ambulanter Pflegedienst",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_05",
                "display": "Ambulanter Pflegedienst",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Verhinderungspflege/Kurzzeitpflege",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_06",
                "display": "Verhinderungspflege/Kurzzeitpflege",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Tages- oder Nachtpflege",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_07",
                "display": "Tages- oder Nachtpflege",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Palliativ- oder Hospizdienst",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_08",
                "display": "Palliativ- oder Hospizdienst",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "24h-Stunden-Pflege",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_09",
                "display": "24h-Stunden-Pflege",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Betreutes Wohnen/Service-Wohnen",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_10",
                "display": "Betreutes Wohnen/Service-Wohnen",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Senioren-/Pflege-WG",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_11",
                "display": "Senioren-/Pflege-WG",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Pflegeheim",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_603_12",
                "display": "Pflegeheim",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Anders",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_603_99", "display": "Anders"},
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_604",
          "text": "Anders",
          "type": "string",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_603",
              "operator": "=",
              "answerCoding": {"code": "NIT_SVAnT_603_99", "display": "Anders"},
            },
          ],
          "maxLength": 25,
        },
      ],
    },
    {
      "linkId": "NIT_SVAnT_g7",
      "text": "Zu Ihrer Person",
      "type": "group",
      "item": [
        {
          "linkId": "NIT_SVAnT_700",
          "text": "Sind Sie berufstätig?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Nein",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_700_00", "display": "Nein"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, selbstständig ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_700_01",
                "display": "Ja, selbstständig ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja, angestellt ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_700_02",
                "display": "Ja, angestellt ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Derzeit nicht (z.B. wegen Elternzeit, Pflegezeit, arbeitsuchend, Ausbildung, Studium etc.)",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_700_03",
                "display":
                    "Derzeit nicht (z.B. wegen Elternzeit, Pflegezeit, arbeitsuchend, Ausbildung, Studium etc.)",
              },
            },
          ],
        },
        {
          "extension": [
            {
              "url":
                  "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-item-comment",
              "valueString":
                  "Bitte nennen Sie Ihre durchschnittliche Wochenarbeitszeit.",
            },
          ],
          "linkId": "NIT_SVAnT_701",
          "text": "Wie viele Stunden arbeiten Sie pro Woche?",
          "type": "open-choice",
          "enableWhen": [
            {
              "question": "NIT_SVAnT_700",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_700_01",
                "display": "Ja, selbstständig ",
              },
            },
            {
              "question": "NIT_SVAnT_700",
              "operator": "=",
              "answerCoding": {
                "code": "NIT_SVAnT_700_02",
                "display": "Ja, angestellt ",
              },
            },
          ],
          "enableBehavior": "any",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Weniger als 10 Stunden pro Woche",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_701_01",
                "display": "Weniger als 10 Stunden pro Woche",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "10-19 Stunden pro Woche",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_701_02",
                "display": "10-19 Stunden pro Woche",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "20-34 Stunden pro Woche",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_701_03",
                "display": "20-34 Stunden pro Woche",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "35 und mehr Stunden pro Woche",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 4,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_701_04",
                "display": "35 und mehr Stunden pro Woche",
              },
            },
          ],
        },
        {
          "extension": [
            {
              "url":
                  "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-item-comment",
              "valueString":
                  "Wir bitten um diese Angaben zum besseren Verständnis, wen wir mit dieser App erreichen und wen nicht. ",
            },
          ],
          "linkId": "NIT_SVAnT_702",
          "text": "Wie alt sind Sie?",
          "type": "integer",
          "maxLength": 2,
        },
        {
          "extension": [
            {
              "url":
                  "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-item-comment",
              "valueString":
                  "Wir bitten um diese Angaben zum besseren Verständnis, wie wir die App zukünftig weiterentwickeln können.",
            },
          ],
          "linkId": "NIT_SVAnT_703",
          "text": "Ist Deutsch Ihre Muttersprache?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ja",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_703_00", "display": "Ja"},
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Nein",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_703_01", "display": "Nein "},
            },
          ],
        },
        {
          "extension": [
            {
              "url":
                  "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-item-comment",
              "valueString":
                  "Wir bitten um diese Angaben zum besseren Verständnis, wen wir mit dieser App erreichen und wie wir die App ggf. anpassen können.",
            },
          ],
          "linkId": "NIT_SVAnT_704",
          "text": "Was ist Ihr höchster beruflicher Bildungsabschluss?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Ohne beruflichen Ausbildungsabschluss",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_704_00",
                "display": "Ohne beruflichen Ausbildungsabschluss",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "Lehre, Berufsausbildung ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_704_01",
                "display": "Lehre, Berufsausbildung ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString":
                      "Fachschulabschluss (Techniker, Meisterschule) ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_704_02",
                "display": "Fachschulabschluss (Techniker, Meisterschule) ",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 3,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "o\tHochschulabschluss ",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_704_03",
                "display": "o\tHochschulabschluss ",
              },
            },
          ],
        },
        {
          "linkId": "NIT_SVAnT_705",
          "text": "Was ist Ihr Geschlecht?",
          "type": "open-choice",
          "repeats": true,
          "answerOption": [
            {
              "extension": [
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 0,
                },
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "männlich",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_705_00",
                "display": "männlich",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "weiblich",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 1,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {
                "code": "NIT_SVAnT_705_01",
                "display": "weiblich",
              },
            },
            {
              "extension": [
                {
                  "url":
                      "http://nursit-institute.com/fhir/StructureDefinition/questionnaire-option-hint",
                  "valueString": "divers",
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-ordinalValue",
                  "valueDecimal": 2,
                },
                {
                  "url":
                      "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true,
                },
              ],
              "valueCoding": {"code": "NIT_SVAnT_705_02", "display": "divers"},
            },
          ],
        },
      ],
    },
  ],
});

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
  "description": "Test questionnaire for verifying focus retention and enableWhen behavior with field items",
  "item": [
    {
      "linkId": "intro",
      "type": "display",
      "text": "This questionnaire tests focus behavior and conditional fields (enableWhen)",
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
              "valueString": r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
            },
          ],
        },
        {
          "linkId": "age",
          "type": "integer",
          "text": "Age",
          "required": true,
        },
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
            {
              "question": "city",
              "operator": "=",
              "answerString": "Other"
            }
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
              "answerCoding": {"code": "high", "display": "High"}
            }
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
              "answerString": "unlock"
            }
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
              "answerString": "unlock"
            }
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
              "answerString": "unlock"
            }
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
              "answerString": "unlock"
            },
            {
              "question": "secondary_trigger",
              "operator": "=",
              "answerString": "admin"
            }
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
            {"valueCoding": {"code": "red", "display": "Red"}},
            {"valueCoding": {"code": "blue", "display": "Blue"}},
            {"valueCoding": {"code": "green", "display": "Green"}},
          ],
        },
        {
          "linkId": "choice_multiple",
          "type": "choice",
          "text": "Hobbies (multiple selection - checkboxes)",
          "repeats": true,
          "answerOption": [
            {"valueCoding": {"code": "reading", "display": "Reading"}},
            {"valueCoding": {"code": "sports", "display": "Sports"}},
            {"valueCoding": {"code": "music", "display": "Music"}},
            {"valueCoding": {"code": "cooking", "display": "Cooking"}},
          ],
        },
        {
          "linkId": "openchoice_single",
          "type": "open-choice",
          "text": "Preferred Programming Language (single + custom text)",
          "repeats": false,
          "answerOption": [
            {"valueCoding": {"code": "dart", "display": "Dart"}},
            {"valueCoding": {"code": "python", "display": "Python"}},
            {"valueCoding": {"code": "javascript", "display": "JavaScript"}},
          ],
        },
        {
          "linkId": "openchoice_multiple",
          "type": "open-choice",
          "text": "Skills (multiple + custom text)",
          "repeats": true,
          "answerOption": [
            {"valueCoding": {"code": "flutter", "display": "Flutter"}},
            {"valueCoding": {"code": "react", "display": "React"}},
            {"valueCoding": {"code": "nodejs", "display": "Node.js"}},
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
              "valueString": r"^\d{3}-\d{3}-\d{4}$"
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
              "valueString": r"^\d{5}$"
            },
          ],
        },
        {
          "linkId": "website",
          "type": "url",
          "text": "Website URL",
        },
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
