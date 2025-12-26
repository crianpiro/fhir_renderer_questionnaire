import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_base_item.dart';
import 'package:flutter/material.dart';

class QuestionnaireOpenChoiceItem extends QuestionnaireBaseItem {
  const QuestionnaireOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final QuestionnaireRendererData questionnaireRendererData =
        QuestionnaireRendererData.of(context);
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

            return CheckboxListTile(
              value: selectedResponseItem?.answer?.any(
                    (answer) =>
                        answer.valueCoding?.code?.valueString ==
                        answerOption.valueCoding?.code?.valueString,
                  ) ??
                  false,
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
          }).toList() ??
          [],
    );
  }
}
