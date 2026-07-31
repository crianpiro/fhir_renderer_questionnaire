import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fhir_renderer_showcase/main.dart';
import 'package:fhir_renderer_showcase/showcase_catalog.dart';
import 'package:fhir_renderer_showcase/views/coming_soon_page.dart';

void main() {
  testWidgets('lists every package in the monorepo', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    for (final showcase in showcaseCatalog) {
      expect(
        find.text(showcase.name),
        findsOneWidget,
        reason: '${showcase.name} should be listed on the showcase home page',
      );
    }
  });

  testWidgets('opens the example app of an implemented package', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());

    await tester.tap(find.text('fhir_renderer_questionnaire'));
    await tester.pumpAndSettle();

    // The questionnaire package's own example page, not a reimplementation.
    expect(find.text('FHIR Renderer Questionnaire'), findsOneWidget);
    expect(find.text('Questionnaire Examples'), findsOneWidget);
  });

  testWidgets('shows a placeholder for a package without an example', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());

    await tester.tap(find.text('fhir_renderer_care_plan'));
    await tester.pumpAndSettle();

    expect(find.byType(ComingSoonPage), findsOneWidget);
    expect(find.text('Not implemented yet'), findsOneWidget);
  });

  testWidgets('marks unimplemented packages as coming soon', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    final pending = showcaseCatalog.where((s) => !s.isAvailable).length;
    expect(find.widgetWithText(Chip, 'Soon'), findsNWidgets(pending));
  });
}
