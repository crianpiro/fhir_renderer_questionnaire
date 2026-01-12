import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/open_choice_value_mixin.dart';

class QuestionnaireOpenChoiceItem extends QuestionnaireBaseItem
    with OpenChoiceValueMixin {
  const QuestionnaireOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final InheritedQuestionnaireRenderer questionnaireRendererData =
        InheritedQuestionnaireRenderer.of(context);
    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: questionnaireItem.text?.valueString,
      children: questionnaireItem.answerOption?.map((answerOption) {
            String displayValue = getDisplayValue(answerOption);

            final selectedResponseItem = findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              itemLinkId,
            );

            bool isSelected = isInitialOrSelectedValue(
                selectedResponseItem, questionnaireItem, answerOption);

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
          }).toList() ??
          [],
    );
  }
}
