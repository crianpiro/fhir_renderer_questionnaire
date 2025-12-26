import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/field_behavioral_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_base_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_boolean_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_choice_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_date_time_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_display_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_field_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_group_item.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_open_choice_item.dart';
import 'package:flutter/material.dart';

class QuestionnaireItemWrapper extends QuestionnaireBaseItem {
  const QuestionnaireItemWrapper({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  Widget assignQuestionnaireWidget(BuildContext context) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        return QuestionnaireDisplayItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.boolean:
        if (QuestionnaireRendererData.of(context).boolItemBuilder != null) {
          return QuestionnaireRendererData.of(context).boolItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              final resp = FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                QuestionnaireResponseAnswer(valueX: FhirBoolean("$answer")),
              );

              QuestionnaireRendererData.of(context).onResponseChanged(resp);
            },
          );
        }
        return QuestionnaireBooleanItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.time:
      case QuestionnaireItemType.date:
      case QuestionnaireItemType.dateTime:
        if (QuestionnaireRendererData.of(context).dateTimeItemBuilder != null) {
          return QuestionnaireRendererData.of(context).dateTimeItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              QuestionnaireRendererData.of(context).onResponseChanged(response);
            },
          );
        }
        return QuestionnaireDateTimeItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.group:
        if (QuestionnaireRendererData.of(context).groupItemBuilder != null) {
          return QuestionnaireRendererData.of(context).groupItemBuilder!(
            index,
            isLastItem,
            questionnaireItem,
          );
        }
        return QuestionnaireGroupItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.choice:
        if (QuestionnaireRendererData.of(context).choiceItemBuilder != null) {
          return QuestionnaireRendererData.of(context).choiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setAnswerOptionInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              QuestionnaireRendererData.of(context).onResponseChanged(response);
            },
          );
        }
        return QuestionnaireChoiceItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.openChoice:
        if (QuestionnaireRendererData.of(context).openChoiceItemBuilder !=
            null) {
          return QuestionnaireRendererData.of(context).openChoiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setMultipleAnswerOptionsInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              QuestionnaireRendererData.of(context).onResponseChanged(response);
            },
          );
        }
        return QuestionnaireOpenChoiceItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      //TODO: Implement the regular expressions to validate the content
      case QuestionnaireItemType.text:
      case QuestionnaireItemType.quantity:
      case QuestionnaireItemType.decimal:
      case QuestionnaireItemType.integer:
      case QuestionnaireItemType.string:
        if (QuestionnaireRendererData.of(context).fieldItemBuilder != null) {
          return QuestionnaireRendererData.of(context).fieldItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              QuestionnaireRendererData.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                answer.trim().isEmpty
                    ? null
                    : QuestionnaireResponseAnswer(
                        valueX: FhirString(answer),
                      ),
              );

              QuestionnaireRendererData.of(context).onResponseChanged(response);
            },
          );
        }
        return QuestionnaireOpenFieldItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      default:
        return Text("Unimplemented: ${questionnaireItem.type}");
    }
  }

  FocusNode assignFocusNode(BuildContext context) {
    FocusNode itemFocus;
    String localId = questionnaireItem.linkId.valueString!;
    if (!QuestionnaireRendererData.of(context)
        .internalController
        .indexedItems
        .containsKey(localId)) {
      itemFocus = FocusNode();
      final currentIndex = QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems
          .length;
      QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems[localId] = FieldBehavioralData(
        index: currentIndex,
        enabled: true,
        markedRequired: false,
        focusNode: itemFocus,
      );
    } else {
      itemFocus = QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems[localId]!
          .focusNode;
    }

    return itemFocus;
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );
    return Focus(
      focusNode: assignFocusNode(context),
      child: Container(
        decoration: BoxDecoration(
          border: (isRequired &&
                  QuestionnaireRendererData.of(
                    context,
                  ).checkRequiredItems &&
                  (responseItem?.answer == null ||
                      (responseItem?.answer?.isEmpty ?? false)))
              ? Border.all(color: Colors.red)
              : null,
        ),
        child: IgnorePointer(
          ignoring: questionnaireItem.readOnly?.valueBoolean ?? false,
          child: assignQuestionnaireWidget(context),
        ),
      ),
    );
  }
}
