import 'package:example/data/default_validation_mock.dart';
import 'package:example/data/questionnaires_mock.dart';
import 'package:example/data/regex_validation_mock.dart';
import 'package:example/views/custom_builder_examples.dart';
import 'package:example/views/focus_test_page.dart';
import 'package:example/views/questionnaire_example_page.dart';
import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FHIR Renderer Questionnaire"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader(context, 'Questionnaire Examples'),
            _buildExampleCard(
              context,
              title: 'Patient Demographics',
              description:
                  'Collect patient info: string, text, date, choice types',
              icon: Icons.person,
              color: Colors.blue,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: patientDemographicsQuestionnaire,
                      title: 'Patient Demographics',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Health Assessment',
              description:
                  'Health status: boolean, integer, decimal, open-choice types',
              icon: Icons.health_and_safety,
              color: Colors.green,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: healthAssessmentQuestionnaire,
                      title: 'Health Assessment',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Clinical Screening',
              description: 'Conditional questions with enableWhen logic',
              icon: Icons.medical_services,
              color: Colors.orange,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: clinicalScreeningQuestionnaire,
                      title: 'Clinical Screening',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Appointment Booking',
              description: 'Date, time, dateTime pickers with itemControl',
              icon: Icons.calendar_month,
              color: Colors.purple,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: appointmentBookingQuestionnaire,
                      title: 'Appointment Booking',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Document Upload',
              description: 'Attachment and reference types for file uploads',
              icon: Icons.upload_file,
              color: Colors.teal,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: documentUploadQuestionnaire,
                      title: 'Document Upload',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'All Item Types Showcase',
              description: 'Demonstrates all 16 supported FHIR item types',
              icon: Icons.view_list,
              color: Colors.indigo,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: allItemTypesShowcase,
                      title: 'All Item Types',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Read-Only Demo',
              description: 'Pre-filled questionnaire in read-only mode',
              icon: Icons.lock,
              color: Colors.grey,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: readOnlyDemoQuestionnaire,
                      title: 'Read-Only Demo',
                      forceReadOnly: true,
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, 'Validation Examples'),
            _buildExampleCard(
              context,
              title: 'Default Validation',
              description:
                  'Auto-validation for integer, decimal, url, quantity',
              icon: Icons.check_circle,
              color: Colors.lightGreen,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: defaultValidationExample,
                      title: 'Default Validation',
                    ),
                  ),
            ),
            _buildExampleCard(
              context,
              title: 'Regex Validation',
              description: 'Custom regex patterns with FHIR extensions',
              icon: Icons.pattern,
              color: Colors.deepOrange,
              onTap:
                  () => _navigateTo(
                    context,
                    QuestionnaireExamplePage(
                      questionnaire: regexValidationExample,
                      title: 'Regex Validation',
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, 'Custom Builder Examples'),
            _buildExampleCard(
              context,
              title: 'Custom Choice Builder',
              description: 'Segmented control for choice items',
              icon: Icons.toggle_on,
              color: Colors.pink,
              onTap: () => _navigateTo(context, CustomChoiceBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom Boolean Builder',
              description: 'Switch-style boolean items',
              icon: Icons.toggle_off,
              color: Colors.cyan,
              onTap: () => _navigateTo(context, CustomBooleanBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom Field Builder',
              description: 'Material 3 styled text fields',
              icon: Icons.text_fields,
              color: Colors.amber,
              onTap: () => _navigateTo(context, CustomFieldBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom DateTime Builder',
              description: 'Action chip style date/time pickers',
              icon: Icons.schedule,
              color: Colors.lime,
              onTap: () => _navigateTo(context, CustomDateTimeBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom Group Builder',
              description: 'ExpansionTile-based group items',
              icon: Icons.folder_open,
              color: Colors.brown,
              onTap: () => _navigateTo(context, CustomGroupBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom Display Builder',
              description: 'Gradient info/warning cards for display items',
              icon: Icons.info,
              color: Colors.blueGrey,
              onTap: () => _navigateTo(context, CustomDisplayBuilderPage()),
            ),
            _buildExampleCard(
              context,
              title: 'Custom Reference Builder',
              description: 'Autocomplete-style FHIR resource references',
              icon: Icons.link,
              color: Colors.deepPurple,
              onTap: () => _navigateTo(context, CustomReferenceBuilderPage()),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, 'Testing'),
            _buildExampleCard(
              context,
              title: 'Focus & EnableWhen Test',
              description: 'Test focus retention and conditional logic',
              icon: Icons.bug_report,
              color: Colors.red,
              onTap: () => _navigateTo(context, FocusTestPage()),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
