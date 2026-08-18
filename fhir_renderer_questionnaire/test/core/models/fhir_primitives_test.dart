import 'package:flutter_test/flutter_test.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';

void main() {
  group('FhirDate', () {
    test('preserves the precision of the source literal', () {
      expect(const FhirDate('2024').precision, FhirDatePrecision.year);
      expect(const FhirDate('2024-03').precision, FhirDatePrecision.month);
      expect(const FhirDate('2024-03-15').precision, FhirDatePrecision.day);
    });

    test('round-trips a partial date without inventing components', () {
      // The whole point of the wrapper: a plain DateTime would turn this into
      // 2024-03-01 and lose the fact that the day was never stated.
      expect(const FhirDate('2024-03').toString(), '2024-03');
      expect(const FhirDate('2024').toString(), '2024');
    });

    test('defaults absent components to 1 when converting to DateTime', () {
      expect(const FhirDate('2024').toDateTime(), DateTime(2024, 1, 1));
      expect(const FhirDate('2024-03').toDateTime(), DateTime(2024, 3, 1));
      expect(const FhirDate('2024-03-15').toDateTime(), DateTime(2024, 3, 15));
    });

    test('rejects malformed and impossible dates', () {
      expect(const FhirDate('not-a-date').toDateTime(), isNull);
      expect(const FhirDate('24-03-15').toDateTime(), isNull, reason: '2-digit year');
      expect(const FhirDate('2024-13').toDateTime(), isNull, reason: 'month 13');
      // DateTime() would silently roll this over to the 2nd of March.
      expect(const FhirDate('2024-02-31').toDateTime(), isNull);
      expect(const FhirDate('2024-03-15').isValid, isTrue);
      expect(const FhirDate('2024-02-31').isValid, isFalse);
    });

    test('builds a day-precision literal from a DateTime', () {
      expect(
        FhirDate.fromDateTime(DateTime(2024, 3, 5, 13, 45)).value,
        '2024-03-05',
      );
    });

    test('compares by literal value', () {
      expect(const FhirDate('2024-03'), const FhirDate('2024-03'));
      expect(const FhirDate('2024-03').hashCode, const FhirDate('2024-03').hashCode);
      expect(const FhirDate('2024-03'), isNot(const FhirDate('2024-03-01')));
    });
  });

  group('FhirDateTime', () {
    test('parses a full timestamp including offset', () {
      expect(
        const FhirDateTime('2024-03-15T10:30:00Z').toDateTime(),
        DateTime.utc(2024, 3, 15, 10, 30),
      );
      expect(const FhirDateTime('2024-03-15T10:30:00Z').precision,
          FhirDatePrecision.instant);
    });

    test('accepts a date-only literal, keeping its precision', () {
      expect(const FhirDateTime('2024-03').precision, FhirDatePrecision.month);
      expect(const FhirDateTime('2024-03').toDateTime(), DateTime(2024, 3, 1));
    });

    test('builds a literal with an offset from a DateTime', () {
      expect(
        FhirDateTime.fromDateTime(DateTime.utc(2024, 3, 5, 9, 7, 2)).value,
        '2024-03-05T09:07:02Z',
      );
    });

    test('returns null for an unparseable literal', () {
      expect(const FhirDateTime('nonsense').toDateTime(), isNull);
      expect(const FhirDateTime('nonsense').isValid, isFalse);
    });
  });

  group('FhirTime', () {
    test('converts to seconds since midnight', () {
      expect(const FhirTime('00:00:00').secondsSinceMidnight, 0);
      expect(const FhirTime('09:30').secondsSinceMidnight, 9 * 3600 + 30 * 60);
      expect(
        const FhirTime('23:59:59').secondsSinceMidnight,
        23 * 3600 + 59 * 60 + 59,
      );
    });

    test('accepts both hh:mm and hh:mm:ss, and fractional seconds', () {
      // Ordering compares the numeric form, so these are equivalent times even
      // though they are different literals.
      expect(
        const FhirTime('09:30').secondsSinceMidnight,
        const FhirTime('09:30:00').secondsSinceMidnight,
      );
      expect(const FhirTime('10:30:15.500').secondsSinceMidnight,
          10 * 3600 + 30 * 60 + 15);
    });

    test('rejects out-of-range and malformed times', () {
      expect(const FhirTime('24:00:00').secondsSinceMidnight, isNull);
      expect(const FhirTime('10:60').secondsSinceMidnight, isNull);
      expect(const FhirTime('10').secondsSinceMidnight, isNull);
      expect(const FhirTime('abc:def').secondsSinceMidnight, isNull);
    });

    test('keeps the original literal', () {
      expect(const FhirTime('09:30').toString(), '09:30');
      expect(const FhirTime('09:30'), isNot(const FhirTime('09:30:00')));
    });
  });

  group('enum code mapping', () {
    test('maps FHIR wire codes, including the hyphenated ones', () {
      expect(QuestionnaireItemType.fromCode('open-choice'),
          QuestionnaireItemType.openChoice);
      expect(QuestionnaireItemType.fromCode('display'),
          QuestionnaireItemType.display_);
      expect(QuestionnaireItemType.openChoice.code, 'open-choice');
      expect(QuestionnaireItemOperator.fromCode('>='),
          QuestionnaireItemOperator.ge);
      expect(QuestionnaireResponseStatus.fromCode('in-progress'),
          QuestionnaireResponseStatus.inProgress);
    });

    test('returns null for unknown codes rather than throwing', () {
      // Tolerant parsing: a questionnaire from a newer source still renders.
      expect(QuestionnaireItemType.fromCode('future-type'), isNull);
      expect(QuestionnaireItemOperator.fromCode('~='), isNull);
      expect(QuestionnaireResponseStatus.fromCode(null), isNull);
    });
  });
}
