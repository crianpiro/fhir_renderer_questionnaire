import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/widgets.dart';

import '../../../fhir_renderer_questionnaire.dart';
import '../../core/controllers/internal_questionnaire_controller.dart';
import '../../core/data/questionnaire_renderer_data.dart';
import '../../core/definitions/type_definitions.dart';
import '../../core/utils/fhir_renderer_questionnaire_response_utils.dart';

abstract class BaseQuestionnaireRenderer extends StatefulWidget {
  const BaseQuestionnaireRenderer({
    super.key,
    required this.questionnaire,
    required this.getRendererControllerInstance,
    this.choiceItemBuilder,
    this.openChoiceItemBuilder,
    this.fieldItemBuilder,
    this.dateTimeItemBuilder,
    this.groupItemBuilder,
    this.boolItemBuilder,
    this.displayItemBuilder,
  });

  final Questionnaire questionnaire;
  final void Function(QuestionnaireRendererController controller)
      getRendererControllerInstance;

  final QuestionnaireChoiceWidgetBuilder? choiceItemBuilder;
  final QuestionnaireChoiceWidgetBuilder? openChoiceItemBuilder;
  final QuestionnaireFieldWidgetBuilder? fieldItemBuilder;
  final QuestionnaireDateTimeWidgetBuilder? dateTimeItemBuilder;
  final QuestionnaireGroupWidgetBuilder? groupItemBuilder;
  final QuestionnaireBooleanWidgetBuilder? boolItemBuilder;
  final QuestionnaireDisplayWidgetBuilder? displayItemBuilder;

  @override
  BaseQuestionnaireState createState() => BaseQuestionnaireState();
}

class BaseQuestionnaireState extends State<BaseQuestionnaireRenderer> {
  late QuestionnaireResponse questionnaireResponse;
  late InternalQuestionnaireController controller;
  bool checkRequiredItems = false;

  QuestionnaireResponse? generateQuestionnaireResponse() {
    return QuestionnaireRendererData.of(context).questionnaireResponse;
  }

  void onResponseChanged(QuestionnaireResponse updatedQuestionnaireResponse) {
    setState(() {
      questionnaireResponse = updatedQuestionnaireResponse;
    });
  }

  @override
  void didChangeDependencies() {
    // questionnaireResponse = FhirRendererQuestionnaireResponseUtils
    //     .generateInitialQuestionnaireResponse(
    //   widget.questionnaire,
    // );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller = InternalQuestionnaireController(
      listViewScrollController:
          (this is QuestionnaireListViewRenderer) ? PageController() : null,
      pageViewController:
          (this is QuestionnairePageViewRenderer) ? PageController() : null,
      generateQuestionnaireResponse: () {
        setState(() {
          checkRequiredItems = true;
        });

        //Add the markAsRequired here instead of in building time.
        if (controller.indexedItems.isNotEmpty) {
          for (var entry in controller.indexedItems.entries) {
            if (entry.value.markedRequired) {
              entry.value.focusNode.requestFocus();
              break;
            }
          }
        }

        return questionnaireResponse;
      },
    );
    widget.getRendererControllerInstance(
        QuestionnaireRendererController(controller));
    questionnaireResponse = FhirRendererQuestionnaireResponseUtils
        .generateInitialQuestionnaireResponse(
      widget.questionnaire,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("State not implemented");
  }
}
