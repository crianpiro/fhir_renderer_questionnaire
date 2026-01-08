import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/sliver_base_decorator.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'questionnaire_sliver_boolean_item.dart';
import 'questionnaire_sliver_choice_item.dart';
import 'questionnaire_sliver_date_time_item.dart';
import 'questionnaire_sliver_display_item.dart';
import 'questionnaire_sliver_field_item.dart';
import 'questionnaire_sliver_group_item.dart';
import 'questionnaire_sliver_open_choice_item.dart';

final class QuestionnaireSliverItemWrapper extends QuestionnaireItemWrapper {
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
        if (InheritedQuestionnaireRenderer.of(context).displayItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return QuestionnaireSliverDisplayItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.boolean:
        if (InheritedQuestionnaireRenderer.of(context).boolItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).boolItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              final resp = FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                QuestionnaireResponseAnswer(valueX: FhirBoolean("$answer")),
              );

              InheritedQuestionnaireRenderer.of(context)
                  .onResponseChanged(resp);
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
        if (InheritedQuestionnaireRenderer.of(context).dateTimeItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context)
              .dateTimeItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              InheritedQuestionnaireRenderer.of(context)
                  .onResponseChanged(response);
            },
          );
        }
        return QuestionnaireSliverDateTimeItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.group:
        if (InheritedQuestionnaireRenderer.of(context).groupItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).groupItemBuilder!(
            index,
            isLastItem,
            questionnaireItem,
            (questionnaireItem) {
              return QuestionnaireSliverItemWrapper(
                index: index,
                questionnaireItem: questionnaireItem,
                isLastItem: isLastItem,
              );
            },
          );
        }
        return QuestionnaireSliverGroupItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.choice:
        if (InheritedQuestionnaireRenderer.of(context).choiceItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).choiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setAnswerOptionInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              InheritedQuestionnaireRenderer.of(context)
                  .onResponseChanged(response);
            },
          );
        }
        return QuestionnaireSliverChoiceItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.openChoice:
        if (InheritedQuestionnaireRenderer.of(context).openChoiceItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context)
              .openChoiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setMultipleAnswerOptionsInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              InheritedQuestionnaireRenderer.of(context)
                  .onResponseChanged(response);
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
        if (InheritedQuestionnaireRenderer.of(context).fieldItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).fieldItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                answer.trim().isEmpty
                    ? null
                    : QuestionnaireResponseAnswer(
                        valueX: FhirString(answer),
                      ),
              );

              InheritedQuestionnaireRenderer.of(context)
                  .onResponseChanged(response);
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
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
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
                  InheritedQuestionnaireRenderer.of(
                    context,
                  ).checkRequiredItems &&
                  (responseItem?.answer == null ||
                      (responseItem?.answer?.isEmpty ?? false)))
              ? Border.all(color: Colors.red)
              : null,
        ),
        sliver: SliverIgnorePointer(
          // ignoring: questionnaireItem.readOnly?.valueBoolean ?? false,
          ignoring: InheritedQuestionnaireRenderer.of(context).readOnly
              ? InheritedQuestionnaireRenderer.of(context).readOnly
              : questionnaireItem.readOnly?.valueBoolean ?? false,
          sliver: assignQuestionnaireWidget(context),
        ),
      )
    ]);
  }
}
