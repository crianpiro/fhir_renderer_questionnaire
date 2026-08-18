import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';

/// Patient Demographics Questionnaire
/// Demonstrates: string, text, date, choice, display, group
Questionnaire patientDemographicsQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "patient-demographics",
  "status": "active",
  "title": "Patient Demographics",
  "description": "Collect basic patient demographic information",
  "item": [
    {
      "linkId": "welcome",
      "type": "display",
      "text":
          "Please provide your demographic information. All fields marked with * are required."
    },
    {
      "linkId": "personal-info",
      "type": "group",
      "text": "Personal Information",
      "item": [
        {
          "linkId": "first-name",
          "type": "string",
          "text": "First Name",
          "required": true
        },
        {
          "linkId": "middle-name",
          "type": "string",
          "text": "Middle Name",
          "required": false
        },
        {
          "linkId": "last-name",
          "type": "string",
          "text": "Last Name",
          "required": true
        },
        {
          "linkId": "dob",
          "type": "date",
          "text": "Date of Birth",
          "required": true
        },
        {
          "linkId": "gender",
          "type": "choice",
          "text": "Gender",
          "required": true,
          "answerOption": [
            {
              "valueCoding": {"code": "male", "display": "Male"}
            },
            {
              "valueCoding": {"code": "female", "display": "Female"}
            },
            {
              "valueCoding": {"code": "other", "display": "Other"}
            },
            {
              "valueCoding": {
                "code": "prefer-not-to-say",
                "display": "Prefer not to say"
              }
            }
          ]
        },
        {
          "linkId": "marital-status",
          "type": "choice",
          "text": "Marital Status",
          "answerOption": [
            {
              "valueCoding": {"code": "single", "display": "Single"}
            },
            {
              "valueCoding": {"code": "married", "display": "Married"}
            },
            {
              "valueCoding": {"code": "divorced", "display": "Divorced"}
            },
            {
              "valueCoding": {"code": "widowed", "display": "Widowed"}
            }
          ]
        }
      ]
    },
    {
      "linkId": "contact-info",
      "type": "group",
      "text": "Contact Information",
      "item": [
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
            {
              "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
              "valueString": "Enter a valid email (e.g., user@example.com)"
            }
          ]
        },
        {
          "linkId": "phone",
          "type": "string",
          "text": "Phone Number",
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/regex",
              "valueString": r"^\+?[\d\s\-\(\)]{10,}$"
            },
            {
              "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
              "valueString": "Enter a valid phone number"
            }
          ]
        },
        {
          "linkId": "address",
          "type": "text",
          "text": "Full Address",
          "required": true
        }
      ]
    },
    {
      "linkId": "emergency-contact",
      "type": "group",
      "text": "Emergency Contact",
      "item": [
        {
          "linkId": "emergency-name",
          "type": "string",
          "text": "Contact Name",
          "required": true
        },
        {
          "linkId": "emergency-relationship",
          "type": "choice",
          "text": "Relationship",
          "answerOption": [
            {
              "valueCoding": {"code": "spouse", "display": "Spouse"}
            },
            {
              "valueCoding": {"code": "parent", "display": "Parent"}
            },
            {
              "valueCoding": {"code": "sibling", "display": "Sibling"}
            },
            {
              "valueCoding": {"code": "child", "display": "Child"}
            },
            {
              "valueCoding": {"code": "friend", "display": "Friend"}
            },
            {
              "valueCoding": {"code": "other", "display": "Other"}
            }
          ]
        },
        {
          "linkId": "emergency-phone",
          "type": "string",
          "text": "Contact Phone",
          "required": true
        }
      ]
    }
  ]
});

