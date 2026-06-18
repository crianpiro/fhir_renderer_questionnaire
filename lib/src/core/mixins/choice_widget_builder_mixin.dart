import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../ui/layout/inherited_questionnaire_renderer.dart';
import '../utils/fhir_renderer_questionnaire_response_utils.dart';
import '../extensions/fhir_extensions.dart';

/// Mixin providing shared widget building logic for choice and open-choice items.
///
/// Consolidates the common option-rendering logic (radio buttons, checkboxes, dropdowns)
/// used by both QuestionnaireChoiceItem and QuestionnaireOpenChoiceItem.
///
/// Supports the questionnaire-itemControl extension for UI control selection.
mixin ChoiceWidgetBuilderMixin {
  /// Builds a list of option widgets based on repeats property and itemControl extension.
  ///
  /// Supports multiple widget types:
  /// - Radio buttons (default for single-select)
  /// - Checkboxes (default for multi-select)
  /// - Dropdown (when questionnaire-itemControl extension is 'drop-down')
  ///
  /// Parameters:
  /// - [context]: BuildContext for accessing inherited data
  /// - [questionnaireItem]: The questionnaire item containing options
  /// - [selectedResponseItem]: Current response item (if any)
  /// - [repeats]: Whether multiple selections are allowed
  ///
  /// Returns a list of widgets (RadioListTile, CheckboxListTile, or DropdownButtonFormField).
  List<Widget> buildOptionWidgets({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireResponseItem? selectedResponseItem,
    required bool repeats,
  }) {
    final questionnaireRendererData =
        InheritedQuestionnaireRenderer.of(context);

    if (questionnaireItem.answerOption == null) {
      return [];
    }

    // Check for itemControl extension
    final itemControl = questionnaireItem.itemControlCode;

    // Handle dropdown control
    if (itemControl == 'drop-down') {
      // The "**" marker only appears in the multi-select dropdown, so the
      // legend is gated on the same condition to keep the two in sync.
      final legend =
          repeats ? buildExclusiveOptionsLegend(questionnaireItem) : null;
      return [
        if (legend != null) legend,
        buildDropdownOption(
          context: context,
          questionnaireItem: questionnaireItem,
          selectedResponseItem: selectedResponseItem,
          repeats: repeats,
          questionnaireRendererData: questionnaireRendererData,
        ),
      ];
    }

    // The "**" marker is only rendered on checkboxes (multi-select), never on
    // radio buttons, so show the legend exactly when checkboxes are used.
    final usesCheckboxes =
        itemControl == 'check-box' || (itemControl == null && repeats);
    final legend =
        usesCheckboxes ? buildExclusiveOptionsLegend(questionnaireItem) : null;

    // Default behavior: radio buttons or checkboxes
    final optionWidgets = questionnaireItem.answerOption!.map((answerOption) {
      final displayValue = getDisplayValue(answerOption);

      // Respect explicit itemControl if provided
      if (itemControl == 'check-box' || (itemControl == null && repeats)) {
        // Multiple selection - use checkboxes
        return buildCheckboxOption(
          context: context,
          questionnaireItem: questionnaireItem,
          answerOption: answerOption,
          selectedResponseItem: selectedResponseItem,
          displayValue: displayValue,
          questionnaireRendererData: questionnaireRendererData,
        );
      } else {
        // Single selection - use radio buttons
        return buildRadioOption(
          context: context,
          questionnaireItem: questionnaireItem,
          answerOption: answerOption,
          selectedResponseItem: selectedResponseItem,
          displayValue: displayValue,
          questionnaireRendererData: questionnaireRendererData,
        );
      }
    }).toList();

    return [
      if (legend != null) legend,
      ...optionWidgets,
    ];
  }

  /// Builds a legend explaining the `**` marker used to flag mutually exclusive
  /// options, or `null` when the item has no exclusive options.
  ///
  /// An option is exclusive when it carries the FHIR SDC
  /// `questionnaire-optionExclusive` extension. Selecting it clears every other
  /// selection (the "all"/"none" master option behavior).
  Widget? buildExclusiveOptionsLegend(QuestionnaireItem questionnaireItem) {
    final hasExclusiveOption = questionnaireItem.answerOption
            ?.any((option) => option.isOptionExclusive) ??
        false;

    if (!hasExclusiveOption) return null;

    return const Padding(
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
      child: Text(
        'Options marked with ** are exclusive.',
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),
      ),
    );
  }

  /// Appends the `**` marker to an option label when the option is mutually
  /// exclusive, leaving non-exclusive labels untouched.
  String markExclusiveLabel(
    String label,
    QuestionnaireAnswerOption answerOption,
  ) =>
      answerOption.isOptionExclusive ? '$label **' : label;

  /// Builds a checkbox widget for multi-select options.
  Widget buildCheckboxOption({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireAnswerOption answerOption,
    required QuestionnaireResponseItem? selectedResponseItem,
    required String displayValue,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) {
    final isSelected = isOptionSelected(
      selectedResponseItem,
      questionnaireItem,
      answerOption,
    );

    return CheckboxListTile(
      value: isSelected,
      onChanged: (v) => questionnaireRendererData.onResponseChanged(
        FhirRendererQuestionnaireResponseUtils
            .setMultipleAnswerOptionsInQuestionnaireResponse(
          questionnaireRendererData.questionnaireResponse,
          questionnaireItem,
          answerOption,
        ),
      ),
      title: Text(markExclusiveLabel(displayValue, answerOption)),
    );
  }

  /// Builds a radio button widget for single-select options.
  Widget buildRadioOption({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireAnswerOption answerOption,
    required QuestionnaireResponseItem? selectedResponseItem,
    required String displayValue,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) {
    final selectedCode = getSelectedCodingValue(selectedResponseItem);
    final optionCode = answerOption.valueCoding?.code?.valueString;

    return RadioListTile<String>(
      value: optionCode ?? '',
      groupValue: selectedCode,
      onChanged: (v) => questionnaireRendererData.onResponseChanged(
        FhirRendererQuestionnaireResponseUtils
            .setAnswerOptionInQuestionnaireResponse(
          questionnaireRendererData.questionnaireResponse,
          questionnaireItem,
          answerOption,
        ),
      ),
      title: Text(displayValue),
    );
  }

  /// Builds a dropdown widget for single or multi-select options.
  ///
  /// For single-select: Returns a DropdownButtonFormField
  /// For multi-select: Returns a custom multi-select dropdown implementation
  Widget buildDropdownOption({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireResponseItem? selectedResponseItem,
    required bool repeats,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) {
    if (repeats) {
      return _buildMultiSelectDropdown(
        context: context,
        questionnaireItem: questionnaireItem,
        selectedResponseItem: selectedResponseItem,
        questionnaireRendererData: questionnaireRendererData,
      );
    } else {
      return _buildSingleSelectDropdown(
        context: context,
        questionnaireItem: questionnaireItem,
        selectedResponseItem: selectedResponseItem,
        questionnaireRendererData: questionnaireRendererData,
      );
    }
  }

  /// Builds a single-select dropdown button.
  Widget _buildSingleSelectDropdown({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireResponseItem? selectedResponseItem,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) {
    final selectedCode = getSelectedCodingValue(selectedResponseItem);
    final options = questionnaireItem.answerOption ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedCode,
        decoration: InputDecoration(
          labelText: questionnaireItem.text?.valueString,
          border: const OutlineInputBorder(),
        ),
        items: options.map((answerOption) {
          final code = answerOption.valueCoding?.code?.valueString ?? '';
          final display = getDisplayValue(answerOption);

          return DropdownMenuItem<String>(
            value: code,
            child: Text(display),
          );
        }).toList(),
        onChanged: (String? value) {
          if (value == null) return;

          // Find the answer option that matches the selected code
          final selectedOption = options.firstWhere(
            (option) => option.valueCoding?.code?.valueString == value,
          );

          questionnaireRendererData.onResponseChanged(
            FhirRendererQuestionnaireResponseUtils
                .setAnswerOptionInQuestionnaireResponse(
              questionnaireRendererData.questionnaireResponse,
              questionnaireItem,
              selectedOption,
            ),
          );
        },
      ),
    );
  }

  /// Builds a multi-select dropdown (checkboxes in a popup).
  Widget _buildMultiSelectDropdown({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireResponseItem? selectedResponseItem,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) {
    final options = questionnaireItem.answerOption ?? [];
    final selectedOptions = <QuestionnaireAnswerOption>[];

    // Collect currently selected options
    for (final option in options) {
      if (isOptionSelected(selectedResponseItem, questionnaireItem, option)) {
        selectedOptions.add(option);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: questionnaireItem.text?.valueString,
          border: const OutlineInputBorder(),
        ),
        child: InkWell(
          onTap: () => _showMultiSelectDialog(
            context: context,
            questionnaireItem: questionnaireItem,
            selectedResponseItem: selectedResponseItem,
            questionnaireRendererData: questionnaireRendererData,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedOptions.isEmpty
                      ? 'Select options...'
                      : selectedOptions
                          .map((opt) =>
                              markExclusiveLabel(getDisplayValue(opt), opt))
                          .join(', '),
                  style: TextStyle(
                    color: selectedOptions.isEmpty
                        ? Theme.of(context).hintColor
                        : null,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a dialog with checkboxes for multi-select.
  Future<void> _showMultiSelectDialog({
    required BuildContext context,
    required QuestionnaireItem questionnaireItem,
    required QuestionnaireResponseItem? selectedResponseItem,
    required InheritedQuestionnaireRenderer questionnaireRendererData,
  }) async {
    final options = questionnaireItem.answerOption ?? [];
    final legend = buildExclusiveOptionsLegend(questionnaireItem);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(questionnaireItem.text?.valueString ?? 'Select'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (legend != null) legend,
                    ...options.map((answerOption) {
                    final isSelected = isOptionSelected(
                      selectedResponseItem,
                      questionnaireItem,
                      answerOption,
                    );
                    final displayValue = getDisplayValue(answerOption);

                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        questionnaireRendererData.onResponseChanged(
                          FhirRendererQuestionnaireResponseUtils
                              .setMultipleAnswerOptionsInQuestionnaireResponse(
                            questionnaireRendererData.questionnaireResponse,
                            questionnaireItem,
                            answerOption,
                          ),
                        );
                        setState(() {}); // Refresh dialog
                      },
                      title: Text(
                        markExclusiveLabel(displayValue, answerOption),
                      ),
                    );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Extracts the display value from an answer option.
  ///
  /// Must be implemented by the mixing class or provided by ChoiceBaseMixin.
  String getDisplayValue(QuestionnaireAnswerOption answerOption);

  /// Checks if a specific answer option is selected (for multi-select).
  ///
  /// Must be implemented by the mixing class or provided by ChoiceBaseMixin.
  bool isOptionSelected(
    QuestionnaireResponseItem? responseItem,
    QuestionnaireItem questionnaireItem,
    QuestionnaireAnswerOption answerOption,
  );

  /// Gets the selected coding value code (for single-select).
  ///
  /// Must be implemented by the mixing class or provided by ChoiceBaseMixin.
  String? getSelectedCodingValue(QuestionnaireResponseItem? responseItem);
}
