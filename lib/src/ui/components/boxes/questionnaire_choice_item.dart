import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

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
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            );

            String? selectedValue;
            if (selectedResponseItem != null) {
              selectedValue = selectedResponseItem
                  .answer?.firstOrNull?.valueCoding?.code?.valueString;
            } else if (questionnaireItem.initial != null &&
                questionnaireItem.initial!.isNotEmpty &&
                questionnaireItem.initial!.first.valueX is Coding &&
                (questionnaireItem.initial!.first.valueX as Coding)
                        .code
                        ?.valueString !=
                    null) {
              selectedValue =
                  (questionnaireItem.initial!.first.valueX as Coding)
                      .code
                      ?.valueString;
            }

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
