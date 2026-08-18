/// Internal JSON plumbing shared by the model classes.
///
/// Not exported from the public library.
///
/// The models type only the fields this package renders. Everything else in the
/// source JSON - `contact`, `jurisdiction`, primitive extension siblings like
/// `_text`, vendor extensions - is carried untouched in an "extra" map and
/// written back out by `toJson`, so parsing a questionnaire and re-serializing
/// it never silently drops data.
library;

/// Keys FHIR puts on every element, preserved but never modelled.
const Set<String> commonElementKeys = {'id'};

/// Returns the entries of [json] that no typed field claims.
///
/// [modelled] lists the keys the caller reads into fields. Keys beginning with
/// `_` (FHIR's primitive-extension siblings) are always treated as extra, since
/// they annotate a modelled field rather than replacing it.
Map<String, dynamic> extraJsonFrom(
  Map<String, dynamic> json,
  Set<String> modelled,
) {
  final extras = <String, dynamic>{};
  for (final entry in json.entries) {
    if (!modelled.contains(entry.key)) {
      extras[entry.key] = entry.value;
    }
  }
  return extras;
}

/// Adds [value] to [json] under [key], skipping nulls so absent stays absent.
void putIfNotNull(Map<String, dynamic> json, String key, Object? value) {
  if (value != null) json[key] = value;
}

/// Reads a JSON object, tolerating a non-map value by returning `null`.
Map<String, dynamic>? asJsonObject(Object? raw) =>
    raw is Map ? Map<String, dynamic>.from(raw) : null;

/// Parses a JSON array of objects into a typed list.
///
/// Returns `null` when the key was absent, and an empty list when it held an
/// empty array - the difference matters for faithful re-serialization.
List<T>? parseObjectList<T>(
  Object? raw,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (raw is! List) return null;
  return raw
      .map(asJsonObject)
      .where((json) => json != null)
      .map((json) => fromJson(json!))
      .toList(growable: false);
}

/// Serializes a typed list back to a JSON array, preserving `null` vs empty.
List<Map<String, dynamic>>? encodeObjectList<T>(
  List<T>? items,
  Map<String, dynamic> Function(T item) toJson,
) => items?.map(toJson).toList(growable: false);

/// Reads a JSON string, ignoring values of the wrong type.
String? asString(Object? raw) => raw is String ? raw : null;

/// Reads a JSON boolean, ignoring values of the wrong type.
bool? asBool(Object? raw) => raw is bool ? raw : null;

/// Reads a JSON integer, accepting an integral double.
int? asInt(Object? raw) {
  if (raw is int) return raw;
  if (raw is double && raw == raw.roundToDouble()) return raw.toInt();
  return null;
}

/// Deep structural equality for the JSON-ish values held in extra maps.
bool deepEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || !deepEquals(a[key], b[key])) return false;
    }
    return true;
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!deepEquals(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

/// Order-independent hash for maps, order-dependent for lists.
///
/// Pairs with [deepEquals] so equal values always hash equally.
int deepHash(Object? value) {
  if (value is Map) {
    // XOR keeps the result independent of iteration order.
    var hash = 0;
    for (final entry in value.entries) {
      hash ^= Object.hash(entry.key, deepHash(entry.value));
    }
    return hash;
  }
  if (value is List) {
    return Object.hashAll(value.map(deepHash));
  }
  return value.hashCode;
}

/// Deep equality for lists of model objects, treating `null` and `[]` as
/// distinct.
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Hash for a nullable list of model objects.
int listHash<T>(List<T>? items) =>
    items == null ? 0 : Object.hashAll(items.map((item) => item.hashCode));

/// A JSON number that remembers how it was written.
///
/// FHIR decimals carry significance in their representation: `1` and `1.0` are
/// different literals. Storing the original token lets `toJson` emit exactly
/// what came in, while callers still read a plain [double].
class DecimalValue {
  const DecimalValue(this.raw);

  /// Builds a decimal from a Dart [double].
  const DecimalValue.fromDouble(double value) : raw = value;

  /// The number exactly as it appeared in JSON.
  final num raw;

  /// The value as a [double], which is what callers work with.
  double get asDouble => raw.toDouble();

  /// Reads a decimal, ignoring values of the wrong type.
  static DecimalValue? fromJson(Object? value) =>
      value is num ? DecimalValue(value) : null;

  /// The token to write back to JSON.
  num toJson() => raw;

  @override
  String toString() => raw.toString();

  @override
  bool operator ==(Object other) =>
      other is DecimalValue && other.raw == raw && other.raw.runtimeType == raw.runtimeType;

  @override
  int get hashCode => Object.hash(raw, raw.runtimeType);
}
