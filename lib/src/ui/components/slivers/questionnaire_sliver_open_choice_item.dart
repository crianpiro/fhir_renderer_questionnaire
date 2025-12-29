import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_open_choice_item.dart';
import 'sliver_base_decorator.dart';

class QuestionnaireSliverOpenChoiceItem extends QuestionnaireOpenChoiceItem {
  const QuestionnaireSliverOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final QuestionnaireRendererData questionnaireRendererData =
        QuestionnaireRendererData.of(context);
    return SliverBaseDecorator(
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

            return SliverToBoxAdapter(
              child: CheckboxListTile(
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
              ),
            );
          }).toList() ??
          [],
    );
  }
}
