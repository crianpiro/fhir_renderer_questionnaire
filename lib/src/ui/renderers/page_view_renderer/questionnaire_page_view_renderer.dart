import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/base_questionnaire_renderer.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/questionnaire_renderer_controller.dart';
import 'package:fhir_renderer_questionnaire/src/ui/views/questionnaire_page_view.dart';
import 'package:flutter/material.dart';

class QuestionnairePageViewRenderer extends BaseQuestionnaireRenderer {
  const QuestionnairePageViewRenderer({
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
  BaseQuestionnaireState createState() => _QuestionnairePageViewRendererState();
}

class _QuestionnairePageViewRendererState extends BaseQuestionnaireState {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: QuestionnaireRendererData(
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
        onResponseChanged: onResponseChanged,
        internalController: controller,
        child: Builder(
          builder: (innerContext) {
            widget.getRendererControllerInstance(
                QuestionnaireRendererController(controller));
            return const QuestionnairePageView();
          },
        ),
      ),
    );
  }
}
