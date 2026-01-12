import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_choice_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverChoiceItem extends QuestionnaireChoiceItem {
  const QuestionnaireSliverChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverBaseDecorator(
      roundBottomBorder: isLastItem,
      title: questionnaireItem.text?.valueString,
      children: questionnaireItem.answerOption?.map((answerOption) {
            String displayValue =
                answerOption.valueCoding?.display?.valueString ??
                    answerOption.valueCoding?.code?.valueString ??
                    "--";

            final selectedResponseItem = findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              itemLinkId,
            );

            String? selectedValue = getInitialOrSelectedValue(
                selectedResponseItem, questionnaireItem);

            return SliverToBoxAdapter(
              child: RadioListTile(
                value: selectedValue,
                groupValue: answerOption.valueCoding?.code?.valueString,
                onChanged: (v) => InheritedQuestionnaireRenderer.of(
                  context,
                ).onResponseChanged(
                  FhirRendererQuestionnaireResponseUtils
                      .setAnswerOptionInQuestionnaireResponse(
                    InheritedQuestionnaireRenderer.of(
                      context,
                    ).questionnaireResponse,
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
