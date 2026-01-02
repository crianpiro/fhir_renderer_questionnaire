import 'dart:math';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
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
    if (InheritedQuestionnaireRenderer.of(context)
            .internalController
            .indexedItems
            .containsKey(
              questionnaireItem.linkId.valueString,
            ) &&
        InheritedQuestionnaireRenderer.of(context)
                .internalController
                .indexedItems[questionnaireItem.linkId.valueString]!
                .textController ==
            null) {
      final currentResponseItem = findQuestionnaireResponseItem(
        InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
        questionnaireItem.linkId.valueString,
      );
      String initialValue = "";
      if (questionnaireItem.initial != null &&
          questionnaireItem.initial!.isNotEmpty) {
        final initial = questionnaireItem.initial!.first;
        if (initial.valueX is FhirString) {
          initialValue = (initial.valueX as FhirString).valueString ?? "";
        } else if (initial.valueX is FhirDecimal) {
          initialValue = (initial.valueX as FhirDecimal).valueDouble.toString();
        } else if (initial.valueX is FhirInteger) {
          initialValue = (initial.valueX as FhirInteger).valueInt.toString();
        } else if (initial.valueX is Quantity) {
          initialValue =
              (initial.valueX as Quantity).value?.valueDouble?.toString() ?? "";
        } else if (initial.valueX is FhirUri) {
          initialValue = (initial.valueX as FhirUri).valueUri?.toString() ?? "";
        }
      }

      localController = TextEditingController(
        text: currentResponseItem
                ?.answer?.firstOrNull?.valueString?.valueString ??
            initialValue,
      );
      InheritedQuestionnaireRenderer.of(context)
              .internalController
              .indexedItems[questionnaireItem.linkId.valueString!] =
          InheritedQuestionnaireRenderer.of(context)
              .internalController
              .indexedItems[questionnaireItem.linkId.valueString]!
              .copyWith(textController: localController);
    } else {
      localController = InheritedQuestionnaireRenderer.of(context)
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
        minLines: questionnaireItem.type == QuestionnaireItemType.text ? 5 : 1,
        maxLength: questionnaireItem.maxLength?.valueInt,
      ),
    );
  }
}
