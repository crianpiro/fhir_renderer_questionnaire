/// Precision-preserving wrappers for the three FHIR date/time primitives.
///
/// FHIR allows partial dates - `2024`, `2024-03` and `2024-03-15` are all valid
/// `date` values, and the distinction is meaningful ("born in March 2024" is not
/// the same claim as "born on the 1st of March 2024"). A plain [DateTime] cannot
/// represent that, so these thin wrappers keep the original literal and expose a
/// [DateTime] only when you ask for one.
library;

/// How much of a date is actually specified.
enum FhirDatePrecision {
  year,
  month,
  day,

  /// A full timestamp, only ever produced by [FhirDateTime].
  instant,
}

/// A FHIR `date`: a calendar date at year, month or day precision.
///
/// ```dart
/// FhirDate('2024').precision;        // FhirDatePrecision.year
/// FhirDate('2024-03').toString();    // '2024-03' - precision is preserved
/// FhirDate('2024-03-15').toDateTime(); // DateTime(2024, 3, 15)
/// ```
class FhirDate {
  /// Wraps a FHIR date literal verbatim.
  const FhirDate(this.value);

  /// Builds a day-precision date from [dateTime], discarding its time of day.
  factory FhirDate.fromDateTime(DateTime dateTime) => FhirDate(
    '${_pad(dateTime.year, 4)}-${_pad(dateTime.month, 2)}-'
    '${_pad(dateTime.day, 2)}',
  );

  /// The literal as it appeared in the source, e.g. `2024-03`.
  final String value;

  /// How much of the date this value actually specifies.
  FhirDatePrecision get precision {
    final parts = value.split('-').length;
    if (parts >= 3) return FhirDatePrecision.day;
    if (parts == 2) return FhirDatePrecision.month;
    return FhirDatePrecision.year;
  }

  /// The date as a [DateTime], with absent components defaulting to 1.
  ///
  /// Returns `null` when the literal cannot be parsed.
  DateTime? toDateTime() => _parsePartialDate(value);

  /// Whether the literal is a date this package can interpret.
  bool get isValid => toDateTime() != null;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is FhirDate && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A FHIR `dateTime`: a date, optionally with a time and timezone offset.
///
/// Like [FhirDate] this keeps whatever precision the source used, so a value of
/// `2024-03` survives a round-trip instead of becoming a midnight timestamp.
class FhirDateTime {
  /// Wraps a FHIR dateTime literal verbatim.
  const FhirDateTime(this.value);

  /// Builds a full-precision timestamp from [dateTime].
  ///
  /// UTC values are suffixed with `Z`; local values carry their offset, as FHIR
  /// requires an offset whenever a time is present.
  factory FhirDateTime.fromDateTime(DateTime dateTime) {
    final date =
        '${_pad(dateTime.year, 4)}-${_pad(dateTime.month, 2)}-'
        '${_pad(dateTime.day, 2)}';
    final time =
        '${_pad(dateTime.hour, 2)}:${_pad(dateTime.minute, 2)}:'
        '${_pad(dateTime.second, 2)}';
    return FhirDateTime('${date}T$time${_offsetOf(dateTime)}');
  }

  /// The literal as it appeared in the source.
  final String value;

  /// How much of the timestamp this value actually specifies.
  FhirDatePrecision get precision {
    if (value.contains('T')) return FhirDatePrecision.instant;
    final parts = value.split('-').length;
    if (parts >= 3) return FhirDatePrecision.day;
    if (parts == 2) return FhirDatePrecision.month;
    return FhirDatePrecision.year;
  }

  /// The value as a [DateTime], or `null` when it cannot be parsed.
  ///
  /// Date-only literals default their missing components to 1.
  DateTime? toDateTime() =>
      value.contains('T') ? DateTime.tryParse(value) : _parsePartialDate(value);

  /// Whether the literal is a dateTime this package can interpret.
  bool get isValid => toDateTime() != null;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      other is FhirDateTime && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A FHIR `time`: a time of day with no date and no timezone.
///
/// The spec's form is `hh:mm:ss`, but `hh:mm` is accepted too since pickers
/// commonly produce it.
class FhirTime {
  /// Wraps a FHIR time literal verbatim.
  const FhirTime(this.value);

  /// Builds a time from the time-of-day components of [dateTime].
  factory FhirTime.fromDateTime(DateTime dateTime) => FhirTime(
    '${_pad(dateTime.hour, 2)}:${_pad(dateTime.minute, 2)}:'
    '${_pad(dateTime.second, 2)}',
  );

  /// The literal as it appeared in the source, e.g. `09:30:00`.
  final String value;

  /// Seconds elapsed since midnight, or `null` when the literal is unparseable.
  ///
  /// This is what ordering comparisons use, so `09:30` and `09:30:00` compare
  /// equal despite being different literals.
  int? get secondsSinceMidnight {
    final parts = value.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    var second = 0;
    if (parts.length > 2) {
      // Tolerate fractional seconds: '10:30:15.500'.
      final parsed = double.tryParse(parts[2]);
      if (parsed == null || parsed < 0 || parsed >= 60) return null;
      second = parsed.floor();
    }

    return hour * 3600 + minute * 60 + second;
  }

  /// Whether the literal is a time this package can interpret.
  bool get isValid => secondsSinceMidnight != null;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is FhirTime && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Parses `YYYY`, `YYYY-MM` or `YYYY-MM-DD`, defaulting absent parts to 1.
DateTime? _parsePartialDate(String value) {
  final parts = value.split('-');
  if (parts.isEmpty || parts.length > 3) return null;

  final year = int.tryParse(parts[0]);
  if (year == null || parts[0].length != 4) return null;

  var month = 1;
  if (parts.length > 1) {
    final parsed = int.tryParse(parts[1]);
    if (parsed == null || parsed < 1 || parsed > 12) return null;
    month = parsed;
  }

  var day = 1;
  if (parts.length > 2) {
    final parsed = int.tryParse(parts[2]);
    if (parsed == null || parsed < 1 || parsed > 31) return null;
    day = parsed;
  }

  final result = DateTime(year, month, day);
  // Reject impossible dates that DateTime would silently roll over, so
  // '2024-02-31' fails rather than becoming the 2nd of March.
  if (result.month != month || result.day != day) return null;
  return result;
}

String _pad(int value, int width) => value.toString().padLeft(width, '0');

String _offsetOf(DateTime dateTime) {
  if (dateTime.isUtc) return 'Z';
  final offset = dateTime.timeZoneOffset;
  final sign = offset.isNegative ? '-' : '+';
  final minutes = offset.inMinutes.abs();
  return '$sign${_pad(minutes ~/ 60, 2)}:${_pad(minutes % 60, 2)}';
}
