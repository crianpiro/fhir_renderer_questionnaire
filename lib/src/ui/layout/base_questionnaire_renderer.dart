import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/internal_questionnaire_controller.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/definitions/type_definitions.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/questionnaire_renderer_controller.dart';
import 'package:fhir_renderer_questionnaire/src/ui/renderers/list_view_renderer/questionnaire_list_view_renderer.dart';
import 'package:fhir_renderer_questionnaire/src/ui/renderers/page_view_renderer/questionnaire_page_view_renderer.dart';
import 'package:flutter/widgets.dart';

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
    questionnaireResponse = FhirRendererQuestionnaireResponseUtils
        .generateInitialQuestionnaireResponse(
      widget.questionnaire,
    );
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

        //Validar

        return questionnaireResponse;
      },
    );
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
