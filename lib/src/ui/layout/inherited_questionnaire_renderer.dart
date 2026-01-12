import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/renderer_questionnaire_controller.dart';
import 'package:fhir_renderer_questionnaire/src/core/definitions/type_definitions.dart';
import 'package:flutter/material.dart';

final class InheritedQuestionnaireRenderer extends InheritedWidget {
  const InheritedQuestionnaireRenderer({
    super.key,
    required this.questionnaireResponse,
    required this.checkRequiredItems,
    required this.rendererController,
    required this.onResponseChanged,
    required this.questionnaire,
    required super.child,
    this.choiceItemBuilder,
    this.onPageChanged,
    this.openChoiceItemBuilder,
    this.groupItemBuilder,
    this.fieldItemBuilder,
    this.dateTimeItemBuilder,
    this.boolItemBuilder,
    this.displayItemBuilder,
    this.readOnly = false,
  });

  final bool checkRequiredItems;

  final bool readOnly;

  final Questionnaire questionnaire;

  final RendererQuestionnaireController rendererController;

  final QuestionnaireResponse questionnaireResponse;

  final void Function(int)? onPageChanged;

  final QuestionnaireBooleanWidgetBuilder? boolItemBuilder;

  final QuestionnaireDisplayWidgetBuilder? displayItemBuilder;

  final QuestionnaireGroupWidgetBuilder? groupItemBuilder;

  final QuestionnaireFieldWidgetBuilder? fieldItemBuilder;

  final QuestionnaireChoiceWidgetBuilder? choiceItemBuilder;

  final QuestionnaireDateTimeWidgetBuilder? dateTimeItemBuilder;

  final QuestionnaireChoiceWidgetBuilder? openChoiceItemBuilder;

  final void Function(QuestionnaireResponse response) onResponseChanged;

  QuestionnaireResponse generateQuestionnaireResponse() {
    return questionnaireResponse;
  }

  static InheritedQuestionnaireRenderer? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedQuestionnaireRenderer>();
  }

  static InheritedQuestionnaireRenderer of(BuildContext context) {
    final InheritedQuestionnaireRenderer? result = maybeOf(context);
    assert(result != null, 'No QuestionnaireRendererData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedQuestionnaireRenderer oldWidget) {
    // Use identical() for questionnaireResponse to only notify on actual object replacement,
    // not on copyWith() modifications. This reduces unnecessary rebuilds.
    // Most other fields are stable across rebuilds, so we can safely check them.
    return !identical(questionnaire, oldWidget.questionnaire) ||
        readOnly != oldWidget.readOnly ||
        !identical(rendererController, oldWidget.rendererController) ||
        !identical(questionnaireResponse, oldWidget.questionnaireResponse) ||
        checkRequiredItems != oldWidget.checkRequiredItems;
    // Note: Builder functions are intentionally excluded from this check.
    // They are typically stable across rebuilds, and checking them would cause
    // unnecessary rebuilds when lambdas are recreated. If builders change,
    // the parent widget will rebuild anyway.
  }
}
