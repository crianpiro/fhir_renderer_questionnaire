import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

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
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      questionnaireItem,
      QuestionnaireResponseAnswer(valueX: FhirBoolean("$value")),
    );

    InheritedQuestionnaireRenderer.of(context).onResponseChanged(resp);
  }

  bool? getInitialOrSelectedValue(
      QuestionnaireResponseItem? selectedResponseItem) {
    return selectedResponseItem
                ?.answer?.firstOrNull?.valueBoolean?.valueBoolean ??
            questionnaireItem.initial != null &&
                questionnaireItem.initial!.isNotEmpty &&
                questionnaireItem.initial!.first.valueX is FhirBoolean
        ? (questionnaireItem.initial!.first.valueX as FhirBoolean).valueBoolean
        : null;
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final selectedResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    bool? selectedValue = getInitialOrSelectedValue(selectedResponseItem);

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      children: [
        RadioListTile(
          value: true,
          title: const Text("Yes"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
        RadioListTile(
          value: false,
          title: const Text("No"),
          groupValue: selectedValue,
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
      ],
    );
  }
}
