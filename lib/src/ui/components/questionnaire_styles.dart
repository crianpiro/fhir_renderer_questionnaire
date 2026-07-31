import 'package:flutter/material.dart';

/// Shared visual constants for the default questionnaire widgets.
///
/// Centralizes the corner radius, card shadow and typography used across the
/// default item components so the rendered questionnaire reads as one
/// consistent surface and can be tuned in a single place.
abstract final class QuestionnaireStyles {
  /// Corner radius used by cards, inputs and buttons.
  static const double cornerRadius = 8.0;

  /// Full rounded corners for cards and buttons.
  static const BorderRadius cardRadius =
      BorderRadius.all(Radius.circular(cornerRadius));

  /// Horizontal margin around group cards.
  static const double cardMargin = 10.0;

  /// Soft elevation shadow for group cards.
  ///
  /// Kept within [cardMargin] horizontally and within the seam bleed clipped
  /// by the flattened list entries (blur 8 + offset 2 = 10px of maximum
  /// vertical extent).
  static List<BoxShadow> cardShadow(BuildContext context) => [
        BoxShadow(
          blurRadius: 8,
          offset: const Offset(0, 2),
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.12),
        ),
      ];

  /// Text style for group headers.
  static TextStyle? groupTitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold);

  /// Text style for question titles.
  static TextStyle? itemTitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold);

  /// Subtle primary-tinted background for group header bands.
  static Color groupHeaderBackground(BuildContext context) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

  /// Small rounded accent bar shown before group titles.
  static Widget groupAccentBar(BuildContext context) => Container(
        width: 4,
        height: 18,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
      );

  /// Accent bar plus title, shared by every group header variant.
  ///
  /// Set [ellipsize] when the header cannot grow vertically (e.g. the pinned
  /// app bar of the slivers renderer).
  static Widget groupTitleRow(
    BuildContext context, {
    required String title,
    bool ellipsize = false,
  }) {
    final text = Text(
      title,
      style: groupTitleStyle(context),
      overflow: ellipsize ? TextOverflow.ellipsis : null,
      softWrap: true,
    );

    return Row(
      children: [
        groupAccentBar(context),
        const SizedBox(width: 10),
        ellipsize ? Flexible(child: text) : Expanded(child: text),
      ],
    );
  }

  /// Hairline drawn under group header bands.
  static Widget groupHeaderDivider(BuildContext context) => Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary,
      );

  /// Subtle divider between sibling questions inside a group.
  static Widget childDivider(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        indent: 12,
        endIndent: 12,
        color:
            Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6),
      );

  /// Border flagging a required item that is still unanswered.
  static BoxDecoration requiredItemDecoration(BuildContext context) =>
      BoxDecoration(
        borderRadius: cardRadius,
        border:
            Border.all(color: Theme.of(context).colorScheme.error, width: 1.2),
      );
}
