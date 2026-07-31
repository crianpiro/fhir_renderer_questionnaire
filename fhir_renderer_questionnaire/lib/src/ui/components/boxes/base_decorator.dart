import 'package:flutter/material.dart';

class BaseDecorator extends StatelessWidget {
  final bool roundBottomBorder;
  final bool useNotImplementedStyle;
  final String? title;
  final Widget? child;
  final List<Widget>? children;
  const BaseDecorator({
    required this.title,
    required this.roundBottomBorder,
    this.child,
    this.useNotImplementedStyle = false,
    this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: useNotImplementedStyle
            ? Theme.of(context).colorScheme.errorContainer
            : null,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(roundBottomBorder ? 7 : 0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          if (child != null) child!,
          if (children != null) ...children!,
        ],
      ),
    );
  }
}
