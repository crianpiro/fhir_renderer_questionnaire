import 'dart:developer';

import 'package:example/data/questionnaires_mock.dart';
import 'package:example/widgets/segmented_choice.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

/// Example page demonstrating custom choice builder with SegmentedChoice widget
class CustomChoiceBuilderPage extends StatelessWidget {
  CustomChoiceBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: healthAssessmentQuestionnaire,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Choice Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        openChoiceItemBuilder: (
          index,
          isLastItem,
          selectedResponse,
          questionnaireItem,
          onAnswerOptionSelected,
        ) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${questionnaireItem.text}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedChoice<QuestionnaireAnswerOption>(
                  selectedValue:
                      questionnaireItem.answerOption
                          ?.where(
                            (item) =>
                                item.valueCoding ==
                                selectedResponse
                                    ?.answer
                                    ?.firstOrNull
                                    ?.valueCoding,
                          )
                          .firstOrNull,
                  values: questionnaireItem.answerOption!,
                  valueNameResolver:
                      (value) => "${value.valueCoding?.display?.valueString}",
                  enabled: true,
                  onSelectedValueChanged: (value) {
                    onAnswerOptionSelected(value);
                  },
                ),
                if (!isLastItem) const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom boolean builder with switches
class CustomBooleanBuilderPage extends StatelessWidget {
  CustomBooleanBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: clinicalScreeningQuestionnaire,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Boolean Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        boolItemBuilder: (
          index,
          isLastItem,
          selectedResponse,
          questionnaireItem,
          onAnswerChanged,
        ) {
          final currentValue =
              selectedResponse?.answer?.firstOrNull?.valueBoolean?.valueBoolean;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SwitchListTile(
              title: Text(
                "${questionnaireItem.text}",
                style: const TextStyle(fontSize: 15),
              ),
              value: currentValue ?? false,
              onChanged: (value) {
                onAnswerChanged(value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              secondary: Icon(
                currentValue == true
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color:
                    currentValue == true
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom field builder with Material 3 styling
class CustomFieldBuilderPage extends StatelessWidget {
  CustomFieldBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: patientDemographicsQuestionnaire,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Field Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        fieldItemBuilder: (
          index,
          isLastItem,
          fieldController,
          selectedResponse,
          questionnaireItem,
          onAnswerChanged,
        ) {
          final isMultiline =
              questionnaireItem.type == QuestionnaireItemType.text;
          final isRequired = questionnaireItem.required_?.valueBoolean ?? false;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${questionnaireItem.text}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isRequired)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: fieldController,
                  onChanged: onAnswerChanged,
                  maxLines: isMultiline ? 4 : 1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    hintText:
                        'Enter ${questionnaireItem.text?.valueString?.toLowerCase() ?? "value"}',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                if (!isLastItem) const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom datetime builder with Material 3 chips
class CustomDateTimeBuilderPage extends StatelessWidget {
  CustomDateTimeBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: appointmentBookingQuestionnaire,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom DateTime Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        dateTimeItemBuilder: (
          index,
          isLastItem,
          selectedResponse,
          questionnaireItem,
          onAnswerChanged,
        ) {
          final itemType = questionnaireItem.type;
          String displayValue = 'Tap to select';
          IconData icon = Icons.calendar_today;

          if (itemType == QuestionnaireItemType.date) {
            icon = Icons.calendar_month;
            final date = selectedResponse?.answer?.firstOrNull?.valueDate;
            if (date != null) {
              displayValue = date.valueString ?? 'Selected';
            }
          } else if (itemType == QuestionnaireItemType.time) {
            icon = Icons.access_time;
            final time = selectedResponse?.answer?.firstOrNull?.valueTime;
            if (time != null) {
              displayValue = time.valueString ?? 'Selected';
            }
          } else if (itemType == QuestionnaireItemType.dateTime) {
            icon = Icons.event;
            final dateTime =
                selectedResponse?.answer?.firstOrNull?.valueDateTime;
            if (dateTime != null) {
              displayValue = dateTime.valueString ?? 'Selected';
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${questionnaireItem.text}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ActionChip(
                  avatar: Icon(icon, size: 18),
                  label: Text(displayValue),
                  onPressed: () async {
                    if (itemType == QuestionnaireItemType.date) {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        onAnswerChanged(
                          QuestionnaireResponseAnswer(
                            valueDate: FhirDate.fromDateTime(date),
                          ),
                        );
                      }
                    } else if (itemType == QuestionnaireItemType.time) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        onAnswerChanged(
                          QuestionnaireResponseAnswer(
                            valueTime: FhirTime.fromUnits(
                              hour: time.hour,
                              minute: time.minute,
                            ),
                          ),
                        );
                      }
                    } else if (itemType == QuestionnaireItemType.dateTime) {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          final dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          onAnswerChanged(
                            QuestionnaireResponseAnswer(
                              valueDateTime: FhirDateTime.fromDateTime(
                                dateTime,
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                if (!isLastItem) const Divider(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom group builder with ExpansionTile
class CustomGroupBuilderPage extends StatelessWidget {
  CustomGroupBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(questionnaire: allItemTypesShowcase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Group Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        groupItemBuilder: (
          index,
          isLastItem,
          questionnaireItem,
          childrenAssigner,
        ) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                "${questionnaireItem.text}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${questionnaireItem.item?.length ?? 0} items',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              children:
                  questionnaireItem.item != null
                      ? List.generate(
                        questionnaireItem.item!.length,
                        (i) => childrenAssigner(questionnaireItem.item![i], i),
                      )
                      : [],
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom reference builder with autocomplete
class CustomReferenceBuilderPage extends StatelessWidget {
  CustomReferenceBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: documentUploadQuestionnaire,
      );

  // Mock data for FHIR resources (in a real app, this would come from a FHIR server)
  static const List<Map<String, String>> _mockPractitioners = [
    {'id': 'pract-001', 'name': 'Dr. Sarah Johnson', 'specialty': 'Family Medicine'},
    {'id': 'pract-002', 'name': 'Dr. Michael Chen', 'specialty': 'Internal Medicine'},
    {'id': 'pract-003', 'name': 'Dr. Emily Williams', 'specialty': 'Pediatrics'},
    {'id': 'pract-004', 'name': 'Dr. James Brown', 'specialty': 'Cardiology'},
    {'id': 'pract-005', 'name': 'Dr. Lisa Davis', 'specialty': 'Dermatology'},
  ];

  static const List<Map<String, String>> _mockOrganizations = [
    {'id': 'org-001', 'name': 'City General Hospital', 'type': 'Hospital'},
    {'id': 'org-002', 'name': 'Downtown Medical Center', 'type': 'Clinic'},
    {'id': 'org-003', 'name': 'Wellness Pharmacy', 'type': 'Pharmacy'},
    {'id': 'org-004', 'name': 'LabCorp Diagnostics', 'type': 'Laboratory'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Reference Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        referenceItemBuilder: (
          index,
          isLastItem,
          referenceController,
          displayController,
          selectedResponse,
          questionnaireItem,
          onReferenceChanged,
        ) {
          final itemText = questionnaireItem.text?.valueString ?? '';
          final isPractitioner = itemText.toLowerCase().contains('physician') ||
              itemText.toLowerCase().contains('referral');
          final isPharmacy = itemText.toLowerCase().contains('pharmacy');

          // Determine which mock data to use based on the item context
          final mockData = isPharmacy
              ? _mockOrganizations
              : isPractitioner
                  ? _mockPractitioners
                  : [..._mockPractitioners, ..._mockOrganizations];

          final resourceType = isPharmacy
              ? 'Organization'
              : isPractitioner
                  ? 'Practitioner'
                  : 'Resource';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with icon
                Row(
                  children: [
                    Icon(
                      isPractitioner
                          ? Icons.person
                          : isPharmacy
                              ? Icons.local_pharmacy
                              : Icons.link,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        itemText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Autocomplete field for searching resources
                Autocomplete<Map<String, String>>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return mockData;
                    }
                    return mockData.where((resource) {
                      final name = resource['name']!.toLowerCase();
                      final query = textEditingValue.text.toLowerCase();
                      return name.contains(query);
                    });
                  },
                  displayStringForOption: (option) => option['name']!,
                  fieldViewBuilder: (context, textController, focusNode, onSubmitted) {
                    // Sync with the persistent controller
                    if (textController.text.isEmpty && displayController.text.isNotEmpty) {
                      textController.text = displayController.text;
                    }
                    return TextField(
                      controller: textController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Search $resourceType',
                        hintText: 'Type to search...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: textController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  textController.clear();
                                  referenceController.clear();
                                  displayController.clear();
                                  onReferenceChanged('', '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      onSubmitted: (_) => onSubmitted(),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 250, maxWidth: 350),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: Text(
                                    option['name']![0],
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                title: Text(option['name']!),
                                subtitle: Text(
                                  option['specialty'] ?? option['type'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                trailing: Text(
                                  option['id']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (selection) {
                    final refString = '$resourceType/${selection['id']}';
                    final displayName = selection['name']!;
                    referenceController.text = refString;
                    displayController.text = displayName;
                    onReferenceChanged(refString, displayName);
                  },
                ),

                // Show current selection if exists
                if (referenceController.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayController.text,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                referenceController.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (!isLastItem) const Divider(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Example page demonstrating custom display builder
class CustomDisplayBuilderPage extends StatelessWidget {
  CustomDisplayBuilderPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: clinicalScreeningQuestionnaire,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Display Builder'),
        actions: [
          IconButton(
            onPressed: () {
              final response = controller.generateQuestionnaireResponse();
              log(response.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Response logged to console')),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: controller,
        displayItemBuilder: (index, isLastItem, questionnaireItem) {
          final text = questionnaireItem.text?.valueString ?? '';
          final isWarning = text.toLowerCase().contains('warning');

          return Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isWarning
                        ? [Colors.orange.shade100, Colors.red.shade100]
                        : [Colors.blue.shade50, Colors.purple.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isWarning ? Colors.orange.shade300 : Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isWarning ? Icons.warning_amber : Icons.info_outline,
                  color:
                      isWarning ? Colors.orange.shade700 : Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isWarning
                              ? Colors.orange.shade900
                              : Colors.blue.shade900,
                      fontWeight:
                          isWarning ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
