import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../ui/layout/inherited_questionnaire_renderer.dart';
import '../utils/fhir_renderer_questionnaire_response_utils.dart';

/// Mixin providing shared widget building logic for choice and open-choice items.
///
/// Consolidates the common option-rendering logic (radio buttons, checkboxes)
/// used by both QuestionnaireChoiceItem and QuestionnaireOpenChoiceItem.
mixin ChoiceWidgetBuilderMixin {
  /// Builds a list of option widgets (radio buttons or checkboxes) based on repeats property.
  ///
  /// Parameters:
  /// - [context]: BuildContext for accessing inherited data
  /// - [questionnaireItem]: The questionnaire item containing options
  /// - [selectedResponseItem]: Current response item (if any)
  /// - [repeats]: Whether multiple selections are allowed
  ///
  /// Returns a list of RadioListTile or CheckboxListTile widgets.
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

    return questionnaireItem.answerOption!.map((answerOption) {
      final displayValue = getDisplayValue(answerOption);

      if (repeats) {
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
  }

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
      title: Text(displayValue),
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
