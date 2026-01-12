import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_open_choice_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverOpenChoiceItem
    extends QuestionnaireOpenChoiceItem {
  const QuestionnaireSliverOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final InheritedQuestionnaireRenderer questionnaireRendererData =
        InheritedQuestionnaireRenderer.of(context);
    return SliverBaseDecorator(
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

            return SliverToBoxAdapter(
              child: CheckboxListTile(
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
              ),
            );
          }).toList() ??
          [],
    );
  }
}
