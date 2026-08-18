/// The FHIR R4 `QuestionnaireResponse` resource, modelled for rendering.
library;

import 'fhir_data_types.dart';
import 'fhir_primitives.dart';
import 'json_support.dart';
import 'questionnaire_enums.dart';

/// A set of answers to a `Questionnaire`.
///
/// This is what the renderers produce. Serialize it with [toJson] to send it to
/// a FHIR server.
///
/// See https://hl7.org/fhir/R4/questionnaireresponse.html
class QuestionnaireResponse {
  const QuestionnaireResponse({
    this.id,
    this.questionnaire,
    this.status,
    this.subject,
    this.authored,
    this.author,
    this.item,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `QuestionnaireResponse` from FHIR JSON.
  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    final authored = asString(json['authored']);
    final subject = asJsonObject(json['subject']);
    final author = asJsonObject(json['author']);
    return QuestionnaireResponse(
      id: asString(json['id']),
      questionnaire: asString(json['questionnaire']),
      status: QuestionnaireResponseStatus.fromCode(asString(json['status'])),
      subject: subject == null ? null : Reference.fromJson(subject),
      authored: authored == null ? null : FhirDateTime(authored),
      author: author == null ? null : Reference.fromJson(author),
      item: parseObjectList(
        json['item'],
        QuestionnaireResponseItem.fromJson,
      ),
      extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'resourceType',
    'id',
    'questionnaire',
    'status',
    'subject',
    'authored',
    'author',
    'item',
    'extension',
  };

  /// Logical id of the resource.
  final String? id;

  /// Canonical reference to the questionnaire being answered.
  final String? questionnaire;

  /// Lifecycle status of the response.
  final QuestionnaireResponseStatus? status;

  /// The subject the answers are about.
  final Reference? subject;

  /// When the answers were last changed.
  final FhirDateTime? authored;

  /// Who recorded the answers.
  final Reference? author;

  /// The answered items.
  final List<QuestionnaireResponseItem>? item;

  /// Extensions applying to the response as a whole.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['resourceType'] = 'QuestionnaireResponse';
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'questionnaire', questionnaire);
    putIfNotNull(json, 'status', status?.code);
    putIfNotNull(json, 'subject', subject?.toJson());
    putIfNotNull(json, 'authored', authored?.value);
    putIfNotNull(json, 'author', author?.toJson());
    putIfNotNull(json, 'item', encodeObjectList(item, (i) => i.toJson()));
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  QuestionnaireResponse copyWith({
    String? id,
    String? questionnaire,
    QuestionnaireResponseStatus? status,
    Reference? subject,
    FhirDateTime? authored,
    Reference? author,
    List<QuestionnaireResponseItem>? item,
    List<FhirExtension>? extension_,
  }) => QuestionnaireResponse(
    id: id ?? this.id,
    questionnaire: questionnaire ?? this.questionnaire,
    status: status ?? this.status,
    subject: subject ?? this.subject,
    authored: authored ?? this.authored,
    author: author ?? this.author,
    item: item ?? this.item,
    extension_: extension_ ?? this.extension_,
    extraJson: _extraJson,
  );

  @override
  String toString() =>
      'QuestionnaireResponse(questionnaire: $questionnaire, '
      'status: ${status?.code})';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireResponse &&
      other.id == id &&
      other.questionnaire == questionnaire &&
      other.status == status &&
      other.subject == subject &&
      other.authored == authored &&
      other.author == author &&
      listEquals(other.item, item) &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    id,
    questionnaire,
    status,
    subject,
    authored,
    author,
    listHash(item),
    listHash(extension_),
    deepHash(_extraJson),
  );
}

