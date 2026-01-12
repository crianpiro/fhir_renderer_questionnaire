import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../questionnaire_base_item.dart';
import 'questionnaire_boolean_item.dart';
import 'questionnaire_choice_item.dart';
import 'questionnaire_date_time_item.dart';
import 'questionnaire_display_item.dart';
import 'questionnaire_field_item.dart';
import 'questionnaire_group_item.dart';
import 'questionnaire_open_choice_item.dart';

class QuestionnaireItemWrapper extends QuestionnaireBaseItem {
  const QuestionnaireItemWrapper({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  Widget assignQuestionnaireWidget(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        if (inheritedQuestionnaireRenderer.displayItemBuilder != null) {
          return inheritedQuestionnaireRenderer.displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return QuestionnaireDisplayItem(
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
              itemLinkId,
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
        return QuestionnaireBooleanItem(
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
              itemLinkId,
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
        return QuestionnaireDateTimeItem(
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
              return QuestionnaireItemWrapper(
                index: index,
                questionnaireItem: questionnaireItem,
                isLastItem: isLastItem,
              );
            },
          );
        }
        return QuestionnaireGroupItem(
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
              itemLinkId,
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
        return QuestionnaireChoiceItem(
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
              itemLinkId,
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
      case QuestionnaireItemType.url:
        if (inheritedQuestionnaireRenderer.fieldItemBuilder != null) {
          return inheritedQuestionnaireRenderer.fieldItemBuilder!(
            index,
            isLastItem,
            getAssignedTextController(
                inheritedQuestionnaireRenderer, "initialValue"),
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              itemLinkId,
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
        return QuestionnaireFieldItem(
          index: index,
          questionnaireItem: questionnaireItem,
          isLastItem: isLastItem,
        );
      default:
        return BaseDecorator(
            title: "Unimplemented type: ${questionnaireItem.type}",
            useNotImplementedStyle: true,
            roundBottomBorder: false);
    }
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );
    return Focus(
      focusNode: assignFocusNode(InheritedQuestionnaireRenderer.of(context)),
      canRequestFocus: true,
      onFocusChange: (value) {
        if (value) {
          Scrollable.ensureVisible(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: markAsRequired(InheritedQuestionnaireRenderer.of(context),
                  responseItem, isRequired)
              ? Border.all(color: Colors.red)
              : null,
        ),
        child: IgnorePointer(
          ignoring: InheritedQuestionnaireRenderer.of(context).readOnly
              ? InheritedQuestionnaireRenderer.of(context).readOnly
              : questionnaireItem.readOnly?.valueBoolean ?? false,
          child: assignQuestionnaireWidget(
              InheritedQuestionnaireRenderer.of(context)),
        ),
      ),
    );
  }
}
