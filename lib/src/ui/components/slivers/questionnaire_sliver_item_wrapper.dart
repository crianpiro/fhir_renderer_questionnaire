import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
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
  Widget assignQuestionnaireWidget(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        if (inheritedQuestionnaireRenderer.displayItemBuilder != null) {
          return inheritedQuestionnaireRenderer.displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return QuestionnaireSliverDisplayItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.boolean:
        if (inheritedQuestionnaireRenderer.boolItemBuilder != null) {
          return inheritedQuestionnaireRenderer.boolItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              final resp = FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                QuestionnaireResponseAnswer(valueX: FhirBoolean("$answer")),
              );

              inheritedQuestionnaireRenderer.onResponseChanged(resp);
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
        if (inheritedQuestionnaireRenderer.dateTimeItemBuilder != null) {
          return inheritedQuestionnaireRenderer.dateTimeItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              inheritedQuestionnaireRenderer.onResponseChanged(response);
            },
          );
        }
        return QuestionnaireSliverDateTimeItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.group:
        if (inheritedQuestionnaireRenderer.groupItemBuilder != null) {
          List<QuestionnaireItem>? items =
              questionnaireItem.item?.where((item) {
            InheritedQuestionnaireRenderer questionnaireRendererData =
                inheritedQuestionnaireRenderer;
            final enabled =
                FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
              questionnaireRendererData.questionnaireResponse,
              item,
            );
            if (inheritedQuestionnaireRenderer.rendererController.indexedItems
                .containsKey(
              item.linkId.valueString!,
            )) {
              final itemData = inheritedQuestionnaireRenderer
                  .rendererController.indexedItems[item.linkId.valueString!]!;
              inheritedQuestionnaireRenderer.rendererController
                      .indexedItems[item.linkId.valueString!] =
                  itemData.copyWith(enabled: enabled);
            }
            return enabled;
          }).toList();
          return inheritedQuestionnaireRenderer.groupItemBuilder!(
            index,
            isLastItem,
            questionnaireItem.copyWith(item: items),
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
        if (inheritedQuestionnaireRenderer.choiceItemBuilder != null) {
          return inheritedQuestionnaireRenderer.choiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setAnswerOptionInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              inheritedQuestionnaireRenderer.onResponseChanged(response);
            },
          );
        }
        return QuestionnaireSliverChoiceItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      case QuestionnaireItemType.openChoice:
        if (inheritedQuestionnaireRenderer.openChoiceItemBuilder != null) {
          return inheritedQuestionnaireRenderer.openChoiceItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answerOption) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setMultipleAnswerOptionsInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                answerOption,
              );
              inheritedQuestionnaireRenderer.onResponseChanged(response);
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
        if (inheritedQuestionnaireRenderer.fieldItemBuilder != null) {
          return inheritedQuestionnaireRenderer.fieldItemBuilder!(
            index,
            isLastItem,
            //TODO
            TextEditingController(),
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              questionnaireItem.linkId.valueString,
            ),
            questionnaireItem,
            (answer) {
              QuestionnaireResponse response =
                  FhirRendererQuestionnaireResponseUtils
                      .setResponseAnswerInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                answer.trim().isEmpty
                    ? null
                    : QuestionnaireResponseAnswer(
                        valueX: FhirString(answer),
                      ),
              );

              inheritedQuestionnaireRenderer.onResponseChanged(response);
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
          focusNode:
              assignFocusNode(InheritedQuestionnaireRenderer.of(context)),
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
          sliver: assignQuestionnaireWidget(
              InheritedQuestionnaireRenderer.of(context)),
        ),
      )
    ]);
  }
}
