import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';

/// URLs of the FHIR extensions this package understands.
abstract final class QuestionnaireExtensionUrls {
  /// Regex an answer must match.
  static const String regex = 'http://hl7.org/fhir/StructureDefinition/regex';

  /// Hint text, reused here as the message shown when [regex] fails.
  static const String entryFormat =
      'http://hl7.org/fhir/StructureDefinition/entryFormat';

  /// Which control renders a choice item.
  static const String itemControl =
      'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl';

  /// Marks an answer option as mutually exclusive with all others.
  static const String optionExclusive =
      'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive';
}

/// Looks up extensions by URL on any element that carries them.
extension FhirExtensionListLookup on List<FhirExtension>? {
  /// The first extension with [url], or `null` when there is none.
  FhirExtension? withUrl(String url) {
    final extensions = this;
    if (extensions == null) return null;
    for (final extension in extensions) {
      if (extension.url == url) return extension;
    }
    return null;
  }
}

/// Extensions for [QuestionnaireItem] to resolve display text.
extension QuestionnaireItemDisplayExtensions on QuestionnaireItem {
  /// Title shown for the item, falling back to its first code when `text` is
  /// absent and to an empty string when neither is present.
  String get displayTitle => text ?? code?.firstOrNull?.code ?? "";
}

/// Extensions for [QuestionnaireItem] to extract validation-related extensions.
extension QuestionnaireItemValidationExtensions on QuestionnaireItem {
  /// The regex an answer must match, from the standard `regex` extension.
  ///
  /// Returns null when the item carries no such extension.
  String? get regexValidationPattern =>
      extension_.withUrl(QuestionnaireExtensionUrls.regex)?.valueString;

  /// A custom message to show when [regexValidationPattern] fails.
  ///
  /// Read from the `entryFormat` extension. Returns null to use the default
  /// message.
  String? get regexValidationErrorMessage =>
      extension_.withUrl(QuestionnaireExtensionUrls.entryFormat)?.valueString;

  /// The `questionnaire-itemControl` code, which selects how a choice item
  /// renders.
  ///
  /// Supported control codes:
  /// - `drop-down`: Dropdown/select menu
  /// - `radio-button`: Radio buttons (default for single-select choice)
  /// - `check-box`: Checkboxes (default for multi-select choice)
  /// - `autocomplete`: Searchable dropdown with type-ahead
  ///
  /// Returns null when the item carries no such extension.
  String? get itemControlCode => extension_
      .withUrl(QuestionnaireExtensionUrls.itemControl)
      ?.valueCodeableConcept
      ?.coding
      ?.firstOrNull
      ?.code;
}

/// Extensions for [QuestionnaireAnswerOption] to extract SDC behavior flags.
extension QuestionnaireAnswerOptionExtensions on QuestionnaireAnswerOption {
  /// Whether this answer option is mutually exclusive with all others.
  ///
  /// Read from the `questionnaire-optionExclusive` extension.
  ///
  /// In a multi-select (repeats) item, selecting an exclusive option clears
  /// every other selection, and selecting any non-exclusive option clears the
  /// exclusive ones. This implements the "all"/"none" master option behavior.
  ///
  /// Returns true when the extension is present and set to true, false
  /// otherwise.
  bool get isOptionExclusive =>
      extension_
          .withUrl(QuestionnaireExtensionUrls.optionExclusive)
          ?.valueBoolean ??
      false;
}
