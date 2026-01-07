import 'package:fhir_r4/fhir_r4.dart';
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

  Widget assignQuestionnaireWidget(BuildContext context) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        if (InheritedQuestionnaireRenderer.of(context).displayItemBuilder !=
            null) {
          return InheritedQuestionnaireRenderer.of(context).displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return QuestionnaireDisplayItem(
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
        return QuestionnaireBooleanItem(
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
        return QuestionnaireDateTimeItem(
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
            childrenAssigner: (questionnaireItem) {
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
        return QuestionnaireChoiceItem(
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
  Widget build(BuildContext context) {
    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );
    return Focus(
      focusNode: assignFocusNode(context),
      canRequestFocus: true,
      onFocusChange: (value) {
        if (value) {
          Scrollable.ensureVisible(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: markAsRequired(context, responseItem, isRequired)
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
