import 'package:flutter_test/flutter_test.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';

void main() {
  group('Questionnaire.fromJson', () {
    test('reads the fields the renderer uses', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'id': 'demographics',
        'url': 'http://example.org/Questionnaire/demographics',
        'title': 'Patient Demographics',
        'status': 'active',
        'item': [
          {
            'linkId': 'name',
            'text': 'Full name',
            'type': 'string',
            'required': true,
            'maxLength': 60,
          },
        ],
      });

      expect(questionnaire.id, 'demographics');
      expect(questionnaire.title, 'Patient Demographics');
      expect(questionnaire.status, QuestionnairePublicationStatus.active);
      expect(questionnaire.item, hasLength(1));

      final item = questionnaire.item!.single;
      expect(item.linkId, 'name');
      expect(item.text, 'Full name');
      expect(item.type, QuestionnaireItemType.string);
      expect(item.required_, isTrue);
      expect(item.maxLength, 60);
    });

    test('parses nested items recursively', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {
            'linkId': 'group',
            'type': 'group',
            'item': [
              {
                'linkId': 'child',
                'type': 'boolean',
                'item': [
                  {'linkId': 'grandchild', 'type': 'integer'},
                ],
              },
            ],
          },
        ],
      });

      final group = questionnaire.item!.single;
      expect(group.type, QuestionnaireItemType.group);
      final child = group.item!.single;
      expect(child.linkId, 'child');
      expect(child.item!.single.linkId, 'grandchild');
      expect(child.item!.single.type, QuestionnaireItemType.integer);
    });

    test('falls back to a display item for an unknown or absent type', () {
      // `type` is required by FHIR; rather than throw, render the text only.
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {'linkId': 'a', 'type': 'something-new'},
          {'linkId': 'b'},
        ],
      });

      expect(questionnaire.item![0].type, QuestionnaireItemType.display_);
      expect(questionnaire.item![1].type, QuestionnaireItemType.display_);
    });

    test('parses enableWhen conditions with their operator and answer', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {
            'linkId': 'followup',
            'type': 'string',
            'enableBehavior': 'all',
            'enableWhen': [
              {'question': 'age', 'operator': '>=', 'answerInteger': 18},
              {'question': 'consent', 'operator': '=', 'answerBoolean': true},
            ],
          },
        ],
      });

      final item = questionnaire.item!.single;
      expect(item.enableBehavior, QuestionnaireEnableBehavior.all);
      expect(item.enableWhen, hasLength(2));
      expect(item.enableWhen![0].question, 'age');
      expect(item.enableWhen![0].operator_, QuestionnaireItemOperator.ge);
      expect(item.enableWhen![0].answerInteger, 18);
      expect(item.enableWhen![0].answer, 18);
      expect(item.enableWhen![1].answerBoolean, isTrue);
    });

    test('parses answer options and their codings', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {
            'linkId': 'colour',
            'type': 'choice',
            'answerOption': [
              {
                'valueCoding': {
                  'system': 'http://example.org/colours',
                  'code': 'red',
                  'display': 'Red',
                },
              },
            ],
          },
        ],
      });

      final option = questionnaire.item!.single.answerOption!.single;
      expect(option.valueCoding?.code, 'red');
      expect(option.valueCoding?.display, 'Red');
      expect(option.valueCoding?.system, 'http://example.org/colours');
      expect(option.value, option.valueCoding);
    });

    test('ignores values of the wrong JSON type instead of throwing', () {
      final questionnaire = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {'linkId': 'a', 'type': 'string', 'maxLength': 'not-a-number'},
        ],
      });

      expect(questionnaire.item!.single.maxLength, isNull);
    });
  });

  group('round-trip', () {
    test('preserves fields the package does not model', () {
      // The renderer has no use for contact/jurisdiction/publisher, but a
      // caller who parses and re-serializes must not lose them.
      const source = {
        'resourceType': 'Questionnaire',
        'id': 'q1',
        'status': 'active',
        'publisher': 'Example Org',
        'jurisdiction': [
          {
            'coding': [
              {'system': 'urn:iso:std:iso:3166', 'code': 'DE'},
            ],
          },
        ],
        'contact': [
          {
            'name': 'Support',
            'telecom': [
              {'system': 'email', 'value': 'support@example.org'},
            ],
          },
        ],
        'useContext': [
          {
            'code': {'code': 'focus'},
            'valueCodeableConcept': {'text': 'primary care'},
          },
        ],
        'item': [
          {'linkId': 'a', 'type': 'string'},
        ],
      };

      expect(Questionnaire.fromJson(source).toJson(), equals(source));
    });

    test('preserves unmodelled fields on nested items and extensions', () {
      const source = {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {
            'linkId': 'a',
            'type': 'string',
            // Primitive extension sibling - annotates `text`, not modelled.
            '_text': {
              'extension': [
                {'url': 'http://example.org/rendering', 'valueString': 'bold'},
              ],
            },
            'enableWhen': [
              {'question': 'b', 'operator': '=', 'answerString': 'yes'},
            ],
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/regex',
                'valueString': r'^\d+$',
              },
              {
                'url': 'http://example.org/unknown',
                'valueDateTime': '2024-03-15T10:30:00Z',
              },
            ],
          },
        ],
      };

      expect(Questionnaire.fromJson(source).toJson(), equals(source));
    });

    test('keeps a decimal written as an integer written as an integer', () {
      // FHIR decimals carry significance in their representation, so `1` must
      // not come back as `1.0`.
      const source = {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': [
          {
            'linkId': 'score',
            'type': 'decimal',
            'initial': [
              {'valueDecimal': 1},
            ],
          },
          {
            'linkId': 'weight',
            'type': 'decimal',
            'initial': [
              {'valueDecimal': 72.5},
            ],
          },
        ],
      };

      final parsed = Questionnaire.fromJson(source);
      expect(parsed.item![0].initial!.single.valueDecimal, 1.0);
      expect(parsed.item![1].initial!.single.valueDecimal, 72.5);
      expect(parsed.toJson(), equals(source));
    });

    test('distinguishes an absent list from an empty one', () {
      final absent = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
      });
      final empty = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'item': <Object>[],
      });

      expect(absent.item, isNull);
      expect(empty.item, isEmpty);
      expect(absent.toJson().containsKey('item'), isFalse);
      expect(empty.toJson()['item'], isEmpty);
    });

    test('preserves partial date precision through a round-trip', () {
      const source = {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'date': '2024-03',
        'item': [
          {
            'linkId': 'dob',
            'type': 'date',
            'initial': [
              {'valueDate': '1990'},
            ],
          },
        ],
      };

      final parsed = Questionnaire.fromJson(source);
      expect(parsed.date?.precision, FhirDatePrecision.month);
      expect(parsed.item!.single.initial!.single.valueDate?.value, '1990');
      expect(parsed.toJson(), equals(source));
    });
  });

  group('equality', () {
    test('two questionnaires parsed from the same JSON are equal', () {
      const source = {
        'resourceType': 'Questionnaire',
        'id': 'q1',
        'status': 'active',
        'item': [
          {'linkId': 'a', 'type': 'string', 'required': true},
        ],
      };

      final a = Questionnaire.fromJson(source);
      final b = Questionnaire.fromJson(source);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a difference in an unmodelled field still breaks equality', () {
      final a = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'publisher': 'One',
      });
      final b = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'publisher': 'One',
        'jurisdiction': [
          {'text': 'DE'},
        ],
      });

      expect(a, isNot(equals(b)));
    });

    test('copyWith carries unmodelled fields forward', () {
      final original = Questionnaire.fromJson(const {
        'resourceType': 'Questionnaire',
        'status': 'active',
        'publisher': 'Example Org',
        'jurisdiction': [
          {'text': 'DE'},
        ],
      });

      final copy = original.copyWith(title: 'Renamed');

      expect(copy.title, 'Renamed');
      expect(copy.toJson()['jurisdiction'], isNotNull);
      expect(copy.toJson()['publisher'], 'Example Org');
    });
  });

  group('extension lookup', () {
    QuestionnaireItem itemWithExtensions(List<Map<String, Object?>> exts) =>
        QuestionnaireItem.fromJson({
          'linkId': 'a',
          'type': 'string',
          'extension': exts,
        });

    test('reads the regex and entryFormat extensions', () {
      final item = itemWithExtensions([
        {
          'url': 'http://hl7.org/fhir/StructureDefinition/regex',
          'valueString': r'^\d{5}$',
        },
        {
          'url': 'http://hl7.org/fhir/StructureDefinition/entryFormat',
          'valueString': 'Enter a 5 digit postcode',
        },
      ]);

      expect(item.regexValidationPattern, r'^\d{5}$');
      expect(item.regexValidationErrorMessage, 'Enter a 5 digit postcode');
    });

    test('reads the itemControl code out of its CodeableConcept', () {
      final item = itemWithExtensions([
        {
          'url':
              'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
          'valueCodeableConcept': {
            'coding': [
              {
                'system': 'http://hl7.org/fhir/questionnaire-item-control',
                'code': 'drop-down',
              },
            ],
          },
        },
      ]);

      expect(item.itemControlCode, 'drop-down');
    });

    test('returns null when the extension is absent', () {
      final item = itemWithExtensions([
        {'url': 'http://example.org/other', 'valueString': 'x'},
      ]);

      expect(item.regexValidationPattern, isNull);
      expect(item.itemControlCode, isNull);
      expect(
        QuestionnaireItem.fromJson(const {'linkId': 'a', 'type': 'string'})
            .regexValidationPattern,
        isNull,
      );
    });

    test('reads optionExclusive off an answer option', () {
      final exclusive = QuestionnaireAnswerOption.fromJson(const {
        'valueCoding': {'code': 'none'},
        'extension': [
          {
            'url':
                'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
            'valueBoolean': true,
          },
        ],
      });
      final normal = QuestionnaireAnswerOption.fromJson(const {
        'valueCoding': {'code': 'red'},
      });

      expect(exclusive.isOptionExclusive, isTrue);
      expect(normal.isOptionExclusive, isFalse);
    });
  });

  test('canonicalReference points at the questionnaire by id', () {
    final questionnaire = Questionnaire.fromJson(const {
      'resourceType': 'Questionnaire',
      'id': 'demographics',
      'status': 'active',
    });

    expect(questionnaire.canonicalReference, 'Questionnaire/demographics');
  });
}