/// A single answered item within a [QuestionnaireResponse].
///
/// See https://hl7.org/fhir/R4/questionnaireresponse-definitions.html#QuestionnaireResponse.item
class QuestionnaireResponseItem {
  const QuestionnaireResponseItem({
    this.linkId = '',
    this.definition,
    this.text,
    this.answer,
    this.item,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `QuestionnaireResponse.item` from FHIR JSON.
  factory QuestionnaireResponseItem.fromJson(Map<String, dynamic> json) =>
      QuestionnaireResponseItem(
        linkId: asString(json['linkId']) ?? '',
        definition: asString(json['definition']),
        text: asString(json['text']),
        answer: parseObjectList(
          json['answer'],
          QuestionnaireResponseAnswer.fromJson,
        ),
        item: parseObjectList(
          json['item'],
          QuestionnaireResponseItem.fromJson,
        ),
        extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
        extraJson: extraJsonFrom(json, _modelledKeys),
      );

  static const Set<String> _modelledKeys = {
    'linkId',
    'definition',
    'text',
    'answer',
    'item',
    'extension',
  };

  /// The `linkId` of the questionnaire item this answers.
  final String linkId;

  /// ElementDefinition the item maps to.
  final String? definition;

  /// The question text, copied from the questionnaire.
  final String? text;

  /// The answers given. A repeating item may have more than one.
  final List<QuestionnaireResponseAnswer>? answer;

  /// Nested items.
  final List<QuestionnaireResponseItem>? item;

  /// Extensions applying to this item.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['linkId'] = linkId;
    putIfNotNull(json, 'definition', definition);
    putIfNotNull(json, 'text', text);
    putIfNotNull(json, 'answer', encodeObjectList(answer, (a) => a.toJson()));
    putIfNotNull(json, 'item', encodeObjectList(item, (i) => i.toJson()));
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  QuestionnaireResponseItem copyWith({
    String? linkId,
    String? definition,
    String? text,
    List<QuestionnaireResponseAnswer>? answer,
    List<QuestionnaireResponseItem>? item,
    List<FhirExtension>? extension_,
  }) => QuestionnaireResponseItem(
    linkId: linkId ?? this.linkId,
    definition: definition ?? this.definition,
    text: text ?? this.text,
    answer: answer ?? this.answer,
    item: item ?? this.item,
    extension_: extension_ ?? this.extension_,
    extraJson: _extraJson,
  );

  @override
  String toString() =>
      'QuestionnaireResponseItem(linkId: $linkId, answers: ${answer?.length})';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireResponseItem &&
      other.linkId == linkId &&
      other.definition == definition &&
      other.text == text &&
      listEquals(other.answer, answer) &&
      listEquals(other.item, item) &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    linkId,
    definition,
    text,
    listHash(answer),
    listHash(item),
    listHash(extension_),
    deepHash(_extraJson),
  );
}

/// A single answer to a questionnaire item.
///
/// Exactly one `value[x]` should be set. [value] returns whichever it is.
///
/// See https://hl7.org/fhir/R4/questionnaireresponse-definitions.html#QuestionnaireResponse.item.answer
class QuestionnaireResponseAnswer {
  QuestionnaireResponseAnswer({
    this.valueBoolean,
    double? valueDecimal,
    this.valueInteger,
    this.valueDate,
    this.valueDateTime,
    this.valueTime,
    this.valueString,
    this.valueUri,
    this.valueAttachment,
    this.valueCoding,
    this.valueQuantity,
    this.valueReference,
    this.item,
    Map<String, dynamic> extraJson = const {},
  }) : _valueDecimal =
           valueDecimal == null ? null : DecimalValue.fromDouble(valueDecimal),
       _extraJson = extraJson;

  QuestionnaireResponseAnswer._({
    this.valueBoolean,
    DecimalValue? valueDecimal,
    this.valueInteger,
    this.valueDate,
    this.valueDateTime,
    this.valueTime,
    this.valueString,
    this.valueUri,
    this.valueAttachment,
    this.valueCoding,
    this.valueQuantity,
    this.valueReference,
    this.item,
    Map<String, dynamic> extraJson = const {},
  }) : _valueDecimal = valueDecimal,
       _extraJson = extraJson;

