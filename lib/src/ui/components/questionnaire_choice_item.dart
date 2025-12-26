import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_base_item.dart';
import 'package:flutter/material.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';

class QuestionnaireChoiceItem extends QuestionnaireBaseItem {
  const QuestionnaireChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: questionnaireItem.text?.valueString,
      children: questionnaireItem.answerOption?.map((answerOption) {
            String displayValue =
                answerOption.valueCoding?.display?.valueString ??
                    answerOption.valueCoding?.code?.valueString ??
                    "--";

            final selectedResponseItem = findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            );

            String? selectedValue = selectedResponseItem
                ?.answer?.firstOrNull?.valueCoding?.code?.valueString;

            return RadioListTile(
              value: selectedValue,
              groupValue: answerOption.valueCoding?.code?.valueString,
              onChanged: (v) => QuestionnaireRendererData.of(
                context,
              ).onResponseChanged(
                FhirRendererQuestionnaireResponseUtils
                    .setAnswerOptionInQuestionnaireResponse(
                  QuestionnaireRendererData.of(
                    context,
                  ).questionnaireResponse,
                  questionnaireItem,
                  answerOption,
                ),
              ),
              title: Text(displayValue),
            );
          }).toList() ??
          [],
    );
  }
}
