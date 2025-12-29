import 'package:flutter/material.dart';

import '../boxes/base_decorator.dart';

class SliverBaseDecorator extends BaseDecorator {
  const SliverBaseDecorator({
    required super.title,
    required super.roundBottomBorder,
    super.child,
    super.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
