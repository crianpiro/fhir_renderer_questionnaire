/// The FHIR R4 `Questionnaire` resource, modelled for rendering.
library;

import 'fhir_data_types.dart';
import 'fhir_primitives.dart';
import 'json_support.dart';
import 'questionnaire_enums.dart';

/// A structured set of questions.
///
/// Build one from FHIR JSON:
///
/// ```dart
/// final questionnaire = Questionnaire.fromJson(jsonDecode(source));
/// ```
///
/// Fields this package does not render are still preserved: they are carried
/// through untouched and re-emitted by [toJson].
///
/// See https://hl7.org/fhir/R4/questionnaire.html
class Questionnaire {
  const Questionnaire({
    this.id,
    this.url,
    this.version,
    this.name,
    this.title,
    this.status,
    this.date,
    this.publisher,
    this.description,
    this.item,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `Questionnaire` from FHIR JSON.
  ///
  /// Unknown item types and codes degrade rather than throw, so a questionnaire
  /// from a newer or slightly non-conformant source still renders.
  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    final date = asString(json['date']);
    return Questionnaire(
      id: asString(json['id']),
      url: asString(json['url']),
      version: asString(json['version']),
      name: asString(json['name']),
      title: asString(json['title']),
      status: QuestionnairePublicationStatus.fromCode(asString(json['status'])),
      date: date == null ? null : FhirDateTime(date),
      publisher: asString(json['publisher']),
      description: asString(json['description']),
      item: parseObjectList(json['item'], QuestionnaireItem.fromJson),
      extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'resourceType',
    'id',
    'url',
    'version',
    'name',
    'title',
    'status',
    'date',
    'publisher',
    'description',
    'item',
    'extension',
  };

  /// Logical id of the resource.
  final String? id;

  /// Canonical identifier for this questionnaire.
  final String? url;

  /// Business version of the questionnaire.
  final String? version;

  /// Computer-friendly name.
  final String? name;

  /// Human-friendly name, shown as the questionnaire's heading.
  final String? title;

  /// Lifecycle status.
  final QuestionnairePublicationStatus? status;

  /// Date last changed.
  final FhirDateTime? date;

  /// Name of the publisher.
  final String? publisher;

  /// Natural language description.
  final String? description;

  /// The questions and groups that make up the questionnaire.
  final List<QuestionnaireItem>? item;

  /// Extensions applying to the questionnaire as a whole.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// A reference to this questionnaire in `Questionnaire/{id}` form.
  ///
  /// Used to link a generated [QuestionnaireResponse] back to its definition.
  String get canonicalReference => 'Questionnaire/$id';

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['resourceType'] = 'Questionnaire';
    putIfNotNull(json, 'id', id);
    putIfNotNull(json, 'url', url);
    putIfNotNull(json, 'version', version);
    putIfNotNull(json, 'name', name);
    putIfNotNull(json, 'title', title);
    putIfNotNull(json, 'status', status?.code);
    putIfNotNull(json, 'date', date?.value);
    putIfNotNull(json, 'publisher', publisher);
    putIfNotNull(json, 'description', description);
    putIfNotNull(json, 'item', encodeObjectList(item, (i) => i.toJson()));
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  Questionnaire copyWith({
    String? id,
    String? url,
    String? version,
    String? name,
    String? title,
    QuestionnairePublicationStatus? status,
    FhirDateTime? date,
    String? publisher,
    String? description,
    List<QuestionnaireItem>? item,
    List<FhirExtension>? extension_,
  }) => Questionnaire(
    id: id ?? this.id,
    url: url ?? this.url,
    version: version ?? this.version,
    name: name ?? this.name,
    title: title ?? this.title,
    status: status ?? this.status,
    date: date ?? this.date,
    publisher: publisher ?? this.publisher,
    description: description ?? this.description,
    item: item ?? this.item,
    extension_: extension_ ?? this.extension_,
    extraJson: _extraJson,
  );

  @override
  String toString() => 'Questionnaire(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      other is Questionnaire &&
      other.id == id &&
      other.url == url &&
      other.version == version &&
      other.name == name &&
      other.title == title &&
      other.status == status &&
      other.date == date &&
      other.publisher == publisher &&
      other.description == description &&
      listEquals(other.item, item) &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    id,
    url,
    version,
    name,
    title,
    status,
    date,
    publisher,
    description,
    listHash(item),
    listHash(extension_),
    deepHash(_extraJson),
  );
}

/// A single question, display item or group within a [Questionnaire].
///
/// See https://hl7.org/fhir/R4/questionnaire-definitions.html#Questionnaire.item
class QuestionnaireItem {
  const QuestionnaireItem({
    this.linkId = '',
    this.definition,
    this.code,
    this.prefix,
    this.text,
    this.type = QuestionnaireItemType.display_,
    this.enableWhen,
    this.enableBehavior,
    this.required_,
    this.repeats,
    this.readOnly,
    this.maxLength,
    this.answerValueSet,
    this.answerOption,
    this.initial,
    this.item,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `Questionnaire.item` from FHIR JSON.
  ///
  /// An absent or unrecognized `type` falls back to
  /// [QuestionnaireItemType.display_], which renders the item's text without
  /// asking for an answer - a safe degradation for a required field this
  /// package cannot guess.
  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) =>
      QuestionnaireItem(
        linkId: asString(json['linkId']) ?? '',
        definition: asString(json['definition']),
        code: parseObjectList(json['code'], Coding.fromJson),
        prefix: asString(json['prefix']),
        text: asString(json['text']),
        type:
            QuestionnaireItemType.fromCode(asString(json['type'])) ??
            QuestionnaireItemType.display_,
        enableWhen: parseObjectList(
          json['enableWhen'],
          QuestionnaireEnableWhen.fromJson,
        ),
        enableBehavior: QuestionnaireEnableBehavior.fromCode(
          asString(json['enableBehavior']),
        ),
        required_: asBool(json['required']),
        repeats: asBool(json['repeats']),
        readOnly: asBool(json['readOnly']),
        maxLength: asInt(json['maxLength']),
        answerValueSet: asString(json['answerValueSet']),
        answerOption: parseObjectList(
          json['answerOption'],
          QuestionnaireAnswerOption.fromJson,
        ),
        initial: parseObjectList(
          json['initial'],
          QuestionnaireInitial.fromJson,
        ),
        item: parseObjectList(json['item'], QuestionnaireItem.fromJson),
        extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
        extraJson: extraJsonFrom(json, _modelledKeys),
      );

  static const Set<String> _modelledKeys = {
    'linkId',
    'definition',
    'code',
    'prefix',
    'text',
    'type',
    'enableWhen',
    'enableBehavior',
    'required',
    'repeats',
    'readOnly',
    'maxLength',
    'answerValueSet',
    'answerOption',
    'initial',
    'item',
    'extension',
  };

  /// Unique id for this item within the questionnaire.
  final String linkId;

  /// ElementDefinition this item maps to.
  final String? definition;

  /// Codes designating this question.
  final List<Coding>? code;

  /// Label such as a section number, shown before the text.
  final String? prefix;

  /// Primary text for the item.
  final String? text;

  /// The kind of answer this item collects.
  final QuestionnaireItemType type;

  /// Conditions controlling whether this item is shown.
  final List<QuestionnaireEnableWhen>? enableWhen;

  /// How multiple [enableWhen] conditions combine. Defaults to
  /// [QuestionnaireEnableBehavior.any] when absent.
  final QuestionnaireEnableBehavior? enableBehavior;

  /// Whether the item must be answered. Named with a trailing underscore
  /// because `required` is a Dart keyword.
  final bool? required_;

  /// Whether the item may be answered more than once.
  final bool? repeats;

  /// Whether the item is shown but not editable.
  final bool? readOnly;

  /// Maximum length for a string answer.
  final int? maxLength;

  /// Canonical URL of a value set holding the permitted answers.
  final String? answerValueSet;

  /// Permitted answers, given inline.
  final List<QuestionnaireAnswerOption>? answerOption;

  /// Initial value(s) when the questionnaire is first rendered.
  final List<QuestionnaireInitial>? initial;

  /// Nested items.
  final List<QuestionnaireItem>? item;

  /// Extensions applying to this item, including the SDC extensions this
  /// package understands.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['linkId'] = linkId;
    putIfNotNull(json, 'definition', definition);
    putIfNotNull(json, 'code', encodeObjectList(code, (c) => c.toJson()));
    putIfNotNull(json, 'prefix', prefix);
    putIfNotNull(json, 'text', text);
    json['type'] = type.code;
    putIfNotNull(
      json,
      'enableWhen',
      encodeObjectList(enableWhen, (e) => e.toJson()),
    );
    putIfNotNull(json, 'enableBehavior', enableBehavior?.code);
    putIfNotNull(json, 'required', required_);
    putIfNotNull(json, 'repeats', repeats);
    putIfNotNull(json, 'readOnly', readOnly);
    putIfNotNull(json, 'maxLength', maxLength);
    putIfNotNull(json, 'answerValueSet', answerValueSet);
    putIfNotNull(
      json,
      'answerOption',
      encodeObjectList(answerOption, (o) => o.toJson()),
    );
    putIfNotNull(json, 'initial', encodeObjectList(initial, (i) => i.toJson()));
    putIfNotNull(json, 'item', encodeObjectList(item, (i) => i.toJson()));
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  QuestionnaireItem copyWith({
    String? linkId,
    String? definition,
    List<Coding>? code,
    String? prefix,
    String? text,
    QuestionnaireItemType? type,
    List<QuestionnaireEnableWhen>? enableWhen,
    QuestionnaireEnableBehavior? enableBehavior,
    bool? required_,
    bool? repeats,
    bool? readOnly,
    int? maxLength,
    String? answerValueSet,
    List<QuestionnaireAnswerOption>? answerOption,
    List<QuestionnaireInitial>? initial,
    List<QuestionnaireItem>? item,
    List<FhirExtension>? extension_,
  }) => QuestionnaireItem(
    linkId: linkId ?? this.linkId,
    definition: definition ?? this.definition,
    code: code ?? this.code,
    prefix: prefix ?? this.prefix,
    text: text ?? this.text,
    type: type ?? this.type,
    enableWhen: enableWhen ?? this.enableWhen,
    enableBehavior: enableBehavior ?? this.enableBehavior,
    required_: required_ ?? this.required_,
    repeats: repeats ?? this.repeats,
    readOnly: readOnly ?? this.readOnly,
    maxLength: maxLength ?? this.maxLength,
    answerValueSet: answerValueSet ?? this.answerValueSet,
    answerOption: answerOption ?? this.answerOption,
    initial: initial ?? this.initial,
    item: item ?? this.item,
    extension_: extension_ ?? this.extension_,
    extraJson: _extraJson,
  );

  @override
  String toString() =>
      'QuestionnaireItem(linkId: $linkId, type: ${type.code}, text: $text)';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireItem &&
      other.linkId == linkId &&
      other.definition == definition &&
      listEquals(other.code, code) &&
      other.prefix == prefix &&
      other.text == text &&
      other.type == type &&
      listEquals(other.enableWhen, enableWhen) &&
      other.enableBehavior == enableBehavior &&
      other.required_ == required_ &&
      other.repeats == repeats &&
      other.readOnly == readOnly &&
      other.maxLength == maxLength &&
      other.answerValueSet == answerValueSet &&
      listEquals(other.answerOption, answerOption) &&
      listEquals(other.initial, initial) &&
      listEquals(other.item, item) &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hashAll([
    linkId,
    definition,
    listHash(code),
    prefix,
    text,
    type,
    listHash(enableWhen),
    enableBehavior,
    required_,
    repeats,
    readOnly,
    maxLength,
    answerValueSet,
    listHash(answerOption),
    listHash(initial),
    listHash(item),
    listHash(extension_),
    deepHash(_extraJson),
  ]);
}

/// A condition that decides whether its owning item is shown.
///
/// See https://hl7.org/fhir/R4/questionnaire-definitions.html#Questionnaire.item.enableWhen
class QuestionnaireEnableWhen {
  QuestionnaireEnableWhen({
    this.question = '',
    this.operator_,
    this.answerBoolean,
    double? answerDecimal,
    this.answerInteger,
    this.answerDate,
    this.answerDateTime,
    this.answerTime,
    this.answerString,
    this.answerCoding,
    this.answerQuantity,
    this.answerReference,
    Map<String, dynamic> extraJson = const {},
  }) : _answerDecimal =
           answerDecimal == null ? null : DecimalValue.fromDouble(answerDecimal),
       _extraJson = extraJson;

