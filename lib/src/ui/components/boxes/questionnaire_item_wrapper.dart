import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../questionnaire_base_item.dart';
import '../../factories/questionnaire_component_factory.dart';
import '../../factories/box_component_factory.dart';
import '../../../core/mixins/text_field_value_mixin.dart';

class QuestionnaireItemWrapper extends QuestionnaireBaseItem
    with TextFieldValueMixin {
  final QuestionnaireComponentFactory factory;

  const QuestionnaireItemWrapper({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    this.factory = const BoxComponentFactory(),
  });

  Widget assignQuestionnaireWidget(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer) {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.display_:
        if (inheritedQuestionnaireRenderer.displayItemBuilder != null) {
          return inheritedQuestionnaireRenderer.displayItemBuilder!(
              index, isLastItem, questionnaireItem);
        }
        return factory.createDisplayItem(index, isLastItem, questionnaireItem);

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
        return factory.createBooleanItem(index, isLastItem, questionnaireItem);

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
        return factory.createDateTimeItem(index, isLastItem, questionnaireItem);

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
                factory: factory,
              );
            },
          );
        }
        return factory.createGroupItem(index, isLastItem, questionnaireItem);

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
        return factory.createChoiceItem(index, isLastItem, questionnaireItem);

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
        return factory.createOpenChoiceItem(
            index, isLastItem, questionnaireItem);

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
              inheritedQuestionnaireRenderer,
              getInitialValue(questionnaireItem),
            ),
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
        return factory.createFieldItem(index, isLastItem, questionnaireItem);

      default:
        return factory.createUnimplementedItem(
          "${questionnaireItem.type}",
          isLastItem,
        );
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
