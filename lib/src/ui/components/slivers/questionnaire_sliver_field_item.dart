import 'dart:math';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_field_item.dart';
import 'sliver_base_decorator.dart';

/// Sliver version of QuestionnaireFieldItem.
///
/// Inherits validation logic from parent via RegexValidationMixin.
final class QuestionnaireSliverFieldItem extends QuestionnaireFieldItem {
  const QuestionnaireSliverFieldItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    TextEditingController localController = getAssignedTextController(
        inheritedData,
        getInitialValue(questionnaireItem));

    // Get regex validation pattern from ItemBehavioralData
    final itemData = inheritedData.rendererController.indexedItems[itemLinkId];
    final regexPattern = itemData?.regexValidationPattern;
    final regexErrorMessage = itemData?.regexValidationError;

    return SliverBaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      child: SliverToBoxAdapter(
        child: TextFormField(
          controller: localController,
          onChanged: (value) {
            final resp = FhirRendererQuestionnaireResponseUtils
                .setResponseAnswerInQuestionnaireResponse(
              inheritedData.questionnaireResponse,
              questionnaireItem,
              value.trim().isEmpty
                  ? null
                  : QuestionnaireResponseAnswer(valueX: FhirString(value)),
            );
            inheritedData.onResponseChanged(resp);
          },
          validator: (value) => validateInput(value, regexPattern, regexErrorMessage),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: questionnaireItem.type == QuestionnaireItemType.text
              ? 5
              : ((questionnaireItem.maxLength?.valueInt ?? 50) /
                      min(questionnaireItem.maxLength?.valueInt ?? 50, 50))
                  .floor(),
          minLines:
              questionnaireItem.type == QuestionnaireItemType.text ? 5 : 1,
          maxLength: questionnaireItem.maxLength?.valueInt,
          decoration: InputDecoration(
            errorMaxLines: 2,
            helperText: regexErrorMessage,
            helperMaxLines: 2,
          ),
        ),
      ),
    );
  }
}
