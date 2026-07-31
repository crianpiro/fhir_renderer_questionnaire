import 'package:flutter/material.dart';

import '../showcase_catalog.dart';

/// Shown for a package that exists in the monorepo but has no example yet.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.showcase});

  final PackageShowcase showcase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(showcase.name), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showcase.icon,
                  size: 64,
                  color: showcase.color.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 24),
                Text(
                  'Not implemented yet',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  showcase.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'This package is a placeholder in the monorepo. Once it ships '
                  'an example app, it will appear here automatically.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
