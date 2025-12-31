import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/sliver_base_decorator.dart';
import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'questionnaire_sliver_boolean_item.dart';
import 'questionnaire_sliver_choice_item.dart';
import 'questionnaire_sliver_date_time_item.dart';
import 'questionnaire_sliver_display_item.dart';
import 'questionnaire_sliver_field_item.dart';
import 'questionnaire_sliver_group_item.dart';
import 'questionnaire_sliver_open_choice_item.dart';

class QuestionnaireSliverItemWrapper extends QuestionnaireItemWrapper {
  const QuestionnaireSliverItemWrapper({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget assignQuestionnaireWidget(BuildContext context) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        if (QuestionnaireRendererData.of(context).displayItemBuilder != null) {
          return QuestionnaireRendererData.of(context).displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return QuestionnaireSliverDisplayItem(
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
        return QuestionnaireSliverBooleanItem(
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
        return QuestionnaireSliverDateTimeItem(
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
        return QuestionnaireSliverGroupItem(
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
        return QuestionnaireSliverChoiceItem(
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
        return QuestionnaireSliverOpenChoiceItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.text:
      case QuestionnaireItemType.quantity:
      case QuestionnaireItemType.decimal:
      case QuestionnaireItemType.integer:
      case QuestionnaireItemType.url:
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
        return QuestionnaireSliverFieldItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      default:
        return SliverBaseDecorator(
          title: "Unimplemented type: ${questionnaireItem.type}",
          useNotImplementedStyle: true,
          roundBottomBorder: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );

    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Focus(
          focusNode: assignFocusNode(context),
          child: SizedBox(
            height: 0,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
      DecoratedSliver(
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
        sliver: SliverIgnorePointer(
          ignoring: questionnaireItem.readOnly?.valueBoolean ?? false,
          sliver: assignQuestionnaireWidget(context),
        ),
      )
    ]);
  }
}
