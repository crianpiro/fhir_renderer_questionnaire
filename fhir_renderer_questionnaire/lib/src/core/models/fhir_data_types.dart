/// The FHIR R4 general-purpose datatypes a Questionnaire actually uses.
///
/// Only the fields this package reads are typed; anything else in the source
/// JSON is preserved verbatim and written back by `toJson`.
library;

import 'fhir_primitives.dart';
import 'json_support.dart';

/// A code drawn from a terminology system.
///
/// See https://hl7.org/fhir/R4/datatypes.html#Coding
class Coding {
  const Coding({
    this.system,
    this.version,
    this.code,
    this.display,
    this.userSelected,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `Coding` from FHIR JSON.
  factory Coding.fromJson(Map<String, dynamic> json) => Coding(
    system: asString(json['system']),
    version: asString(json['version']),
    code: asString(json['code']),
    display: asString(json['display']),
    userSelected: asBool(json['userSelected']),
    extraJson: extraJsonFrom(json, _modelledKeys),
  );

  static const Set<String> _modelledKeys = {
    'system',
    'version',
    'code',
    'display',
    'userSelected',
  };

  /// Identity of the terminology system.
  final String? system;

  /// Version of the system, if relevant.
  final String? version;

  /// Symbol in syntax defined by the system.
  final String? code;

  /// Representation defined by the system.
  final String? display;

  /// Whether this coding was chosen directly by the user.
  final bool? userSelected;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'system', system);
    putIfNotNull(json, 'version', version);
    putIfNotNull(json, 'code', code);
    putIfNotNull(json, 'display', display);
    putIfNotNull(json, 'userSelected', userSelected);
    return json;
  }

  Coding copyWith({
    String? system,
    String? version,
    String? code,
    String? display,
    bool? userSelected,
  }) => Coding(
    system: system ?? this.system,
    version: version ?? this.version,
    code: code ?? this.code,
    display: display ?? this.display,
    userSelected: userSelected ?? this.userSelected,
    extraJson: _extraJson,
  );

  @override
  String toString() => 'Coding(system: $system, code: $code, display: $display)';

  @override
  bool operator ==(Object other) =>
      other is Coding &&
      other.system == system &&
      other.version == version &&
      other.code == code &&
      other.display == display &&
      other.userSelected == userSelected &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    system,
    version,
    code,
    display,
    userSelected,
    deepHash(_extraJson),
  );
}

/// A concept described by one or more [Coding]s and/or free text.
///
/// See https://hl7.org/fhir/R4/datatypes.html#CodeableConcept
class CodeableConcept {
  const CodeableConcept({
    this.coding,
    this.text,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `CodeableConcept` from FHIR JSON.
  factory CodeableConcept.fromJson(Map<String, dynamic> json) =>
      CodeableConcept(
        coding: parseObjectList(json['coding'], Coding.fromJson),
        text: asString(json['text']),
        extraJson: extraJsonFrom(json, _modelledKeys),
      );

  static const Set<String> _modelledKeys = {'coding', 'text'};

  /// Codes defined by terminology systems.
  final List<Coding>? coding;

  /// Plain text representation of the concept.
  final String? text;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'coding', encodeObjectList(coding, (c) => c.toJson()));
    putIfNotNull(json, 'text', text);
    return json;
  }

  CodeableConcept copyWith({List<Coding>? coding, String? text}) =>
      CodeableConcept(
        coding: coding ?? this.coding,
        text: text ?? this.text,
        extraJson: _extraJson,
      );

  @override
  String toString() => 'CodeableConcept(coding: $coding, text: $text)';

  @override
  bool operator ==(Object other) =>
      other is CodeableConcept &&
      listEquals(other.coding, coding) &&
      other.text == text &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode =>
      Object.hash(listHash(coding), text, deepHash(_extraJson));
}

