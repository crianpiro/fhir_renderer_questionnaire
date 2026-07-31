import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../questionnaire_base_item.dart';
import '../questionnaire_styles.dart';
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
            // Evaluate whether this item is enabled
            // The enabled state is cached in the controller for performance
            return FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              item,
              controller: inheritedQuestionnaireRenderer.rendererController,
            );
          }).toList();

          return inheritedQuestionnaireRenderer.groupItemBuilder!(
            index,
            isLastItem,
            questionnaireItem.copyWith(item: items),
            (questionnaireItem, index) {
              // Use the factory to create the appropriate wrapper type
              // For BoxComponentFactory -> QuestionnaireItemWrapper
              // For SliverComponentFactory -> QuestionnaireSliverItemWrapper
              return factory.createItemWrapper(
                index: index,
                questionnaireItem: questionnaireItem,
                isLastItem: isLastItem,
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

      // Regex validation is implemented via FHIR extension: http://hl7.org/fhir/StructureDefinition/regex
      // See QuestionnaireFieldItem and QuestionnaireSliverFieldItem for implementation
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

      case QuestionnaireItemType.attachment:
        // File upload for binary content (images, PDFs, documents)
        if (inheritedQuestionnaireRenderer.attachmentItemBuilder != null) {
          return inheritedQuestionnaireRenderer.attachmentItemBuilder!(
            index,
            isLastItem,
            findQuestionnaireResponseItem(
              inheritedQuestionnaireRenderer.questionnaireResponse,
              itemLinkId,
            ),
            questionnaireItem,
            (attachment) {
              final resp = FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                attachment != null
                    ? QuestionnaireResponseAnswer(valueX: attachment)
                    : null,
              );

              inheritedQuestionnaireRenderer.onResponseChanged(resp);
            },
          );
        }
        return factory.createAttachmentItem(
            index, isLastItem, questionnaireItem);

      case QuestionnaireItemType.reference:
        // Reference to another FHIR resource
        if (inheritedQuestionnaireRenderer.referenceItemBuilder != null) {
          final currentResponse = findQuestionnaireResponseItem(
            inheritedQuestionnaireRenderer.questionnaireResponse,
            itemLinkId,
          );
          final existingReference =
              currentResponse?.answer?.firstOrNull?.valueReference;

          return inheritedQuestionnaireRenderer.referenceItemBuilder!(
            index,
            isLastItem,
            getAssignedTextController(
              inheritedQuestionnaireRenderer,
              existingReference?.reference?.valueString ?? '',
            ),
            getSecondaryTextController(
              inheritedQuestionnaireRenderer,
              'display',
              existingReference?.display?.valueString ?? '',
            ),
            currentResponse,
            questionnaireItem,
            (referenceString, displayName) {
              QuestionnaireResponseAnswer? answer;

              if (referenceString.trim().isNotEmpty) {
                final reference = Reference(
                  reference: FhirString(referenceString.trim()),
                  display: displayName.trim().isNotEmpty
                      ? FhirString(displayName.trim())
                      : null,
                );
                answer = QuestionnaireResponseAnswer(valueX: reference);
              }

              final resp = FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                inheritedQuestionnaireRenderer.questionnaireResponse,
                questionnaireItem,
                answer,
              );

              inheritedQuestionnaireRenderer.onResponseChanged(resp);
            },
          );
        }
        return factory.createReferenceItem(
            index, isLastItem, questionnaireItem);

      default:
        return factory.createUnimplementedItem(
          "${questionnaireItem.type}",
          isLastItem,
        );
    }
  }

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    // Cache the inherited data to avoid multiple tree traversals
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      inheritedData.questionnaireResponse,
      itemLinkId,
    );
    return Focus(
      focusNode: assignFocusNode(inheritedData),
      canRequestFocus: true,
      onFocusChange: (value) {
        if (value) {
          Scrollable.ensureVisible(context);
        }
      },
      child: Container(
        decoration: markAsRequired(inheritedData, responseItem, isRequired)
            ? QuestionnaireStyles.requiredItemDecoration(context)
            : null,
        child: IgnorePointer(
          ignoring: inheritedData.readOnly
              ? inheritedData.readOnly
              : questionnaireItem.readOnly?.valueBoolean ?? false,
          child: assignQuestionnaireWidget(inheritedData),
        ),
      ),
    );
  }
}
