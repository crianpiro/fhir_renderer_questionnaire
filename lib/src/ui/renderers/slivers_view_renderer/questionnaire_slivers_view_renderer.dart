import 'package:flutter/material.dart';

import '../../../../fhir_renderer_questionnaire.dart';
import '../../../core/data/questionnaire_renderer_data.dart';
import '../../layout/base_questionnaire_renderer.dart';
import 'questionnaire_slivers_view.dart';

class QuestionnaireSliversViewRenderer extends BaseQuestionnaireRenderer {
  const QuestionnaireSliversViewRenderer({
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
  BaseQuestionnaireState createState() =>
      _QuestionnaireSliversViewRendererState();
}

class _QuestionnaireSliversViewRendererState extends BaseQuestionnaireState {
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
        builder: (innerContext) {
          widget.getRendererControllerInstance(
              QuestionnaireRendererController(controller));
          return const QuestionnaireSliversView();
        },
      ),
    );
  }
}
