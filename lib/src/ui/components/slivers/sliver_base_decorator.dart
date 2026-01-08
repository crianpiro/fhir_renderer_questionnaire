import 'package:flutter/material.dart';

import '../boxes/base_decorator.dart';

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
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: useNotImplementedStyle
            ? Theme.of(context).colorScheme.errorContainer
            : null,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(roundBottomBorder ? 7 : 0),
        ),
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                title ?? "",
                style: useNotImplementedStyle
                    ? TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onErrorContainer)
                    : const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (child != null) child!,
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
