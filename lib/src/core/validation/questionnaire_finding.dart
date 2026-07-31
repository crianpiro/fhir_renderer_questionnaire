/// Why a questionnaire item failed verification.
enum QuestionnaireFindingReason {
  /// The item is `required` and has no answer.
  missingRequired,

  /// The item has an answer that does not match its validation pattern.
  invalidFormat,
}

/// A single problem found by verifying a questionnaire response.
///
/// Findings are produced from the questionnaire and response alone, so items
/// that have never been rendered are reported just like visible ones. The
/// position fields let a renderer reveal an item that is not currently built.
final class QuestionnaireFinding {
  /// `linkId` of the offending item.
  final String linkId;

  /// The item's display text, for host-built summaries.
  final String text;

  /// What is wrong with the item.
  final QuestionnaireFindingReason reason;

  /// Validation message for [QuestionnaireFindingReason.invalidFormat].
  final String? message;

  /// Position of the item among all enabled items, in document order.
  ///
  /// Used to estimate a scroll offset for items that are not built yet.
  final int documentOrder;

  /// Total number of enabled items, the denominator for [documentOrder].
  final int documentLength;

  /// Index of the enclosing top-level item, i.e. the page that shows this item
  /// in `QuestionnairePageViewRenderer`.
  final int topLevelIndex;

  const QuestionnaireFinding({
    required this.linkId,
    required this.text,
    required this.reason,
    required this.documentOrder,
    required this.documentLength,
    required this.topLevelIndex,
    this.message,
  });

  /// Fraction of the way through the questionnaire this item sits, in `[0, 1]`.
  double get documentFraction =>
      documentLength > 1 ? documentOrder / (documentLength - 1) : 0.0;

  @override
  String toString() =>
      'QuestionnaireFinding($linkId, ${reason.name}${message == null ? '' : ', $message'})';
}
