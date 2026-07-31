import 'package:flutter/material.dart';

import '../questionnaire_styles.dart';

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
    final hasContent = child != null || (children?.isNotEmpty ?? false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: useNotImplementedStyle
            ? Theme.of(context).colorScheme.errorContainer
            : null,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
              roundBottomBorder ? QuestionnaireStyles.cornerRadius : 0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: useNotImplementedStyle
                ? QuestionnaireStyles.itemTitleStyle(context)?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer)
                : QuestionnaireStyles.itemTitleStyle(context),
          ),
          if (hasContent) const SizedBox(height: 6),
          if (child != null) child!,
          if (children != null) ...children!,
        ],
      ),
    );
  }
}
