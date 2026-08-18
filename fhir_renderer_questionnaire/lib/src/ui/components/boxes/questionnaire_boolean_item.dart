import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../questionnaire_styles.dart';
import '../../../core/mixins/boolean_value_mixin.dart';

class QuestionnaireBooleanItem extends QuestionnaireBaseItem
    with BooleanValueMixin {
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
      QuestionnaireResponseAnswer(valueBoolean: value),
    );

    InheritedQuestionnaireRenderer.of(context).onResponseChanged(resp);
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final selectedResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    bool? selectedValue =
        getInitialOrSelectedValue(selectedResponseItem, questionnaireItem);

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      children: [
        RadioListTile(
          value: true,
          title: const Text("Yes"),
          groupValue: selectedValue,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          shape: const RoundedRectangleBorder(
              borderRadius: QuestionnaireStyles.cardRadius),
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
        RadioListTile(
          value: false,
          title: const Text("No"),
          groupValue: selectedValue,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          shape: const RoundedRectangleBorder(
              borderRadius: QuestionnaireStyles.cardRadius),
          onChanged: (v) => onOptionChanged(context, v ?? false),
        ),
      ],
    );
  }
}