  /// Parses a `QuestionnaireResponse.item.answer` from FHIR JSON.
  factory QuestionnaireResponseAnswer.fromJson(Map<String, dynamic> json) {
    final date = asString(json['valueDate']);
    final dateTime = asString(json['valueDateTime']);
    final time = asString(json['valueTime']);
    final attachment = asJsonObject(json['valueAttachment']);
    final coding = asJsonObject(json['valueCoding']);
    final quantity = asJsonObject(json['valueQuantity']);
    final reference = asJsonObject(json['valueReference']);
    return QuestionnaireResponseAnswer._(
      valueBoolean: asBool(json['valueBoolean']),
      valueDecimal: DecimalValue.fromJson(json['valueDecimal']),
      valueInteger: asInt(json['valueInteger']),
      valueDate: date == null ? null : FhirDate(date),
      valueDateTime: dateTime == null ? null : FhirDateTime(dateTime),
      valueTime: time == null ? null : FhirTime(time),
      valueString: asString(json['valueString']),
      valueUri: asString(json['valueUri']),
      valueAttachment:
          attachment == null ? null : Attachment.fromJson(attachment),
      valueCoding: coding == null ? null : Coding.fromJson(coding),
      valueQuantity: quantity == null ? null : Quantity.fromJson(quantity),
      valueReference: reference == null ? null : Reference.fromJson(reference),
      item: parseObjectList(
        json['item'],
        QuestionnaireResponseItem.fromJson,
      ),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'valueBoolean',
    'valueDecimal',
    'valueInteger',
    'valueDate',
    'valueDateTime',
    'valueTime',
    'valueString',
    'valueUri',
    'valueAttachment',
    'valueCoding',
    'valueQuantity',
    'valueReference',
    'item',
  };

  final bool? valueBoolean;
  final DecimalValue? _valueDecimal;
  final int? valueInteger;
  final FhirDate? valueDate;
  final FhirDateTime? valueDateTime;
  final FhirTime? valueTime;
  final String? valueString;
  final String? valueUri;
  final Attachment? valueAttachment;
  final Coding? valueCoding;
  final Quantity? valueQuantity;
  final Reference? valueReference;

  /// Nested items, for answers that themselves contain sub-questions.
  final List<QuestionnaireResponseItem>? item;

  /// The answer's decimal value.
  double? get valueDecimal => _valueDecimal?.asDouble;

  final Map<String, dynamic> _extraJson;

  /// Whichever `value[x]` variant is set, or `null` when none is.
  ///
  /// Use this to compare answers without caring which variant holds the value.
  Object? get value =>
      valueBoolean ??
      valueDecimal ??
      valueInteger ??
      valueDate ??
      valueDateTime ??
      valueTime ??
      valueString ??
      valueUri ??
      valueAttachment ??
      valueCoding ??
      valueQuantity ??
      valueReference;

  /// Whether no `value[x]` is set at all.
  bool get isEmpty => value == null;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'valueBoolean', valueBoolean);
    putIfNotNull(json, 'valueDecimal', _valueDecimal?.toJson());
    putIfNotNull(json, 'valueInteger', valueInteger);
    putIfNotNull(json, 'valueDate', valueDate?.value);
    putIfNotNull(json, 'valueDateTime', valueDateTime?.value);
    putIfNotNull(json, 'valueTime', valueTime?.value);
    putIfNotNull(json, 'valueString', valueString);
    putIfNotNull(json, 'valueUri', valueUri);
    putIfNotNull(json, 'valueAttachment', valueAttachment?.toJson());
    putIfNotNull(json, 'valueCoding', valueCoding?.toJson());
    putIfNotNull(json, 'valueQuantity', valueQuantity?.toJson());
    putIfNotNull(json, 'valueReference', valueReference?.toJson());
    putIfNotNull(json, 'item', encodeObjectList(item, (i) => i.toJson()));
    return json;
  }

  @override
  String toString() => 'QuestionnaireResponseAnswer(value: $value)';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireResponseAnswer &&
      other.valueBoolean == valueBoolean &&
      other._valueDecimal == _valueDecimal &&
      other.valueInteger == valueInteger &&
      other.valueDate == valueDate &&
      other.valueDateTime == valueDateTime &&
      other.valueTime == valueTime &&
      other.valueString == valueString &&
      other.valueUri == valueUri &&
      other.valueAttachment == valueAttachment &&
      other.valueCoding == valueCoding &&
      other.valueQuantity == valueQuantity &&
      other.valueReference == valueReference &&
      listEquals(other.item, item) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hashAll([
    valueBoolean,
    _valueDecimal,
    valueInteger,
    valueDate,
    valueDateTime,
    valueTime,
    valueString,
    valueUri,
    valueAttachment,
    valueCoding,
    valueQuantity,
    valueReference,
    listHash(item),
    deepHash(_extraJson),
  ]);
}
