import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/choice_value_mixin.dart';

class QuestionnaireChoiceItem extends QuestionnaireBaseItem
    with ChoiceValueMixin {
  const QuestionnaireChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: itemTextTitle,
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

            return RadioListTile(
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
            );
          }).toList() ??
          [],
    );
  }
}
