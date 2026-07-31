/// Segments that compose the default group card.
///
/// A group card is drawn as a header segment followed by one segment per child
/// so it can be rendered two ways from a single description of the surface:
///
/// * stacked in a [Column] by `QuestionnaireGroupItem`, for the page view
///   renderer and for nested groups;
/// * emitted as separate `ListView.builder` entries by `QuestionnaireListView`,
///   which keeps builds per-question instead of forcing the whole group subtree
///   to lay out as soon as it enters the cache extent.
///
/// Both paths must stay visually identical, hence the shared widgets below.
library;

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/fhir_extensions.dart';
import '../questionnaire_styles.dart';
import 'questionnaire_item_wrapper.dart';

/// Header segment of a group card: top-rounded surface with the group title.
class QuestionnaireGroupHeader extends StatelessWidget {
  final QuestionnaireItem group;

  /// Whether [QuestionnaireGroupChild] segments continue this surface below.
  ///
  /// When `false` the header closes the card on its own: full corner radius,
  /// bottom margin and padding, and no divider.
  final bool hasChildren;

  const QuestionnaireGroupHeader({
    super.key,
    required this.group,
    required this.hasChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: QuestionnaireStyles.cardMargin,
        right: QuestionnaireStyles.cardMargin,
        top: QuestionnaireStyles.cardMargin,
        bottom: hasChildren ? 0 : QuestionnaireStyles.cardMargin,
      ),
      padding: hasChildren
          ? null
          : const EdgeInsets.only(bottom: QuestionnaireStyles.cardMargin),
      decoration: BoxDecoration(
          borderRadius: hasChildren
              ? const BorderRadius.vertical(
                  top: Radius.circular(QuestionnaireStyles.cornerRadius))
              : QuestionnaireStyles.cardRadius,
          color: Theme.of(context).colorScheme.surface,
          boxShadow: QuestionnaireStyles.cardShadow(context)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: QuestionnaireStyles.groupTitleRow(context,
                title: group.displayTitle),
          ),
          if (hasChildren) QuestionnaireStyles.groupHeaderDivider(context),
        ],
      ),
    );
  }
}

/// Child segment of a group card: continues the group surface, rounding and
/// closing it on the last child.
class QuestionnaireGroupChild extends StatelessWidget {
  final QuestionnaireItem questionnaireItem;
  final int index;
  final bool isLastChild;

  const QuestionnaireGroupChild({
    super.key,
    required this.questionnaireItem,
    required this.index,
    required this.isLastChild,
  });

  @override
  Widget build(BuildContext context) {
    // Clip the shadow's upward bleed so it doesn't paint a dark band over the
    // previous segment; side and downward bleed stay within this entry.
    return ClipRect(
      clipper: const _BleedBelowClipper(),
      child: Container(
        margin: EdgeInsets.only(
            left: QuestionnaireStyles.cardMargin,
            right: QuestionnaireStyles.cardMargin,
            bottom: isLastChild ? QuestionnaireStyles.cardMargin : 0),
        padding: isLastChild
            ? const EdgeInsets.only(bottom: QuestionnaireStyles.cardMargin)
            : null,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: isLastChild
                ? const BorderRadius.vertical(
                    bottom: Radius.circular(QuestionnaireStyles.cornerRadius))
                : null,
            boxShadow: QuestionnaireStyles.cardShadow(context)),
        child: Column(
          children: [
            if (index > 0) QuestionnaireStyles.childDivider(context),
            QuestionnaireItemWrapper(
              questionnaireItem: questionnaireItem,
              index: index,
              isLastItem: isLastChild,
            ),
          ],
        ),
      ),
    );
  }
}

/// One slice of an enclosing group's surface, drawn around a hoisted entry.
///
/// When a nested group is flattened, its entries leave the parent's container
/// and become siblings of it in the list. They still have to look like they sit
/// inside the parent card, so each one re-creates the slice of parent surface it
/// covers. Nesting these wraps reproduces surfaces of any depth.
class QuestionnaireGroupSurface extends StatelessWidget {
  /// The hoisted entry — a segment, or another surface wrapping one.
  final Widget child;

  /// Whether this entry is the enclosing group's last descendant, and so has to
  /// round off and close its card.
  final bool closes;

  /// Whether the enclosing group's divider belongs above this entry, i.e. this
  /// is the first entry of a subtree that follows a sibling.
  final bool leadingDivider;

  const QuestionnaireGroupSurface({
    super.key,
    required this.child,
    required this.closes,
    required this.leadingDivider,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: const _BleedBelowClipper(),
      child: Container(
        margin: EdgeInsets.only(
            left: QuestionnaireStyles.cardMargin,
            right: QuestionnaireStyles.cardMargin,
            bottom: closes ? QuestionnaireStyles.cardMargin : 0),
        padding: closes
            ? const EdgeInsets.only(bottom: QuestionnaireStyles.cardMargin)
            : null,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: closes
                ? const BorderRadius.vertical(
                    bottom: Radius.circular(QuestionnaireStyles.cornerRadius))
                : null,
            boxShadow: QuestionnaireStyles.cardShadow(context)),
        child: Column(
          children: [
            if (leadingDivider) QuestionnaireStyles.childDivider(context),
            child,
          ],
        ),
      ),
    );
  }
}

/// Clips at the top edge while leaving room for the shadow to extend below.
class _BleedBelowClipper extends CustomClipper<Rect> {
  const _BleedBelowClipper();

  // blur(8) + offset(2) = 10px of maximum downward shadow bleed.
  static const double _bleed = 12.0;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0, 0, size.width, size.height + _bleed);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
