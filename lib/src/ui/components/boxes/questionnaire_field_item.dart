import 'dart:math';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/text_field_value_mixin.dart';

class QuestionnaireFieldItem extends QuestionnaireBaseItem
    with TextFieldValueMixin {
  const QuestionnaireFieldItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  void onTextChanged(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer,
      String value) {
    if (inheritedQuestionnaireRenderer.rendererController.indexedItems
            .containsKey(itemLinkId) &&
        inheritedQuestionnaireRenderer
                .rendererController.indexedItems[itemLinkId]!.dependentOn !=
            null &&
        inheritedQuestionnaireRenderer.rendererController
            .indexedItems[itemLinkId]!.dependentOn!.isNotEmpty) {
      final resp = FhirRendererQuestionnaireResponseUtils
          .setResponseAnswerInQuestionnaireResponse(
        inheritedQuestionnaireRenderer.questionnaireResponse,
        questionnaireItem,
        value.trim().isEmpty
            ? null
            : QuestionnaireResponseAnswer(valueX: FhirString(value)),
      );
      inheritedQuestionnaireRenderer.onResponseChanged(resp);
    }
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    TextEditingController localController = getAssignedTextController(
        InheritedQuestionnaireRenderer.of(context),
        getInitialValue(questionnaireItem));

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      child: TextField(
        controller: localController,
        onChanged: (value) {},
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
