import 'package:flutter/material.dart';

import '../boxes/base_decorator.dart';
import '../questionnaire_styles.dart';

final class SliverBaseDecorator extends BaseDecorator {
  const SliverBaseDecorator({
    required super.title,
    required super.roundBottomBorder,
    super.child,
    super.children,
    super.useNotImplementedStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasContent = child != null || (children?.isNotEmpty ?? false);
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: useNotImplementedStyle
            ? Theme.of(context).colorScheme.errorContainer
            : null,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
              roundBottomBorder ? QuestionnaireStyles.cornerRadius : 0),
        ),
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                title ?? "",
                style: useNotImplementedStyle
                    ? QuestionnaireStyles.itemTitleStyle(context)?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer)
                    : QuestionnaireStyles.itemTitleStyle(context),
              ),
            ),
            if (hasContent)
              const SliverToBoxAdapter(child: SizedBox(height: 6)),
            if (child != null) child!,
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
