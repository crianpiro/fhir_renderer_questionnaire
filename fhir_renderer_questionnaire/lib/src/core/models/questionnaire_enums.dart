/// FHIR R4 code enumerations used by Questionnaire and QuestionnaireResponse.
///
/// Each enum maps to the wire codes defined by the specification. Parsing is
/// tolerant: an unrecognized code yields `null` rather than throwing, so a
/// questionnaire from a newer or non-conformant source still renders what it
/// can instead of failing outright.
library;

/// The type of data collected by a questionnaire item.
///
/// See https://hl7.org/fhir/R4/valueset-item-type.html
enum QuestionnaireItemType {
  /// An item with no direct answer, grouping the items beneath it.
  group('group'),

  /// Text shown to the user with no associated answer.
  display_('display'),

  /// An item that expects an answer, with the type given by an extension.
  ///
  /// Rendered as a plain text field; the only R4 item type this package does
  /// not render specially.
  question('question'),

  boolean('boolean'),
  decimal('decimal'),
  integer('integer'),
  date('date'),
  dateTime('dateTime'),
  time('time'),
  string('string'),
  text('text'),
  url('url'),
  choice('choice'),
  openChoice('open-choice'),
  attachment('attachment'),
  reference('reference'),
  quantity('quantity');

  const QuestionnaireItemType(this.code);

  /// The wire code used in FHIR JSON.
  final String code;

  /// Parses a FHIR code, returning `null` when it is unrecognized.
  static QuestionnaireItemType? fromCode(String? code) {
    if (code == null) return null;
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// The comparison applied by a questionnaire item's `enableWhen` condition.
///
/// See https://hl7.org/fhir/R4/valueset-questionnaire-enable-operator.html
enum QuestionnaireItemOperator {
  /// Whether an answer exists at all, regardless of its value.
  exists('exists'),
  eq('='),
  ne('!='),
  gt('>'),
  lt('<'),
  ge('>='),
  le('<=');

  const QuestionnaireItemOperator(this.code);

  /// The wire code used in FHIR JSON.
  final String code;

  /// Parses a FHIR code, returning `null` when it is unrecognized.
  static QuestionnaireItemOperator? fromCode(String? code) {
    if (code == null) return null;
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// How multiple `enableWhen` conditions on one item combine.
///
/// See https://hl7.org/fhir/R4/valueset-questionnaire-enable-behavior.html
enum QuestionnaireEnableBehavior {
  /// Every condition must be satisfied (AND).
  all('all'),

  /// Any one condition is enough (OR). This is the default when absent.
  any('any');

  const QuestionnaireEnableBehavior(this.code);

  /// The wire code used in FHIR JSON.
  final String code;

  /// Parses a FHIR code, returning `null` when it is unrecognized.
  static QuestionnaireEnableBehavior? fromCode(String? code) {
    if (code == null) return null;
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// Lifecycle status of a [Questionnaire] definition.
///
/// See https://hl7.org/fhir/R4/valueset-publication-status.html
enum QuestionnairePublicationStatus {
  draft('draft'),
  active('active'),
  retired('retired'),
  unknown('unknown');

  const QuestionnairePublicationStatus(this.code);

  /// The wire code used in FHIR JSON.
  final String code;

  /// Parses a FHIR code, returning `null` when it is unrecognized.
  static QuestionnairePublicationStatus? fromCode(String? code) {
    if (code == null) return null;
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// Lifecycle status of a [QuestionnaireResponse].
///
/// See https://hl7.org/fhir/R4/valueset-questionnaire-answers-status.html
enum QuestionnaireResponseStatus {
  inProgress('in-progress'),
  completed('completed'),
  amended('amended'),
  enteredInError('entered-in-error'),
  stopped('stopped');

  const QuestionnaireResponseStatus(this.code);

  /// The wire code used in FHIR JSON.
  final String code;

  /// Parses a FHIR code, returning `null` when it is unrecognized.
  static QuestionnaireResponseStatus? fromCode(String? code) {
    if (code == null) return null;
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}
