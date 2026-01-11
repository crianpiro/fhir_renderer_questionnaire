import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

class QuestionnaireOpenChoiceItem extends QuestionnaireBaseItem {
  const QuestionnaireOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  bool getInitialOrSelectedValue(
      QuestionnaireResponseItem? selectedResponseItem,
      QuestionnaireAnswerOption answerOption) {
    return selectedResponseItem?.answer?.any(
          (answer) =>
              answer.valueCoding?.code?.valueString ==
              answerOption.valueCoding?.code?.valueString,
        ) ??
        questionnaireItem.initial != null &&
            questionnaireItem.initial!.any(
              (initial) =>
                  initial.valueX is Coding &&
                  (initial.valueX as Coding).code?.valueString ==
                      answerOption.valueCoding?.code?.valueString,
            );
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final InheritedQuestionnaireRenderer questionnaireRendererData =
        InheritedQuestionnaireRenderer.of(context);
    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: questionnaireItem.text?.valueString,
      children: questionnaireItem.answerOption?.map((answerOption) {
            String displayValue =
                answerOption.valueCoding?.display?.valueString ??
                    answerOption.valueCoding?.code?.valueString ??
                    "--";

            final selectedResponseItem = findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            );

            bool isSelected =
                getInitialOrSelectedValue(selectedResponseItem, answerOption);

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
