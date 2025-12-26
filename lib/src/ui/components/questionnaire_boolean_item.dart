import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../core/data/questionnaire_renderer_data.dart';
import '../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import 'questionnaire_base_item.dart';

class QuestionnaireBooleanItem extends QuestionnaireBaseItem {
  const QuestionnaireBooleanItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  void onOptionChanged(BuildContext context, bool value) {
    final resp = FhirRendererQuestionnaireResponseUtils
        .setResponseAnswerInQuestionnaireResponse(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem,
      QuestionnaireResponseAnswer(valueX: FhirBoolean("$value")),
    );

    QuestionnaireRendererData.of(context).onResponseChanged(resp);
  }

  @override
  Widget build(BuildContext context) {
    final selectedResponseItem = findQuestionnaireResponseItem(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );

    bool? selectedValue =
        selectedResponseItem?.answer?.firstOrNull?.valueBoolean?.valueBoolean;

    return BaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      children: [
        RadioListTile(
          value: true,
          title: const Text("Ja"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
        RadioListTile(
          value: false,
          title: const Text("Nein"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
      ],
    );
  }
}
