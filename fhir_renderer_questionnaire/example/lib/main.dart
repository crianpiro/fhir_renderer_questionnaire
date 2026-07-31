import 'package:fhir_renderer_questionnaire_example/views/home_page.dart';
import 'package:flutter/material.dart';

/// Standalone entry point for the fhir_renderer_questionnaire example.
///
/// The monorepo showcase app does not use this entry point - it embeds
/// [HomePage] directly, supplying its own [MaterialApp] and theme.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      title: 'FHIR Renderer - Questionnaire',
      home: const HomePage(),
    );
  }
}
