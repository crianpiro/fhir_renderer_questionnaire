import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../layout/base_questionnaire_renderer.dart';
import 'questionnaire_list_view.dart';

class QuestionnaireListViewRenderer extends BaseQuestionnaireRenderer {
  const QuestionnaireListViewRenderer({
    required super.getRendererControllerInstance,
    required super.questionnaire,
    super.choiceItemBuilder,
    super.openChoiceItemBuilder,
    super.fieldItemBuilder,
    super.dateTimeItemBuilder,
    super.groupItemBuilder,
    super.boolItemBuilder,
    super.displayItemBuilder,
    super.key,
  });

  @override
  BaseQuestionnaireState createState() => _QuestionnaireListViewRendererState();
}

class _QuestionnaireListViewRendererState extends BaseQuestionnaireState {
  @override
  Widget build(BuildContext context) {
    return QuestionnaireRendererData(
      questionnaireResponse: questionnaireResponse,
      questionnaire: widget.questionnaire,
      checkRequiredItems: checkRequiredItems,
      choiceItemBuilder: widget.choiceItemBuilder,
      openChoiceItemBuilder: widget.openChoiceItemBuilder,
      fieldItemBuilder: widget.fieldItemBuilder,
      groupItemBuilder: widget.groupItemBuilder,
      dateTimeItemBuilder: widget.dateTimeItemBuilder,
      boolItemBuilder: widget.boolItemBuilder,
      displayItemBuilder: widget.displayItemBuilder,
      internalController: controller,
      onResponseChanged: onResponseChanged,
      child: Builder(
        builder: (context) {
          return const QuestionnaireListView();
        },
      ),
    );
  }
}