/// Content in a variety of media types, attached to an answer.
///
/// See https://hl7.org/fhir/R4/datatypes.html#Attachment
class Attachment {
  const Attachment({
    this.contentType,
    this.language,
    this.data,
    this.url,
    this.size,
    this.hash,
    this.title,
    this.creation,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses an `Attachment` from FHIR JSON.
  factory Attachment.fromJson(Map<String, dynamic> json) {
    final creation = asString(json['creation']);
    return Attachment(
      contentType: asString(json['contentType']),
      language: asString(json['language']),
      data: asString(json['data']),
      url: asString(json['url']),
      size: asInt(json['size']),
      hash: asString(json['hash']),
      title: asString(json['title']),
      creation: creation == null ? null : FhirDateTime(creation),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'contentType',
    'language',
    'data',
    'url',
    'size',
    'hash',
    'title',
    'creation',
  };

  /// Mime type of the content, e.g. `application/pdf`.
  final String? contentType;

  /// Human language of the content.
  final String? language;

  /// The content, base64 encoded.
  final String? data;

  /// Location the data can be retrieved from.
  final String? url;

  /// Number of bytes of content.
  final int? size;

  /// SHA-1 hash of the content, base64 encoded.
  final String? hash;

  /// Label to display in place of the data.
  final String? title;

  /// Date the attachment was first created.
  final FhirDateTime? creation;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'contentType', contentType);
    putIfNotNull(json, 'language', language);
    putIfNotNull(json, 'data', data);
    putIfNotNull(json, 'url', url);
    putIfNotNull(json, 'size', size);
    putIfNotNull(json, 'hash', hash);
    putIfNotNull(json, 'title', title);
    putIfNotNull(json, 'creation', creation?.value);
    return json;
  }

  Attachment copyWith({
    String? contentType,
    String? language,
    String? data,
    String? url,
    int? size,
    String? hash,
    String? title,
    FhirDateTime? creation,
  }) => Attachment(
    contentType: contentType ?? this.contentType,
    language: language ?? this.language,
    data: data ?? this.data,
    url: url ?? this.url,
    size: size ?? this.size,
    hash: hash ?? this.hash,
    title: title ?? this.title,
    creation: creation ?? this.creation,
    extraJson: _extraJson,
  );

  @override
  String toString() =>
      'Attachment(title: $title, contentType: $contentType, size: $size)';

  @override
  bool operator ==(Object other) =>
      other is Attachment &&
      other.contentType == contentType &&
      other.language == language &&
      other.data == data &&
      other.url == url &&
      other.size == size &&
      other.hash == hash &&
      other.title == title &&
      other.creation == creation &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    contentType,
    language,
    data,
    url,
    size,
    hash,
    title,
    creation,
    deepHash(_extraJson),
  );
}

/// A reference from one resource to another.
///
/// See https://hl7.org/fhir/R4/references.html#Reference
class Reference {
  const Reference({
    this.reference,
    this.type,
    this.display,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `Reference` from FHIR JSON.
  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
    reference: asString(json['reference']),
    type: asString(json['type']),
    display: asString(json['display']),
    extraJson: extraJsonFrom(json, _modelledKeys),
  );

  static const Set<String> _modelledKeys = {'reference', 'type', 'display'};

  /// Literal reference, e.g. `Patient/123`.
  final String? reference;

  /// Type the reference refers to, e.g. `Patient`.
  final String? type;

  /// Text alternative for the resource.
  final String? display;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'reference', reference);
    putIfNotNull(json, 'type', type);
    putIfNotNull(json, 'display', display);
    return json;
  }

  Reference copyWith({String? reference, String? type, String? display}) =>
      Reference(
        reference: reference ?? this.reference,
        type: type ?? this.type,
        display: display ?? this.display,
        extraJson: _extraJson,
      );

  @override
  String toString() => 'Reference(reference: $reference, display: $display)';

  @override
  bool operator ==(Object other) =>
      other is Reference &&
      other.reference == reference &&
      other.type == type &&
      other.display == display &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode =>
      Object.hash(reference, type, display, deepHash(_extraJson));
}

/// A measured amount.
///
/// See https://hl7.org/fhir/R4/datatypes.html#Quantity
class Quantity {
  Quantity({
    double? value,
    this.comparator,
    this.unit,
    this.system,
    this.code,
    Map<String, dynamic> extraJson = const {},
  }) : _value = value == null ? null : DecimalValue.fromDouble(value),
       _extraJson = extraJson;

  Quantity._({
    DecimalValue? value,
    this.comparator,
    this.unit,
    this.system,
    this.code,
    Map<String, dynamic> extraJson = const {},
  }) : _value = value,
       _extraJson = extraJson;

  /// Parses a `Quantity` from FHIR JSON.
  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity._(
    value: DecimalValue.fromJson(json['value']),
    comparator: asString(json['comparator']),
    unit: asString(json['unit']),
    system: asString(json['system']),
    code: asString(json['code']),
    extraJson: extraJsonFrom(json, _modelledKeys),
  );