/// Health Assessment Questionnaire
/// Demonstrates: boolean, integer, decimal, quantity, open-choice
Questionnaire healthAssessmentQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "health-assessment",
  "status": "active",
  "title": "Health Assessment",
  "description": "General health and lifestyle assessment",
  "item": [
    {
      "linkId": "intro",
      "type": "display",
      "text":
          "This assessment helps us understand your current health status. Please answer all questions honestly."
    },
    {
      "linkId": "vitals",
      "type": "group",
      "text": "Vital Measurements",
      "item": [
        {
          "linkId": "height-cm",
          "type": "integer",
          "text": "Height (cm)",
          "required": true
        },
        {
          "linkId": "weight-kg",
          "type": "decimal",
          "text": "Weight (kg)",
          "required": true
        },
        {
          "linkId": "temperature",
          "type": "decimal",
          "text": "Body Temperature (Celsius)"
        },
        {
          "linkId": "blood-pressure-systolic",
          "type": "integer",
          "text": "Blood Pressure - Systolic (mmHg)"
        },
        {
          "linkId": "blood-pressure-diastolic",
          "type": "integer",
          "text": "Blood Pressure - Diastolic (mmHg)"
        },
        {
          "linkId": "heart-rate",
          "type": "integer",
          "text": "Heart Rate (bpm)"
        }
      ]
    },
    {
      "linkId": "lifestyle",
      "type": "group",
      "text": "Lifestyle Factors",
      "item": [
        {
          "linkId": "smoker",
          "type": "boolean",
          "text": "Do you currently smoke?",
          "required": true
        },
        {
          "linkId": "former-smoker",
          "type": "boolean",
          "text": "Have you ever smoked in the past?"
        },
        {
          "linkId": "alcohol",
          "type": "boolean",
          "text": "Do you consume alcohol regularly?"
        },
        {
          "linkId": "exercise-weekly",
          "type": "integer",
          "text": "How many days per week do you exercise?"
        },
        {
          "linkId": "sleep-hours",
          "type": "decimal",
          "text": "Average hours of sleep per night"
        },
        {
          "linkId": "diet-type",
          "type": "open-choice",
          "text": "What best describes your diet?",
          "answerOption": [
            {
              "valueCoding": {"code": "regular", "display": "Regular/No restrictions"}
            },
            {
              "valueCoding": {"code": "vegetarian", "display": "Vegetarian"}
            },
            {
              "valueCoding": {"code": "vegan", "display": "Vegan"}
            },
            {
              "valueCoding": {"code": "keto", "display": "Keto/Low-carb"}
            },
            {
              "valueCoding": {"code": "gluten-free", "display": "Gluten-free"}
            }
          ]
        }
      ]
    },
    {
      "linkId": "medical-history",
      "type": "group",
      "text": "Medical History",
      "item": [
        {
          "linkId": "has-allergies",
          "type": "boolean",
          "text": "Do you have any known allergies?"
        },
        {
          "linkId": "has-chronic-conditions",
          "type": "boolean",
          "text": "Do you have any chronic medical conditions?"
        },
        {
          "linkId": "taking-medications",
          "type": "boolean",
          "text": "Are you currently taking any medications?"
        },
        {
          "linkId": "previous-surgeries",
          "type": "boolean",
          "text": "Have you had any surgeries in the past?"
        },
        {
          "linkId": "family-history",
          "type": "boolean",
          "text": "Is there a family history of heart disease, diabetes, or cancer?"
        }
      ]
    },
    {
      "linkId": "pain-level",
      "type": "integer",
      "text": "Current pain level (0-10, where 0 is no pain)",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/regex",
          "valueString": r"^([0-9]|10)$"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
          "valueString": "Enter a number between 0 and 10"
        }
      ]
    }
  ]
});