  QuestionnaireEnableWhen._({
    required this.question,
    this.operator_,
    this.answerBoolean,
    DecimalValue? answerDecimal,
    this.answerInteger,
    this.answerDate,
    this.answerDateTime,
    this.answerTime,
    this.answerString,
    this.answerCoding,
    this.answerQuantity,
    this.answerReference,
    Map<String, dynamic> extraJson = const {},
  }) : _answerDecimal = answerDecimal,
       _extraJson = extraJson;

  /// Parses a `Questionnaire.item.enableWhen` from FHIR JSON.
  factory QuestionnaireEnableWhen.fromJson(Map<String, dynamic> json) {
    final date = asString(json['answerDate']);
    final dateTime = asString(json['answerDateTime']);
    final time = asString(json['answerTime']);
    final coding = asJsonObject(json['answerCoding']);
    final quantity = asJsonObject(json['answerQuantity']);
    final reference = asJsonObject(json['answerReference']);
    return QuestionnaireEnableWhen._(
      question: asString(json['question']) ?? '',
      operator_: QuestionnaireItemOperator.fromCode(asString(json['operator'])),
      answerBoolean: asBool(json['answerBoolean']),
      answerDecimal: DecimalValue.fromJson(json['answerDecimal']),
      answerInteger: asInt(json['answerInteger']),
      answerDate: date == null ? null : FhirDate(date),
      answerDateTime: dateTime == null ? null : FhirDateTime(dateTime),
      answerTime: time == null ? null : FhirTime(time),
      answerString: asString(json['answerString']),
      answerCoding: coding == null ? null : Coding.fromJson(coding),
      answerQuantity: quantity == null ? null : Quantity.fromJson(quantity),
      answerReference:
          reference == null ? null : Reference.fromJson(reference),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'question',
    'operator',
    'answerBoolean',
    'answerDecimal',
    'answerInteger',
    'answerDate',
    'answerDateTime',
    'answerTime',
    'answerString',
    'answerCoding',
    'answerQuantity',
    'answerReference',
  };

  /// The `linkId` of the item whose answer is being tested.
  final String question;

  /// The comparison to apply. Named with a trailing underscore because
  /// `operator` is a Dart keyword.
  final QuestionnaireItemOperator? operator_;

  final bool? answerBoolean;
  final DecimalValue? _answerDecimal;
  final int? answerInteger;
  final FhirDate? answerDate;
  final FhirDateTime? answerDateTime;
  final FhirTime? answerTime;
  final String? answerString;
  final Coding? answerCoding;
  final Quantity? answerQuantity;
  final Reference? answerReference;

  /// The decimal the condition compares against.
  double? get answerDecimal => _answerDecimal?.asDouble;

  final Map<String, dynamic> _extraJson;

  /// Whichever `answer[x]` variant is set, or `null` when none is.
  Object? get answer =>
      answerBoolean ??
      answerDecimal ??
      answerInteger ??
      answerDate ??
      answerDateTime ??
      answerTime ??
      answerString ??
      answerCoding ??
      answerQuantity ??
      answerReference;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    json['question'] = question;
    putIfNotNull(json, 'operator', operator_?.code);
    putIfNotNull(json, 'answerBoolean', answerBoolean);
    putIfNotNull(json, 'answerDecimal', _answerDecimal?.toJson());
    putIfNotNull(json, 'answerInteger', answerInteger);
    putIfNotNull(json, 'answerDate', answerDate?.value);
    putIfNotNull(json, 'answerDateTime', answerDateTime?.value);
    putIfNotNull(json, 'answerTime', answerTime?.value);
    putIfNotNull(json, 'answerString', answerString);
    putIfNotNull(json, 'answerCoding', answerCoding?.toJson());
    putIfNotNull(json, 'answerQuantity', answerQuantity?.toJson());
    putIfNotNull(json, 'answerReference', answerReference?.toJson());
    return json;
  }

