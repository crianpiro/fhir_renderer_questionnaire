import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_base_item.dart';
import 'package:flutter/material.dart';

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
          title: Text("Ja"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
        RadioListTile(
          value: false,
          title: Text("Nein"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
      ],
    );
  }
}