/// Clinical Screening Questionnaire
/// Demonstrates: enableWhen conditions with AND/OR behavior
Questionnaire clinicalScreeningQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "clinical-screening",
  "status": "active",
  "title": "Clinical Screening",
  "description":
      "Conditional screening questionnaire with enableWhen logic for targeted follow-up questions",
  "item": [
    {
      "linkId": "screening-intro",
      "type": "display",
      "text":
          "This screening will ask follow-up questions based on your responses. Please answer accurately."
    },
    {
      "linkId": "symptoms",
      "type": "group",
      "text": "Current Symptoms",
      "item": [
        {
          "linkId": "has-fever",
          "type": "boolean",
          "text": "Do you currently have a fever?"
        },
        {
          "linkId": "fever-temperature",
          "type": "decimal",
          "text": "What is your temperature (Celsius)?",
          "enableWhen": [
            {"question": "has-fever", "operator": "=", "answerBoolean": true}
          ]
        },
        {
          "linkId": "fever-duration",
          "type": "integer",
          "text": "How many days have you had the fever?",
          "enableWhen": [
            {"question": "has-fever", "operator": "=", "answerBoolean": true}
          ]
        },
        {
          "linkId": "has-cough",
          "type": "boolean",
          "text": "Do you have a cough?"
        },
        {
          "linkId": "cough-type",
          "type": "choice",
          "text": "What type of cough?",
          "enableWhen": [
            {"question": "has-cough", "operator": "=", "answerBoolean": true}
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "dry", "display": "Dry cough"}
            },
            {
              "valueCoding": {"code": "productive", "display": "Productive (with phlegm)"}
            },
            {
              "valueCoding": {"code": "bloody", "display": "Bloody cough"}
            }
          ]
        },
        {
          "linkId": "has-shortness-of-breath",
          "type": "boolean",
          "text": "Do you experience shortness of breath?"
        },
        {
          "linkId": "sob-severity",
          "type": "choice",
          "text": "How severe is your shortness of breath?",
          "enableWhen": [
            {
              "question": "has-shortness-of-breath",
              "operator": "=",
              "answerBoolean": true
            }
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "mild", "display": "Mild - only with exercise"}
            },
            {
              "valueCoding": {
                "code": "moderate",
                "display": "Moderate - with daily activities"
              }
            },
            {
              "valueCoding": {"code": "severe", "display": "Severe - at rest"}
            }
          ]
        }
      ]
    },
    {
      "linkId": "respiratory-warning",
      "type": "display",
      "text":
          "WARNING: Your combination of symptoms may indicate a serious respiratory condition. Please seek immediate medical attention.",
      "enableWhen": [
        {"question": "has-fever", "operator": "=", "answerBoolean": true},
        {"question": "has-cough", "operator": "=", "answerBoolean": true},
        {
          "question": "has-shortness-of-breath",
          "operator": "=",
          "answerBoolean": true
        }
      ],
      "enableBehavior": "all"
    },
    {
      "linkId": "pain-assessment",
      "type": "group",
      "text": "Pain Assessment",
      "item": [
        {
          "linkId": "has-pain",
          "type": "boolean",
          "text": "Are you currently experiencing any pain?"
        },
        {
          "linkId": "pain-location",
          "type": "open-choice",
          "text": "Where is the pain located?",
          "enableWhen": [
            {"question": "has-pain", "operator": "=", "answerBoolean": true}
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "head", "display": "Head"}
            },
            {
              "valueCoding": {"code": "chest", "display": "Chest"}
            },
            {
              "valueCoding": {"code": "abdomen", "display": "Abdomen"}
            },
            {
              "valueCoding": {"code": "back", "display": "Back"}
            },
            {
              "valueCoding": {"code": "joints", "display": "Joints"}
            }
          ]
        },
        {
          "linkId": "pain-intensity",
          "type": "integer",
          "text": "Rate your pain intensity (0-10)",
          "enableWhen": [
            {"question": "has-pain", "operator": "=", "answerBoolean": true}
          ],
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/regex",
              "valueString": r"^([0-9]|10)$"
            },
            {
              "url": "http://hl7.org/fhir/StructureDefinition/entryFormat",
              "valueString": "Enter a number between 0 and 10"
            }
          ]
        },
        {
          "linkId": "severe-pain-warning",
          "type": "display",
          "text":
              "Your pain level is severe. Please consult a healthcare provider immediately.",
          "enableWhen": [
            {"question": "pain-intensity", "operator": ">=", "answerInteger": 8}
          ]
        }
      ]
    },
    {
      "linkId": "diabetes-screening",
      "type": "group",
      "text": "Diabetes Risk Screening",
      "item": [
        {
          "linkId": "family-diabetes",
          "type": "boolean",
          "text": "Do you have a family history of diabetes?"
        },
        {
          "linkId": "frequent-thirst",
          "type": "boolean",
          "text": "Do you experience excessive thirst?"
        },
        {
          "linkId": "frequent-urination",
          "type": "boolean",
          "text": "Do you urinate more frequently than usual?"
        },
        {
          "linkId": "diabetes-risk-alert",
          "type": "display",
          "text":
              "Based on your responses, you may be at risk for diabetes. We recommend a blood glucose test.",
          "enableWhen": [
            {"question": "family-diabetes", "operator": "=", "answerBoolean": true},
            {"question": "frequent-thirst", "operator": "=", "answerBoolean": true}
          ],
          "enableBehavior": "any"
        }
      ]
    },
    {
      "linkId": "additional-notes",
      "type": "text",
      "text": "Please describe any other symptoms or concerns:"
    }
  ]
});