  @override
  String toString() =>
      'QuestionnaireEnableWhen(question: $question, '
      'operator: ${operator_?.code}, answer: $answer)';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireEnableWhen &&
      other.question == question &&
      other.operator_ == operator_ &&
      other.answerBoolean == answerBoolean &&
      other._answerDecimal == _answerDecimal &&
      other.answerInteger == answerInteger &&
      other.answerDate == answerDate &&
      other.answerDateTime == answerDateTime &&
      other.answerTime == answerTime &&
      other.answerString == answerString &&
      other.answerCoding == answerCoding &&
      other.answerQuantity == answerQuantity &&
      other.answerReference == answerReference &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hashAll([
    question,
    operator_,
    answerBoolean,
    _answerDecimal,
    answerInteger,
    answerDate,
    answerDateTime,
    answerTime,
    answerString,
    answerCoding,
    answerQuantity,
    answerReference,
    deepHash(_extraJson),
  ]);
}

/// One of the permitted answers to a choice-style item.
///
/// See https://hl7.org/fhir/R4/questionnaire-definitions.html#Questionnaire.item.answerOption
class QuestionnaireAnswerOption {
  const QuestionnaireAnswerOption({
    this.valueInteger,
    this.valueDate,
    this.valueTime,
    this.valueString,
    this.valueCoding,
    this.valueReference,
    this.initialSelected,
    this.extension_,
    Map<String, dynamic> extraJson = const {},
  }) : _extraJson = extraJson;

