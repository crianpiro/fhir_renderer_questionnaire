import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/internal_questionnaire_controller.dart';
import 'package:fhir_renderer_questionnaire/src/core/definitions/type_definitions.dart';
import 'package:flutter/material.dart';

class QuestionnaireRendererData extends InheritedWidget {
  const QuestionnaireRendererData({
    super.key,
    required this.questionnaireResponse,
    required this.checkRequiredItems,
    required this.internalController,
    required this.onResponseChanged,
    required this.questionnaire,
    required super.child,
    this.choiceItemBuilder,
    this.openChoiceItemBuilder,
    this.groupItemBuilder,
    this.fieldItemBuilder,
    this.dateTimeItemBuilder,
    this.boolItemBuilder,
    this.displayItemBuilder,
    this.pageViewController,
    this.listViewScrollController,
  });

  final bool checkRequiredItems;

  final Questionnaire questionnaire;

  final InternalQuestionnaireController internalController;

  final QuestionnaireResponse questionnaireResponse;

  final PageController? pageViewController;

  final ScrollController? listViewScrollController;

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

  static QuestionnaireRendererData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<QuestionnaireRendererData>();
  }

  static QuestionnaireRendererData of(BuildContext context) {
    final QuestionnaireRendererData? result = maybeOf(context);
    assert(result != null, 'No QuestionnaireRendererData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(QuestionnaireRendererData oldWidget) =>
      questionnaire != oldWidget.questionnaire ||
      questionnaireResponse != oldWidget.questionnaireResponse ||
      checkRequiredItems != oldWidget.checkRequiredItems ||
      choiceItemBuilder != oldWidget.choiceItemBuilder ||
      fieldItemBuilder != oldWidget.fieldItemBuilder ||
      groupItemBuilder != oldWidget.groupItemBuilder ||
      dateTimeItemBuilder != oldWidget.dateTimeItemBuilder ||
      boolItemBuilder != oldWidget.boolItemBuilder ||
      displayItemBuilder != oldWidget.displayItemBuilder ||
      openChoiceItemBuilder != oldWidget.openChoiceItemBuilder;
}