/// Appointment Booking Questionnaire
/// Demonstrates: date, time, dateTime pickers and choice with itemControl
Questionnaire appointmentBookingQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "appointment-booking",
  "status": "active",
  "title": "Appointment Booking",
  "description": "Schedule a medical appointment",
  "item": [
    {
      "linkId": "booking-intro",
      "type": "display",
      "text":
          "Please select your preferred appointment date, time, and provider."
    },
    {
      "linkId": "appointment-type",
      "type": "choice",
      "text": "Type of Appointment",
      "required": true,
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
          "valueCodeableConcept": {
            "coding": [
              {"code": "drop-down", "display": "Drop down"}
            ]
          }
        }
      ],
      "answerOption": [
        {
          "valueCoding": {"code": "checkup", "display": "General Checkup"}
        },
        {
          "valueCoding": {"code": "followup", "display": "Follow-up Visit"}
        },
        {
          "valueCoding": {"code": "specialist", "display": "Specialist Consultation"}
        },
        {
          "valueCoding": {"code": "vaccination", "display": "Vaccination"}
        },
        {
          "valueCoding": {"code": "lab", "display": "Laboratory Tests"}
        },
        {
          "valueCoding": {"code": "imaging", "display": "Imaging/X-Ray"}
        }
      ]
    },
    {
      "linkId": "provider",
      "type": "choice",
      "text": "Preferred Provider",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
          "valueCodeableConcept": {
            "coding": [
              {"code": "autocomplete", "display": "Autocomplete"}
            ]
          }
        }
      ],
      "answerOption": [
        {
          "valueCoding": {"code": "dr-smith", "display": "Dr. Sarah Smith - Family Medicine"}
        },
        {
          "valueCoding": {"code": "dr-johnson", "display": "Dr. Michael Johnson - Internal Medicine"}
        },
        {
          "valueCoding": {"code": "dr-williams", "display": "Dr. Emily Williams - Pediatrics"}
        },
        {
          "valueCoding": {"code": "dr-brown", "display": "Dr. David Brown - Cardiology"}
        },
        {
          "valueCoding": {"code": "dr-davis", "display": "Dr. Lisa Davis - Dermatology"}
        },
        {
          "valueCoding": {"code": "any", "display": "Any Available Provider"}
        }
      ]
    },
    {
      "linkId": "scheduling",
      "type": "group",
      "text": "Scheduling Preferences",
      "item": [
        {
          "linkId": "preferred-date",
          "type": "date",
          "text": "Preferred Date",
          "required": true
        },
        {
          "linkId": "preferred-time",
          "type": "time",
          "text": "Preferred Time"
        },
        {
          "linkId": "alternative-date",
          "type": "date",
          "text": "Alternative Date (if first choice is unavailable)"
        },
        {
          "linkId": "alternative-time",
          "type": "time",
          "text": "Alternative Time"
        },
        {
          "linkId": "urgency",
          "type": "choice",
          "text": "How urgent is this appointment?",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {"code": "radio-button", "display": "Radio Button"}
                ]
              }
            }
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "routine", "display": "Routine - within 2 weeks"}
            },
            {
              "valueCoding": {"code": "soon", "display": "Soon - within a week"}
            },
            {
              "valueCoding": {"code": "urgent", "display": "Urgent - within 2-3 days"}
            },
            {
              "valueCoding": {"code": "asap", "display": "ASAP - as soon as possible"}
            }
          ]
        }
      ]
    },
    {
      "linkId": "last-visit",
      "type": "dateTime",
      "text": "When was your last visit to this clinic?"
    },
    {
      "linkId": "contact-preference",
      "type": "choice",
      "text": "How should we contact you for confirmation?",
      "answerOption": [
        {
          "valueCoding": {"code": "phone", "display": "Phone Call"}
        },
        {
          "valueCoding": {"code": "sms", "display": "Text Message (SMS)"}
        },
        {
          "valueCoding": {"code": "email", "display": "Email"}
        }
      ]
    },
    {
      "linkId": "reminder-time",
      "type": "time",
      "text": "What time of day is best to reach you?"
    },
    {
      "linkId": "special-needs",
      "type": "text",
      "text": "Any special accommodations or notes for your visit?"
    }
  ]
});