  /// Parses a `Questionnaire.item.answerOption` from FHIR JSON.
  factory QuestionnaireAnswerOption.fromJson(Map<String, dynamic> json) {
    final date = asString(json['valueDate']);
    final time = asString(json['valueTime']);
    final coding = asJsonObject(json['valueCoding']);
    final reference = asJsonObject(json['valueReference']);
    return QuestionnaireAnswerOption(
      valueInteger: asInt(json['valueInteger']),
      valueDate: date == null ? null : FhirDate(date),
      valueTime: time == null ? null : FhirTime(time),
      valueString: asString(json['valueString']),
      valueCoding: coding == null ? null : Coding.fromJson(coding),
      valueReference: reference == null ? null : Reference.fromJson(reference),
      initialSelected: asBool(json['initialSelected']),
      extension_: parseObjectList(json['extension'], FhirExtension.fromJson),
      extraJson: extraJsonFrom(json, _modelledKeys),
    );
  }

  static const Set<String> _modelledKeys = {
    'valueInteger',
    'valueDate',
    'valueTime',
    'valueString',
    'valueCoding',
    'valueReference',
    'initialSelected',
    'extension',
  };

  final int? valueInteger;
  final FhirDate? valueDate;
  final FhirTime? valueTime;
  final String? valueString;
  final Coding? valueCoding;
  final Reference? valueReference;

