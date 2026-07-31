import 'package:flutter/material.dart';

import 'showcase_catalog.dart';
import 'views/coming_soon_page.dart';

/// Entry point for the monorepo-wide showcase.
///
/// This is the app published to GitHub Pages. It owns no example content of its
/// own - it lists every package in the monorepo and hands off to that package's
/// own example app, so the deployed site always reflects the real examples.
void main() {
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FHIR Renderer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(103, 80, 164, 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(234, 221, 255, 1),
          foregroundColor: Color.fromRGBO(103, 80, 164, 1),
        ),
        useMaterial3: true,
      ),
      home: const ShowcaseHomePage(),
    );
  }
}

class ShowcaseHomePage extends StatelessWidget {
  const ShowcaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('FHIR Renderer'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          // The examples themselves are phone-shaped; keep the hub readable on
          // wide desktop browsers rather than stretching cards edge to edge.
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Flutter packages for rendering FHIR R4 resources. Pick a '
                'package to open its example app.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              for (final showcase in showcaseCatalog)
                _PackageCard(showcase: showcase),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.showcase});

  final PackageShowcase showcase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = showcase.isAvailable;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: showcase.color.withValues(
            alpha: available ? 0.2 : 0.08,
          ),
          child: Icon(
            showcase.icon,
            color: showcase.color.withValues(alpha: available ? 1 : 0.4),
          ),
        ),
        title: Text(
          showcase.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'monospace',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            showcase.summary,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing:
            available
                ? const Icon(Icons.chevron_right)
                : Chip(
                  label: const Text('Soon'),
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
        onTap: () => _open(context),
      ),
    );
  }

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            showcase.builder ??
            (context) => ComingSoonPage(showcase: showcase),
      ),
    );
  }
}