  static const Set<String> _modelledKeys = {
    'value',
    'comparator',
    'unit',
    'system',
    'code',
  };

  final DecimalValue? _value;

  /// Numerical value of the quantity.
  double? get value => _value?.asDouble;

  /// How to understand the value: `<`, `<=`, `>=` or `>`.
  final String? comparator;

  /// Unit representation.
  final String? unit;

  /// System that defines the coded unit form.
  final String? system;

  /// Coded form of the unit.
  final String? code;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'value', _value?.toJson());
    putIfNotNull(json, 'comparator', comparator);
    putIfNotNull(json, 'unit', unit);
    putIfNotNull(json, 'system', system);
    putIfNotNull(json, 'code', code);
    return json;
  }

  Quantity copyWith({
    double? value,
    String? comparator,
    String? unit,
    String? system,
    String? code,
  }) => Quantity._(
    value: value == null ? _value : DecimalValue.fromDouble(value),
    comparator: comparator ?? this.comparator,
    unit: unit ?? this.unit,
    system: system ?? this.system,
    code: code ?? this.code,
    extraJson: _extraJson,
  );

  @override
  String toString() => 'Quantity(value: $value, unit: $unit)';

  @override
  bool operator ==(Object other) =>
      other is Quantity &&
      other._value == _value &&
      other.comparator == comparator &&
      other.unit == unit &&
      other.system == system &&
      other.code == code &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    _value,
    comparator,
    unit,
    system,
    code,
    deepHash(_extraJson),
  );
}

/// A FHIR extension: a URL plus at most one `value[x]`.
///
/// The `value[x]` variants this package reads are typed; any other variant is
/// preserved in the extra JSON and written back untouched.
///
/// See https://hl7.org/fhir/R4/extensibility.html
class FhirExtension {
  const FhirExtension({
    required this.url,
    this.valueString,
    this.valueBoolean,
    this.valueInteger,
    this.valueCode,
    this.valueUri,
    this.valueCoding,
    this.valueCodeableConcept,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses an `Extension` from FHIR JSON.
  factory FhirExtension.fromJson(Map<String, dynamic> json) {
    final coding = asJsonObject(json['valueCoding']);
    final concept = asJsonObject(json['valueCodeableConcept']);
    return FhirExtension(
      url: asString(json['url']) ?? '',
      valueString: asString(json['valueString']),
      valueBoolean: asBool(json['valueBoolean']),
      valueInteger: asInt(json['valueInteger']),
      valueCode: asString(json['valueCode']),
      valueUri: asString(json['valueUri']),
      valueCoding: coding == null ? null : Coding.fromJson(coding),
      valueCodeableConcept:
          concept == null ? null : CodeableConcept.fromJson(concept),
      extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'url',
    'valueString',
    'valueBoolean',
    'valueInteger',
    'valueCode',
    'valueUri',
    'valueCoding',
    'valueCodeableConcept',
    'extension',
  };

  /// Identifies the meaning of the extension.
  final String url;

  final String? valueString;
  final bool? valueBoolean;
  final int? valueInteger;
  final String? valueCode;
  final String? valueUri;
  final Coding? valueCoding;
  final CodeableConcept? valueCodeableConcept;

  /// Nested extensions, used by complex extensions that have no value.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled `value[x]` variants.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['url'] = url;
    putIfNotNull(json, 'valueString', valueString);
    putIfNotNull(json, 'valueBoolean', valueBoolean);
    putIfNotNull(json, 'valueInteger', valueInteger);
    putIfNotNull(json, 'valueCode', valueCode);
    putIfNotNull(json, 'valueUri', valueUri);
    putIfNotNull(json, 'valueCoding', valueCoding?.toJson());
    putIfNotNull(json, 'valueCodeableConcept', valueCodeableConcept?.toJson());
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  @override
  String toString() => 'FhirExtension(url: $url)';

  @override
  bool operator ==(Object other) =>
      other is FhirExtension &&
      other.url == url &&
      other.valueString == valueString &&
      other.valueBoolean == valueBoolean &&
      other.valueInteger == valueInteger &&
      other.valueCode == valueCode &&
      other.valueUri == valueUri &&
      other.valueCoding == valueCoding &&
      other.valueCodeableConcept == valueCodeableConcept &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    url,
    valueString,
    valueBoolean,
    valueInteger,
    valueCode,
    valueUri,
    valueCoding,
    valueCodeableConcept,
    listHash(extension_),
    deepHash(_extraJson),
  );
}