  /// Whether this option is selected when the questionnaire first renders.
  final bool? initialSelected;

  /// Extensions on this option, including `questionnaire-optionExclusive`.
  final List<FhirExtension>? extension_;

  final Map<String, dynamic> _extraJson;

  /// Whichever `value[x]` variant is set, or `null` when none is.
  Object? get value =>
      valueInteger ??
      valueDate ??
      valueTime ??
      valueString ??
      valueCoding ??
      valueReference;

  /// Serializes back to FHIR JSON, including unmodelled fields.
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>.from(_extraJson);
    putIfNotNull(json, 'valueInteger', valueInteger);
    putIfNotNull(json, 'valueDate', valueDate?.value);
    putIfNotNull(json, 'valueTime', valueTime?.value);
    putIfNotNull(json, 'valueString', valueString);
    putIfNotNull(json, 'valueCoding', valueCoding?.toJson());
    putIfNotNull(json, 'valueReference', valueReference?.toJson());
    putIfNotNull(json, 'initialSelected', initialSelected);
    putIfNotNull(
      json,
      'extension',
      encodeObjectList(extension_, (e) => e.toJson()),
    );
    return json;
  }

  @override
  String toString() => 'QuestionnaireAnswerOption(value: $value)';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireAnswerOption &&
      other.valueInteger == valueInteger &&
      other.valueDate == valueDate &&
      other.valueTime == valueTime &&
      other.valueString == valueString &&
      other.valueCoding == valueCoding &&
      other.valueReference == valueReference &&
      other.initialSelected == initialSelected &&
      listEquals(other.extension_, extension_) &&
      deepEquals(other._extraJson, _extraJson);

  @override
  int get hashCode => Object.hash(
    valueInteger,
    valueDate,
    valueTime,
    valueString,
    valueCoding,
    valueReference,
    initialSelected,
    listHash(extension_),
    deepHash(_extraJson),
  );
}

/// An initial value for an item, applied when the questionnaire first renders.
///
/// See https://hl7.org/fhir/R4/questionnaire-definitions.html#Questionnaire.item.initial
class QuestionnaireInitial {
  QuestionnaireInitial({
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
    Map<String, dynamic> extraJson = const {},
  }) : _valueDecimal =
           valueDecimal == null ? null : DecimalValue.fromDouble(valueDecimal),
       _extraJson = extraJson;

  QuestionnaireInitial._({
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
    Map<String, dynamic> extraJson = const {},
  }) : _valueDecimal = valueDecimal,
       _extraJson = extraJson;

  /// Parses a `Questionnaire.item.initial` from FHIR JSON.
  factory QuestionnaireInitial.fromJson(Map<String, dynamic> json) {
    final date = asString(json['valueDate']);
    final dateTime = asString(json['valueDateTime']);
    final time = asString(json['valueTime']);
    final attachment = asJsonObject(json['valueAttachment']);
    final coding = asJsonObject(json['valueCoding']);
    final quantity = asJsonObject(json['valueQuantity']);
    final reference = asJsonObject(json['valueReference']);
    return QuestionnaireInitial._(
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

  /// The initial decimal value.
  double? get valueDecimal => _valueDecimal?.asDouble;

  final Map<String, dynamic> _extraJson;

  /// Whichever `value[x]` variant is set, or `null` when none is.
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
    return json;
  }

  @override
  String toString() => 'QuestionnaireInitial(value: $value)';

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireInitial &&
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
    deepHash(_extraJson),
  ]);
}
