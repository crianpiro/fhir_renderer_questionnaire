import 'dart:math';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

class QuestionnaireFieldItem extends QuestionnaireBaseItem {
  const QuestionnaireFieldItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController localController;
    if (QuestionnaireRendererData.of(context)
            .internalController
            .indexedItems
            .containsKey(
              questionnaireItem.linkId.valueString,
            ) &&
        QuestionnaireRendererData.of(context)
                .internalController
                .indexedItems[questionnaireItem.linkId.valueString]!
                .textController ==
            null) {
      final currentResponseItem = findQuestionnaireResponseItem(
        QuestionnaireRendererData.of(context).questionnaireResponse,
        questionnaireItem.linkId.valueString,
      );
      localController = TextEditingController(
        text:
            currentResponseItem?.answer?.firstOrNull?.valueString?.valueString,
      );
      QuestionnaireRendererData.of(context)
              .internalController
              .indexedItems[questionnaireItem.linkId.valueString!] =
          QuestionnaireRendererData.of(context)
              .internalController
              .indexedItems[questionnaireItem.linkId.valueString]!
              .copyWith(textController: localController);
    } else {
      localController = QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems[questionnaireItem.linkId.valueString!]!
          .textController!;
    }

    return BaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      child: TextField(
        controller: localController,
        onChanged: (value) {
          final resp = FhirRendererQuestionnaireResponseUtils
              .setResponseAnswerInQuestionnaireResponse(
            QuestionnaireRendererData.of(context).questionnaireResponse,
            questionnaireItem,
            value.trim().isEmpty
                ? null
                : QuestionnaireResponseAnswer(valueX: FhirString(value)),
          );
          QuestionnaireRendererData.of(context).onResponseChanged(resp);
        },
        maxLines: questionnaireItem.type == QuestionnaireItemType.text
            ? 5
            : ((questionnaireItem.maxLength?.valueInt ?? 50) /
                    min(questionnaireItem.maxLength?.valueInt ?? 50, 50))
                .floor(),
        minLines: questionnaireItem.type == QuestionnaireItemType.text ? 5 : 1,
        maxLength: questionnaireItem.maxLength?.valueInt,
      ),
    );
  }
}
