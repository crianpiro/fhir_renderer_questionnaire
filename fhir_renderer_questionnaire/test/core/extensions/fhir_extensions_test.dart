import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:test/test.dart';

void main() {
  group('FhirRendererQuestionnaireExtensions', () {
    test('should return canonical URI for resource', () {
      final questionnaire = Questionnaire.fromJson({
        'resourceType': 'Questionnaire',
        'id': 'test-questionnaire-123',
        'status': 'active',
      });

      final canonical = questionnaire.canonicalReference;

      expect(canonical, isA<String>());
      expect(canonical, equals('Questionnaire/test-questionnaire-123'));
    });

    test('should handle resource without ID', () {
      final questionnaire = Questionnaire.fromJson({
        'resourceType': 'Questionnaire',
        'status': 'active',
      });

      final canonical = questionnaire.canonicalReference;

      expect(canonical.toString(), equals('Questionnaire/null'));
    });
  });

  group('QuestionnaireItemValidationExtensions', () {
    group('regexValidationPattern', () {
      test('should extract regex pattern from extension', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'phone',
          'type': 'string',
          'text': 'Phone Number',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/regex',
              'valueString': r'^\+?[1-9]\d{1,14}$',
            },
          ],
        });

        expect(item.regexValidationPattern, equals(r'^\+?[1-9]\d{1,14}$'));
      });

      test('should return null when no regex extension exists', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
          'text': 'Name',
        });

        expect(item.regexValidationPattern, isNull);
      });

      test('should return null when extension list is empty', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
          'text': 'Name',
          'extension': [],
        });

        expect(item.regexValidationPattern, isNull);
      });

      test('should return null when regex extension has no valueString', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'test',
          'type': 'string',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/regex',
            },
          ],
        });

        expect(item.regexValidationPattern, isNull);
      });

      test('should ignore other extensions and find regex', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'email',
          'type': 'string',
          'extension': [
            {
              'url': 'http://example.com/other-extension',
              'valueString': 'other value',
            },
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/regex',
              'valueString': r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            },
          ],
        });

        expect(item.regexValidationPattern, equals(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));
      });
    });

    group('regexValidationErrorMessage', () {
      test('should extract error message from entryFormat extension', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'phone',
          'type': 'string',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/entryFormat',
              'valueString': 'Please enter a valid phone number',
            },
          ],
        });

        expect(item.regexValidationErrorMessage, equals('Please enter a valid phone number'));
      });

      test('should return null when no entryFormat extension exists', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
        });

        expect(item.regexValidationErrorMessage, isNull);
      });

      test('should return null when extension list is empty', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'name',
          'type': 'string',
          'extension': [],
        });

        expect(item.regexValidationErrorMessage, isNull);
      });

      test('should handle both regex and entryFormat extensions', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'email',
          'type': 'string',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/regex',
              'valueString': r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            },
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/entryFormat',
              'valueString': 'Invalid email format',
            },
          ],
        });

        expect(item.regexValidationPattern, isNotNull);
        expect(item.regexValidationErrorMessage, equals('Invalid email format'));
      });
    });

    group('itemControlCode', () {
      test('should extract drop-down control code', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'system': 'http://hl7.org/fhir/questionnaire-item-control',
                    'code': 'drop-down',
                  },
                ],
              },
            },
          ],
        });

        expect(item.itemControlCode, equals('drop-down'));
      });

      test('should extract radio-button control code', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'choice',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'system': 'http://hl7.org/fhir/questionnaire-item-control',
                    'code': 'radio-button',
                  },
                ],
              },
            },
          ],
        });

        expect(item.itemControlCode, equals('radio-button'));
      });

      test('should extract check-box control code', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'multi',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'system': 'http://hl7.org/fhir/questionnaire-item-control',
                    'code': 'check-box',
                  },
                ],
              },
            },
          ],
        });

        expect(item.itemControlCode, equals('check-box'));
      });

      test('should return null when no itemControl extension exists', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'choice',
          'type': 'choice',
        });

        expect(item.itemControlCode, isNull);
      });

      test('should return null when extension list is empty', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'choice',
          'type': 'choice',
          'extension': [],
        });

        expect(item.itemControlCode, isNull);
      });

      test('should return null when coding is missing', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'choice',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {},
            },
          ],
        });

        expect(item.itemControlCode, isNull);
      });

      test('should handle autocomplete control code', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'search',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'system': 'http://hl7.org/fhir/questionnaire-item-control',
                    'code': 'autocomplete',
                  },
                ],
              },
            },
          ],
        });

        expect(item.itemControlCode, equals('autocomplete'));
      });

      test('should ignore other extensions and find itemControl', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'choice',
          'type': 'choice',
          'extension': [
            {
              'url': 'http://example.com/other',
              'valueString': 'other',
            },
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'code': 'drop-down',
                  },
                ],
              },
            },
          ],
        });

        expect(item.itemControlCode, equals('drop-down'));
      });
    });

    group('multiple extensions together', () {
      test('should extract all validation-related extensions', () {
        final item = QuestionnaireItem.fromJson({
          'linkId': 'validated-field',
          'type': 'string',
          'extension': [
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/regex',
              'valueString': r'^\d{3}-\d{2}-\d{4}$',
            },
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/entryFormat',
              'valueString': 'SSN format: XXX-XX-XXXX',
            },
            {
              'url': 'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'code': 'drop-down',
                  },
                ],
              },
            },
          ],
        });

        expect(item.regexValidationPattern, equals(r'^\d{3}-\d{2}-\d{4}$'));
        expect(item.regexValidationErrorMessage, equals('SSN format: XXX-XX-XXXX'));
        expect(item.itemControlCode, equals('drop-down'));
      });
    });
  });

  group('QuestionnaireAnswerOptionExtensions', () {
    group('isOptionExclusive', () {
      test('should be true when optionExclusive extension is set', () {
        final option = QuestionnaireAnswerOption.fromJson({
          'extension': [
            {
              'url':
                  'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
              'valueBoolean': true,
            },
          ],
          'valueCoding': {'code': 'none'},
        });

        expect(option.isOptionExclusive, isTrue);
      });

      test('should be false when optionExclusive extension is false', () {
        final option = QuestionnaireAnswerOption.fromJson({
          'extension': [
            {
              'url':
                  'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
              'valueBoolean': false,
            },
          ],
          'valueCoding': {'code': 'cough'},
        });

        expect(option.isOptionExclusive, isFalse);
      });

      test('should be false when no extension exists', () {
        final option = QuestionnaireAnswerOption.fromJson({
          'valueCoding': {'code': 'cough'},
        });

        expect(option.isOptionExclusive, isFalse);
      });
    });
  });
}
