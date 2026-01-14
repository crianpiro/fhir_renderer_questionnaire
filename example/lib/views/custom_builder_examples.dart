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