/// Document Upload Questionnaire
/// Demonstrates: attachment and reference types
Questionnaire documentUploadQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "document-upload",
  "status": "active",
  "title": "Document Upload",
  "description": "Upload required medical documents and references",
  "item": [
    {
      "linkId": "upload-intro",
      "type": "display",
      "text":
          "Please upload the required documents for your medical record. Supported formats: PDF, JPG, PNG."
    },
    {
      "linkId": "identification",
      "type": "group",
      "text": "Identification Documents",
      "item": [
        {
          "linkId": "photo-id",
          "type": "attachment",
          "text": "Photo ID (Driver's License, Passport, etc.)",
          "required": true
        },
        {
          "linkId": "insurance-card-front",
          "type": "attachment",
          "text": "Insurance Card - Front"
        },
        {
          "linkId": "insurance-card-back",
          "type": "attachment",
          "text": "Insurance Card - Back"
        }
      ]
    },
    {
      "linkId": "medical-records",
      "type": "group",
      "text": "Medical Records",
      "item": [
        {
          "linkId": "previous-records",
          "type": "attachment",
          "text": "Previous Medical Records (if transferring from another provider)"
        },
        {
          "linkId": "lab-results",
          "type": "attachment",
          "text": "Recent Lab Results"
        },
        {
          "linkId": "imaging-results",
          "type": "attachment",
          "text": "Imaging Results (X-Ray, MRI, CT scan)"
        },
        {
          "linkId": "prescription-list",
          "type": "attachment",
          "text": "Current Prescription List"
        }
      ]
    },
    {
      "linkId": "references",
      "type": "group",
      "text": "Healthcare References",
      "item": [
        {
          "linkId": "primary-physician",
          "type": "reference",
          "text": "Primary Care Physician Reference"
        },
        {
          "linkId": "specialist-referral",
          "type": "reference",
          "text": "Specialist Referral Document"
        },
        {
          "linkId": "pharmacy-reference",
          "type": "reference",
          "text": "Preferred Pharmacy Reference"
        }
      ]
    },
    {
      "linkId": "consent-forms",
      "type": "group",
      "text": "Signed Consent Forms",
      "item": [
        {
          "linkId": "hipaa-consent",
          "type": "attachment",
          "text": "Signed HIPAA Consent Form"
        },
        {
          "linkId": "treatment-consent",
          "type": "attachment",
          "text": "Treatment Consent Form"
        }
      ]
    },
    {
      "linkId": "additional-documents",
      "type": "attachment",
      "text": "Any Additional Documents"
    },
    {
      "linkId": "document-notes",
      "type": "text",
      "text": "Notes about uploaded documents (if any)"
    }
  ]
});

