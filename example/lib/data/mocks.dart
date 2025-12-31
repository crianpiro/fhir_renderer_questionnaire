import 'package:fhir_r4/fhir_r4.dart';

Questionnaire example = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "example-all-item-types",
  "version": "1",
  "name": "AllItemTypesExample",
  "title": "Questionnaire with All Possible Item Types",
  "status": "draft",
  "date": "2024-03-05",
  "subjectType": ["Patient"],
  "item": [
    {
      "linkId": "intro",
      "text":
          "Welcome to the Health and Wellness Survey! Please read the instructions carefully before proceeding.",
      "type": "display",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/translation",
          "extension": [
            {"url": "lang", "valueCode": "es"},
            {
              "url": "content",
              "valueString":
                  "¡Bienvenidos a la Encuesta de Salud y Bienestar! Por favor, lea detenidamente las instrucciones antes de continuar.",
            },
          ],
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/translation",
          "extension": [
            {"url": "lang", "valueCode": "fr"},
            {
              "url": "content",
              "valueString":
                  "Bienvenue à l’enquête sur la santé et le bien-être ! Veuillez lire attentivement les instructions avant de continuer.",
            },
          ],
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/translation",
          "extension": [
            {"url": "lang", "valueCode": "en"},
            {
              "url": "content",
              "valueString":
                  "Welcome to the Health and Wellness Survey! Please read the instructions carefully before proceeding.",
            },
          ],
        },
      ],
    },
    {
      "linkId": "501",
      "text":
          "Have you experienced any symptoms of a common cold in the last 14 days?",
      "type": "boolean",
      "item": [
        {
          "linkId": "501.help",
          "type": "display",
          "text":
              "Help here, the same as hint, enabled for Yes, disabled for No.",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system":
                        "http://hl7.org/fhir/questionnaire-display-category",
                    "code": "help",
                    "display": "Help",
                  },
                ],
                "text": "Help",
              },
            },
          ],
        },
      ],
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Simply enable the switch for Yes, disable for No.",
        },
      ],
    },
    {
      "linkId": "502",
      "text": "Please upload your most recent blood test results.",
      "type": "attachment",
    },
    {
      "linkId": "401",
      "text": "What is the URL of your personal website?",
      "type": "url",
      "item": [
        {
          "linkId": "401.help",
          "type": "display",
          "text": "Make sure you enter a valid url.",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system":
                        "http://hl7.org/fhir/questionnaire-display-category",
                    "code": "help",
                    "display": "Help",
                  },
                ],
                "text": "Help",
              },
            },
          ],
        },
      ],
    },
    {
      "linkId": "402",
      "text": "Please provide the URL of your LinkedIn profile.",
      "type": "url",
      "initial": [
        {"valueUri": "http://example.com/your-default-linkedin"},
      ],
    },
    {
      "linkId": "1.1",
      "text": "Self-limited problems",
      "type": "integer",
      "maxLength": 2,
      "item": [
        {
          "linkId": "1.1.help",
          "type": "display",
          "text":
              "Value must be between 1 and 10, otherwise validation error occurs.",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "help",
                    "display": "Help",
                  },
                ],
              },
            },
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "flyover",
                    "display": "Fly-over",
                  },
                ],
              },
            },
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system":
                        "http://hl7.org/fhir/questionnaire-display-category",
                    "code": "help",
                    "display": "Help",
                  },
                ],
                "text": "Help",
              },
            },
            {
              "url": "http://hl7.org/fhir/StructureDefinition/translation",
              "extension": [
                {"url": "lang", "valueCode": "es"},
                {
                  "url": "content",
                  "valueString":
                      "Introduzca cuántos problemas menores/autolimitados se abordaron. Cada uno cuenta como 1 punto.",
                },
              ],
            },
          ],
        },
      ],
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/minValue",
          "valueInteger": 1,
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/maxValue",
          "valueInteger": 10,
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/minLength",
          "valueInteger": 1,
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "e.g., 1 (minor issue such as a cold or rash)",
        },
      ],
    },
    {
      "linkId": "300",
      "text": "Body Info",
      "type": "group",
      "item": [
        {
          "linkId": "300.help",
          "type": "display",
          "text": "Your body info for BMI calculation.",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "help",
                    "display": "Help",
                  },
                ],
              },
            },
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://hl7.org/fhir/questionnaire-item-control",
                    "code": "flyover",
                    "display": "Fly-over",
                  },
                ],
              },
            },
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system":
                        "http://hl7.org/fhir/questionnaire-display-category",
                    "code": "help",
                    "display": "Help",
                  },
                ],
                "text": "Help",
              },
            },
          ],
        },
        {
          "linkId": "301",
          "text": "What is your height?",
          "type": "quantity",
          "initial": [
            {
              "valueQuantity": {
                "value": 170,
                "unit": "cm",
                "system": "http://unitsofmeasure.org",
                "code": "cm",
              },
            },
          ],
        },
        {
          "linkId": "302",
          "text": "What is your weight?",
          "type": "quantity",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-unit",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://unitsofmeasure.org",
                    "code": "kg",
                    "display": "kilograms",
                  },
                ],
              },
            },
          ],
        },
        {
          "linkId": "303",
          "text": "What is your waist circumference?",
          "type": "quantity",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-unit",
              "valueCodeableConcept": {
                "coding": [
                  {
                    "system": "http://unitsofmeasure.org",
                    "code": "in",
                    "display": "inches",
                  },
                ],
              },
            },
          ],
        },
      ],
    },
    {
      "linkId": "2",
      "text": "What is your date of birth?",
      "type": "date",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/minValue",
          "valueDate": "1990-01-01",
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/maxValue",
          "valueDate": "2025-10-28",
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Use a real birth date",
        },
      ],
    },
    {
      "linkId": "2.1",
      "text": "What time did you take your medication this morning?",
      "type": "time",
    },
    {
      "linkId": "2.2",
      "text": "When was your last doctor's appointment?",
      "type": "dateTime",
    },
    {
      "linkId": "1",
      "text": "Your full name",
      "type": "string",
      "required": true,
    },
    {
      "linkId": "104",
      "text": "Do you have any dietary restrictions?",
      "type": "choice",
      "answerOption": [
        {
          "valueCoding": {"code": "yes", "display": "Yes"},
        },
        {
          "valueCoding": {"code": "no", "display": "No"},
        },
      ],
    },
    {
      "linkId": "105",
      "text": "Please specify your dietary restrictions.",
      "type": "text",
      "enableWhen": [
        {
          "question": "104",
          "operator": "=",
          "answerCoding": {"code": "yes"},
        },
        {
          "question": "1",
          "operator": "=",
          "answerCoding": {"code": "Luis"},
        },
      ],
      "enableBehavior": "all",
    },
    {"linkId": "200", "text": "How many is 2 + 2?", "type": "integer"},
    {
      "linkId": "201",
      "text": "Elaborate your answer on how many is 2 + 2?.",
      "type": "text",
      "enableWhen": [
        {"question": "200", "operator": ">", "answerInteger": 2},
        {"question": "200", "operator": "<", "answerInteger": 9},
        {"question": "200", "operator": ">=", "answerInteger": 3},
        {"question": "200", "operator": "<=", "answerInteger": 10},
      ],
      "enableBehavior": "all",
    },
    {
      "linkId": "202",
      "text": "How many colors has a rainbow?",
      "type": "integer",
    },
    {
      "linkId": "203",
      "text": "Elaborate your answer on how many colors has a rainbow?",
      "type": "text",
      "enableWhen": [
        {"question": "202", "operator": "exists", "answerBoolean": true},
        {"question": "200", "operator": "exists", "answerBoolean": false},
      ],
      "enableBehavior": "any",
    },
    {
      "linkId": "4",
      "text": "Please specify your gender",
      "required": true,
      "type": "choice",
      "answerOption": [
        {
          "valueCoding": {"code": "male", "display": "Male"},
        },
        {
          "valueCoding": {"code": "female", "display": "Female"},
        },
        {
          "valueCoding": {"code": "other", "display": "Other"},
        },
        {
          "valueCoding": {"code": "unknown", "display": "Prefer not to say"},
        },
      ],
    },
    {
      "linkId": "5",
      "text": "List your current medications",
      "type": "open-choice",
      "answerOption": [
        {
          "valueCoding": {"code": "med1", "display": "Medication A"},
        },
        {
          "valueCoding": {"code": "med2", "display": "Medication B"},
        },
      ],
    },
    {
      "linkId": "100",
      "text":
          "Which of the following dietary preferences apply to you? (Select all that apply)",
      "type": "choice",
      "repeats": true,
      "answerOption": [
        {
          "valueCoding": {
            "system": "http://example.org/dietary-preferences",
            "code": "vegetarian",
            "display": "Vegetarian",
          },
        },
        {
          "valueCoding": {
            "system": "http://example.org/dietary-preferences",
            "code": "vegan",
            "display": "Vegan",
          },
        },
        {
          "valueCoding": {
            "system": "http://example.org/dietary-preferences",
            "code": "glutenFree",
            "display": "Gluten-Free",
          },
        },
        {
          "valueCoding": {
            "system": "http://example.org/dietary-preferences",
            "code": "ketogenic",
            "display": "Ketogenic",
          },
        },
      ],
    },
    {
      "linkId": "101",
      "text":
          "Which of the following type of exercises do you practice? (Select all that apply)",
      "type": "open-choice",
      "repeats": true,
      "answerOption": [
        {
          "valueCoding": {"code": "yoga", "display": "Yoga"},
        },
        {
          "valueCoding": {"code": "pilates", "display": "Pilates"},
        },
        {
          "valueCoding": {"code": "zumba", "display": "Zumba"},
        },
      ],
    },
    {
      "linkId": "102",
      "text": "Select your age range:",
      "required": true,
      "type": "choice",
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
            "text": "Drop down",
          },
        },
      ],
      "answerOption": [
        {
          "valueCoding": {
            "system": "http://example.org/age-ranges",
            "code": "18-25",
            "display": "18-25",
          },
        },
        {
          "valueCoding": {
            "system": "http://example.org/age-ranges",
            "code": "26-35",
            "display": "26-35",
          },
        },
        {
          "valueCoding": {
            "system": "http://example.org/age-ranges",
            "code": "36-45",
            "display": "36-45",
          },
        },
      ],
    },
    {
      "linkId": "103",
      "text": "How many hours do you sleep?",
      "required": true,
      "type": "open-choice",
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
            "text": "Drop down",
          },
        },
      ],
      "answerOption": [
        {
          "valueCoding": {"code": "6 hours", "display": "6 hours"},
        },
        {
          "valueCoding": {"code": "8 hours", "display": "8 hours"},
        },
        {
          "valueCoding": {"code": "10 hours", "display": "10 hours"},
        },
      ],
    },
    {
      "linkId": "6",
      "text": "Please rate your general health",
      "type": "integer",
    },
    {
      "linkId": "7",
      "text": "Your body height in cm (Read-Only)",
      "type": "decimal",
      "readOnly": true,
      "initial": [
        {"valueDecimal": 190.5},
      ],
    },
    {
      "linkId": "8",
      "text": "Describe your symptoms",
      "type": "text",
      "maxLength": 160,
    },
  ],
});
Questionnaire mockAnamneseQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "b7783c76-2d73-4af0-a83a-8734c6742b71",
  "meta": {"versionId": "208", "lastUpdated": "2025-11-27T12:22:56.666+01:00"},
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
      "extension": [
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/questionnaire-supportLink",
          "valueUri": "/images/forms/introscreenteres1.jpg",
        },
      ],
      "linkId": "NIT_SVAnT_01",
      "text": "Informationsblatt",
      "type": "display",
    },
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
          "required": true,
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
          "type": "choice",
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
          "enableBehavior": "all",
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
          "enableBehavior": "all",
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
