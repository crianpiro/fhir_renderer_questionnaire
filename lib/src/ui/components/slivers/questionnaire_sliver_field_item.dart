import 'dart:math';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_field_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverFieldItem extends QuestionnaireFieldItem {
  const QuestionnaireSliverFieldItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    TextEditingController localController = getAssignedTextController(
        InheritedQuestionnaireRenderer.of(context),
        getInitialValue(questionnaireItem));

    return SliverBaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      child: SliverToBoxAdapter(
        child: TextField(
          controller: localController,
          onChanged: (value) {
            final resp = FhirRendererQuestionnaireResponseUtils
                .setResponseAnswerInQuestionnaireResponse(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem,
              value.trim().isEmpty
                  ? null
                  : QuestionnaireResponseAnswer(valueX: FhirString(value)),
            );
            InheritedQuestionnaireRenderer.of(context).onResponseChanged(resp);
          },
          maxLines: questionnaireItem.type == QuestionnaireItemType.text
              ? 5
              : ((questionnaireItem.maxLength?.valueInt ?? 50) /
                      min(questionnaireItem.maxLength?.valueInt ?? 50, 50))
                  .floor(),
          minLines:
              questionnaireItem.type == QuestionnaireItemType.text ? 5 : 1,
          maxLength: questionnaireItem.maxLength?.valueInt,
        ),
      ),
    );
  }
}