/// All Item Types Showcase Questionnaire
/// Demonstrates all 16 supported item types in one questionnaire
Questionnaire allItemTypesShowcase = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "all-item-types-showcase",
  "status": "active",
  "title": "All Item Types Showcase",
  "description":
      "Demonstrates all 16 supported FHIR R4 QuestionnaireItem types",
  "item": [
    // 1. Display type
    {
      "linkId": "type-display",
      "type": "display",
      "text":
          "DISPLAY TYPE: This is read-only informational text. It cannot be answered but provides context and instructions to the user."
    },
    // 2-7. Field types group
    {
      "linkId": "field-types",
      "type": "group",
      "text": "Field Input Types",
      "item": [
        // 2. String type
        {
          "linkId": "type-string",
          "type": "string",
          "text": "STRING TYPE: Single-line text input",
          "initial": [
            {"valueString": "Example text"}
          ]
        },
        // 3. Text type
        {
          "linkId": "type-text",
          "type": "text",
          "text": "TEXT TYPE: Multi-line text area for longer responses"
        },
        // 4. Integer type
        {
          "linkId": "type-integer",
          "type": "integer",
          "text": "INTEGER TYPE: Whole numbers only",
          "initial": [
            {"valueInteger": 42}
          ]
        },
        // 5. Decimal type
        {
          "linkId": "type-decimal",
          "type": "decimal",
          "text": "DECIMAL TYPE: Numbers with decimal places",
          "initial": [
            {"valueDecimal": 3.14159}
          ]
        },
        // 6. URL type
        {
          "linkId": "type-url",
          "type": "url",
          "text": "URL TYPE: Web address input",
          "initial": [
            {"valueUri": "https://example.com"}
          ]
        },
        // 7. Quantity type
        {
          "linkId": "type-quantity",
          "type": "quantity",
          "text": "QUANTITY TYPE: Numeric value with units",
          "initial": [
            {
              "valueQuantity": {
                "value": 75.5,
                "unit": "kg",
                "system": "http://unitsofmeasure.org",
                "code": "kg"
              }
            }
          ]
        }
      ]
    },
    // 8. Boolean type
    {
      "linkId": "type-boolean",
      "type": "boolean",
      "text": "BOOLEAN TYPE: Yes/No question with radio buttons",
      "initial": [
        {"valueBoolean": true}
      ]
    },
    // 9-11. Date/Time types group
    {
      "linkId": "datetime-types",
      "type": "group",
      "text": "Date & Time Types",
      "item": [
        // 9. Date type
        {
          "linkId": "type-date",
          "type": "date",
          "text": "DATE TYPE: Date picker (year, month, day)",
          "initial": [
            {"valueDate": "2025-01-15"}
          ]
        },
        // 10. DateTime type
        {
          "linkId": "type-datetime",
          "type": "dateTime",
          "text": "DATETIME TYPE: Date and time picker",
          "initial": [
            {"valueDateTime": "2025-01-15T14:30:00Z"}
          ]
        },
        // 11. Time type
        {
          "linkId": "type-time",
          "type": "time",
          "text": "TIME TYPE: Time picker (hours:minutes)",
          "initial": [
            {"valueTime": "14:30:00"}
          ]
        }
      ]
    },
    // 12-13. Choice types group
    {
      "linkId": "choice-types",
      "type": "group",
      "text": "Choice Types",
      "item": [
        // 12. Choice type (radio buttons)
        {
          "linkId": "type-choice-radio",
          "type": "choice",
          "text": "CHOICE TYPE (Radio): Single selection with radio buttons",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {"code": "radio-button", "display": "Radio Button"}
                ]
              }
            }
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "option-a", "display": "Option A"}
            },
            {
              "valueCoding": {"code": "option-b", "display": "Option B"}
            },
            {
              "valueCoding": {"code": "option-c", "display": "Option C"}
            }
          ]
        },
        // Choice type (dropdown)
        {
          "linkId": "type-choice-dropdown",
          "type": "choice",
          "text": "CHOICE TYPE (Dropdown): Single selection with dropdown menu",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {"code": "drop-down", "display": "Drop down"}
                ]
              }
            }
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "red", "display": "Red"}
            },
            {
              "valueCoding": {"code": "green", "display": "Green"}
            },
            {
              "valueCoding": {"code": "blue", "display": "Blue"}
            },
            {
              "valueCoding": {"code": "yellow", "display": "Yellow"}
            }
          ]
        },
        // Choice type (autocomplete)
        {
          "linkId": "type-choice-autocomplete",
          "type": "choice",
          "text": "CHOICE TYPE (Autocomplete): Searchable dropdown",
          "extension": [
            {
              "url":
                  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
              "valueCodeableConcept": {
                "coding": [
                  {"code": "autocomplete", "display": "Autocomplete"}
                ]
              }
            }
          ],
          "answerOption": [
            {
              "valueCoding": {"code": "us", "display": "United States"}
            },
            {
              "valueCoding": {"code": "uk", "display": "United Kingdom"}
            },
            {
              "valueCoding": {"code": "ca", "display": "Canada"}
            },
            {
              "valueCoding": {"code": "au", "display": "Australia"}
            },
            {
              "valueCoding": {"code": "de", "display": "Germany"}
            },
            {
              "valueCoding": {"code": "fr", "display": "France"}
            },
            {
              "valueCoding": {"code": "jp", "display": "Japan"}
            }
          ]
        },
        // 13. Open-choice type
        {
          "linkId": "type-open-choice",
          "type": "open-choice",
          "text": "OPEN-CHOICE TYPE: Selection with free-text option",
          "answerOption": [
            {
              "valueCoding": {"code": "morning", "display": "Morning"}
            },
            {
              "valueCoding": {"code": "afternoon", "display": "Afternoon"}
            },
            {
              "valueCoding": {"code": "evening", "display": "Evening"}
            }
          ]
        }
      ]
    },
    // 14-15. Attachment and Reference types group
    {
      "linkId": "resource-types",
      "type": "group",
      "text": "Resource Types",
      "item": [
        // 14. Attachment type
        {
          "linkId": "type-attachment",
          "type": "attachment",
          "text": "ATTACHMENT TYPE: File upload (images, PDFs, documents)"
        },
        // 15. Reference type
        {
          "linkId": "type-reference",
          "type": "reference",
          "text": "REFERENCE TYPE: Reference to FHIR resources"
        }
      ]
    },
    // 16. Nested group example
    {
      "linkId": "nested-group",
      "type": "group",
      "text": "GROUP TYPE: Container for nested items",
      "item": [
        {
          "linkId": "nested-item-1",
          "type": "string",
          "text": "Nested item 1"
        },
        {
          "linkId": "nested-item-2",
          "type": "string",
          "text": "Nested item 2"
        },
        {
          "linkId": "nested-subgroup",
          "type": "group",
          "text": "Nested Subgroup",
          "item": [
            {
              "linkId": "deep-nested-item",
              "type": "boolean",
              "text": "Deeply nested boolean item"
            }
          ]
        }
      ]
    },
    {
      "linkId": "showcase-notes",
      "type": "text",
      "text": "Additional notes about this showcase:"
    }
  ]
});

