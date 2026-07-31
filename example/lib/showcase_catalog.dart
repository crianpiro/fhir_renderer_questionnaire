import 'package:fhir_renderer_questionnaire_example/views/home_page.dart'
    as questionnaire;
import 'package:flutter/material.dart';

/// A single package's entry in the showcase.
///
/// [builder] is null while a package is still a placeholder, which is what
/// drives the "coming soon" treatment in the UI - there is no separate
/// "implemented" flag to keep in sync.
class PackageShowcase {
  const PackageShowcase({
    required this.name,
    required this.summary,
    required this.icon,
    required this.color,
    this.builder,
  });

  /// The package directory name, which is also its pub.dev name.
  final String name;

  /// One-line description of what the package renders.
  final String summary;

  final IconData icon;
  final Color color;

  /// Builds the package's example. Null means the package is not implemented.
  final WidgetBuilder? builder;

  bool get isAvailable => builder != null;
}

/// Every package in the monorepo, in the order they are presented.
///
/// When a placeholder package gains an example app, add its example as a path
/// dependency in `pubspec.yaml` and give the entry below a [builder].
const List<PackageShowcase> showcaseCatalog = <PackageShowcase>[
  PackageShowcase(
    name: 'fhir_renderer_questionnaire',
    summary:
        'Renders FHIR R4 Questionnaires and produces valid '
        'QuestionnaireResponse objects.',
    icon: Icons.assignment_outlined,
    color: Color.fromRGBO(103, 80, 164, 1),
    builder: _buildQuestionnaireExample,
  ),
  PackageShowcase(
    name: 'fhir_renderer_care_plan',
    summary: 'Renders FHIR R4 CarePlan resources.',
    icon: Icons.event_note_outlined,
    color: Color.fromRGBO(0, 105, 92, 1),
  ),
  PackageShowcase(
    name: 'fhir_renderer_xxxx',
    summary: 'Reserved for an upcoming FHIR R4 resource renderer.',
    icon: Icons.widgets_outlined,
    color: Color.fromRGBO(84, 110, 122, 1),
  ),
];

Widget _buildQuestionnaireExample(BuildContext context) =>
    const questionnaire.HomePage();
