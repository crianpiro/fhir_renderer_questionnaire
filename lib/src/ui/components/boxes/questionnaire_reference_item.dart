import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

/// Widget for rendering reference-type questionnaire items.
///
/// Allows users to input a reference to another FHIR resource.
/// Supports simple text input for resource references in the format:
/// "ResourceType/id" (e.g., "Practitioner/123", "Patient/456")
///
/// For more advanced use cases with FHIR server integration and search,
/// this component can be extended or customized via the builder pattern.
class QuestionnaireReferenceItem extends QuestionnaireBaseItem {
  const QuestionnaireReferenceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    final currentResponse = findQuestionnaireResponseItem(
      inheritedData.questionnaireResponse,
      itemLinkId,
    );

    final existingReference =
        currentResponse?.answer?.firstOrNull?.valueReference;

    // Get persistent controllers to prevent cursor jumping on rebuild
    final referenceController = getAssignedTextController(
      inheritedData,
      existingReference?.reference?.valueString ?? '',
    );

    final displayController = getSecondaryTextController(
      inheritedData,
      'display',
      existingReference?.display?.valueString ?? '',
    );

    // Get allowed resource types from extension if available
    final allowedTypes = _getAllowedResourceTypes();

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Help text
            if (allowedTypes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Allowed resource types: ${allowedTypes.join(", ")}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),

            // Reference input (ResourceType/id format)
            TextFormField(
              controller: referenceController,
              decoration: const InputDecoration(
                labelText: 'Resource Reference',
                hintText: 'e.g., Practitioner/123 or Patient/456',
                helperText: 'Format: ResourceType/id',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updateReference(
                inheritedData,
                value,
                displayController.text,
              ),
            ),

            const SizedBox(height: 12),

            // Display name input (optional, human-readable label)
            TextFormField(
              controller: displayController,
              decoration: const InputDecoration(
                labelText: 'Display Name (Optional)',
                hintText: 'e.g., Dr. Jane Smith',
                helperText: 'Human-readable label for the reference',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updateReference(
                inheritedData,
                referenceController.text,
                value,
              ),
            ),

            // Current reference display
            if (existingReference != null) ...[
              const SizedBox(height: 12),
              _ReferenceDisplay(reference: existingReference),
            ],
          ],
        ),
      ),
    );
  }

  void _updateReference(
    InheritedQuestionnaireRenderer inheritedData,
    String referenceString,
    String displayString,
  ) {
    QuestionnaireResponseAnswer? answer;

    if (referenceString.trim().isNotEmpty) {
      final reference = Reference(
        reference: FhirString(referenceString.trim()),
        display: displayString.trim().isNotEmpty
            ? FhirString(displayString.trim())
            : null,
      );

      answer = QuestionnaireResponseAnswer(valueX: reference);
    }

    final resp = FhirRendererQuestionnaireResponseUtils
        .setResponseAnswerInQuestionnaireResponse(
      inheritedData.questionnaireResponse,
      questionnaireItem,
      answer,
    );

    inheritedData.onResponseChanged(resp);
  }

  List<String> _getAllowedResourceTypes() {
    // Check if questionnaire item has extension for allowed types
    // Extension URL: http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource
    final extensions = questionnaireItem.extension_;
    if (extensions != null) {
      for (final ext in extensions) {
        if (ext.url.toString() ==
            'http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource') {
          final code = ext.valueX;
          if (code is FhirCode) {
            return [code.valueString ?? ''];
          }
        }
      }
    }

    // Fallback: parse from text if format suggests specific types
    final text = questionnaireItem.text?.valueString ?? '';
    if (text.toLowerCase().contains('practitioner')) {
      return ['Practitioner'];
    } else if (text.toLowerCase().contains('patient')) {
      return ['Patient'];
    } else if (text.toLowerCase().contains('organization')) {
      return ['Organization'];
    }

    return ['Any FHIR Resource'];
  }
}

/// Widget to display the current reference
class _ReferenceDisplay extends StatelessWidget {
  final Reference reference;

  const _ReferenceDisplay({required this.reference});

  @override
  Widget build(BuildContext context) {
    final ref = reference.reference?.valueString ?? '';
    final display = reference.display?.valueString;

    // Parse resource type and ID from reference
    String resourceType = 'Resource';
    String resourceId = ref;

    if (ref.contains('/')) {
      final parts = ref.split('/');
      if (parts.length == 2) {
        resourceType = parts[0];
        resourceId = parts[1];
      }
    }

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Current Reference',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _ReferenceField(
              label: 'Resource Type',
              value: resourceType,
              icon: Icons.category,
            ),
            const SizedBox(height: 8),
            _ReferenceField(
              label: 'Resource ID',
              value: resourceId,
              icon: Icons.tag,
            ),
            if (display != null) ...[
              const SizedBox(height: 8),
              _ReferenceField(
                label: 'Display Name',
                value: display,
                icon: Icons.label,
              ),
            ],
            const SizedBox(height: 8),
            _ReferenceField(
              label: 'Full Reference',
              value: ref,
              icon: Icons.link,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small widget to display a reference field
class _ReferenceField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReferenceField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