/// Read-Only Demo Questionnaire with Initial Values
/// Demonstrates: forceReadOnlyView mode with pre-filled data
Questionnaire readOnlyDemoQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "read-only-demo",
  "status": "active",
  "title": "Read-Only Demo",
  "description": "Pre-filled questionnaire displayed in read-only mode",
  "item": [
    {
      "linkId": "ro-intro",
      "type": "display",
      "text": "This questionnaire is displayed in READ-ONLY mode. All fields show pre-filled data but cannot be edited."
    },
    {
      "linkId": "ro-patient",
      "type": "group",
      "text": "Patient Summary",
      "item": [
        {
          "linkId": "ro-name",
          "type": "string",
          "text": "Patient Name",
          "initial": [
            {"valueString": "John Michael Doe"}
          ]
        },
        {
          "linkId": "ro-dob",
          "type": "date",
          "text": "Date of Birth",
          "initial": [
            {"valueDate": "1985-06-15"}
          ]
        },
        {
          "linkId": "ro-gender",
          "type": "choice",
          "text": "Gender",
          "answerOption": [
            {
              "valueCoding": {"code": "male", "display": "Male"}
            },
            {
              "valueCoding": {"code": "female", "display": "Female"}
            }
          ],
          "initial": [
            {
              "valueCoding": {"code": "male", "display": "Male"}
            }
          ]
        },
        {
          "linkId": "ro-active-smoker",
          "type": "boolean",
          "text": "Active Smoker",
          "initial": [
            {"valueBoolean": false}
          ]
        },
        {
          "linkId": "ro-height",
          "type": "decimal",
          "text": "Height (m)",
          "initial": [
            {"valueDecimal": 1.78}
          ]
        },
        {
          "linkId": "ro-weight",
          "type": "quantity",
          "text": "Weight",
          "initial": [
            {
              "valueQuantity": {
                "value": 82.5,
                "unit": "kg",
                "system": "http://unitsofmeasure.org",
                "code": "kg"
              }
            }
          ]
        }
      ]
    },
    {
      "linkId": "ro-last-visit",
      "type": "dateTime",
      "text": "Last Visit",
      "initial": [
        {"valueDateTime": "2025-01-10T09:30:00Z"}
      ]
    }
  ]
});
