import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/material.dart';

import '../../../core/mixins/text_field_value_mixin.dart';
import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/choice_base_mixin.dart';
import '../../../core/mixins/open_choice_value_mixin.dart';
import '../../../core/mixins/choice_widget_builder_mixin.dart';

class QuestionnaireOpenChoiceItem extends QuestionnaireBaseItem
    with
        ChoiceBaseMixin,
        OpenChoiceValueMixin,
        ChoiceWidgetBuilderMixin,
        TextFieldValueMixin {
  const QuestionnaireOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final InheritedQuestionnaireRenderer questionnaireRendererData =
        InheritedQuestionnaireRenderer.of(context);
    final repeats = questionnaireItem.repeats ?? false;

    final selectedResponseItem = findQuestionnaireResponseItem(
      questionnaireRendererData.questionnaireResponse,
      itemLinkId,
    );

    // Get custom text value if exists
    final customTextValue = getCustomTextValue(selectedResponseItem);

    // Build option widgets using shared mixin
    final optionWidgets = buildOptionWidgets(
      context: context,
      questionnaireItem: questionnaireItem,
      selectedResponseItem: selectedResponseItem,
      repeats: repeats,
    );

    // Add custom text field for open-choice
    final widgets = [
      ...optionWidgets,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          initialValue: customTextValue,
          decoration: getOutlineInputDecoration.copyWith(
            labelText: repeats ? 'Other (additional answer)' : 'Other',
            hintText: 'Enter custom answer',
          ),
          onChanged: (value) => _updateCustomText(
            questionnaireRendererData,
            value,
            repeats,
          ),
        ),
      ),
    ];

    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: questionnaireItem.text,
      children: widgets,
    );
  }

  void _updateCustomText(
    InheritedQuestionnaireRenderer inheritedData,
    String value,
    bool repeats,
  ) {
    if (value.trim().isEmpty) {
      // Clear custom text answer
      final resp = _removeCustomTextAnswer(inheritedData.questionnaireResponse);
      inheritedData.onResponseChanged(resp);
    } else {
      // Add/update custom text answer
      final answer = QuestionnaireResponseAnswer(
        valueString: value.trim(),
      );

      if (repeats) {
        // For multi-select, need to preserve existing coding answers and add/update string
        final resp = _addOrUpdateStringAnswer(
          inheritedData.questionnaireResponse,
          value.trim(),
        );
        inheritedData.onResponseChanged(resp);
      } else {
        // For single-select, replace all answers with just the string
        final resp = FhirRendererQuestionnaireResponseUtils
            .setResponseAnswerInQuestionnaireResponse(
          inheritedData.questionnaireResponse,
          questionnaireItem,
          answer,
        );
        inheritedData.onResponseChanged(resp);
      }
    }
  }

  QuestionnaireResponse _addOrUpdateStringAnswer(
    QuestionnaireResponse response,
    String value,
  ) {
    final responseItem = findQuestionnaireResponseItem(response, itemLinkId);

    // Collect existing coding answers
    final codingAnswers = responseItem?.answer
            ?.where((answer) => answer.valueCoding != null)
            .toList() ??
        [];

    // Add/update string answer
    final stringAnswer = QuestionnaireResponseAnswer(
      valueString: value,
    );

    final allAnswers = [...codingAnswers, stringAnswer];

    // Create updated response item
    if (responseItem != null) {
      final updatedItem = responseItem.copyWith(answer: allAnswers);
      return _replaceResponseItem(response, updatedItem);
    } else {
      // Create new response item
      return FhirRendererQuestionnaireResponseUtils
          .setResponseAnswerInQuestionnaireResponse(
        response,
        questionnaireItem,
        stringAnswer,
      );
    }
  }

  QuestionnaireResponse _removeCustomTextAnswer(
      QuestionnaireResponse response) {
    final responseItem = findQuestionnaireResponseItem(response, itemLinkId);

    if (responseItem == null) return response;

    // Remove string answers, keep coding answers
    final filteredAnswers = responseItem.answer
        ?.where((answer) => answer.valueString == null)
        .toList();

    if (filteredAnswers == null || filteredAnswers.isEmpty) {
      // No answers left, remove the response item
      return FhirRendererQuestionnaireResponseUtils
          .setResponseAnswerInQuestionnaireResponse(
        response,
        questionnaireItem,
        null,
      );
    }

    // Update with filtered answers
    final updatedItem = responseItem.copyWith(answer: filteredAnswers);
    return _replaceResponseItem(response, updatedItem);
  }

  QuestionnaireResponse _replaceResponseItem(
    QuestionnaireResponse response,
    QuestionnaireResponseItem updatedItem,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

    if (response.item != null) {
      for (final item in response.item!) {
        if (item.linkId == updatedItem.linkId) {
          modifiedItems.add(updatedItem);
        } else if (item.item != null) {
          modifiedItems.add(_replaceInNestedItems(item, updatedItem));
        } else {
          modifiedItems.add(item);
        }
      }
    }

    return response.copyWith(item: modifiedItems);
  }

  QuestionnaireResponseItem _replaceInNestedItems(
    QuestionnaireResponseItem parent,
    QuestionnaireResponseItem updatedItem,
  ) {
    if (parent.linkId == updatedItem.linkId) {
      return updatedItem;
    }

    if (parent.item != null) {
      final modifiedChildren = <QuestionnaireResponseItem>[];
      for (final child in parent.item!) {
        modifiedChildren.add(_replaceInNestedItems(child, updatedItem));
      }
      return parent.copyWith(item: modifiedChildren);
    }

    return parent;
  }
}
