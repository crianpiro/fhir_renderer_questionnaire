import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  QuestionnaireRendererController? rendererController;
}

class SliversViewExamplePage extends StatelessWidget {
  final Questionnaire questionnaire;
  SliversViewExamplePage({super.key, required this.questionnaire});

  final CubitOrBlocOrController controller = CubitOrBlocOrController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuestionnaireListViewRenderer"),
        actions: [
          IconButton(
            onPressed: () {
              final generatedQuestionnaireResponse =
                  controller.rendererController
                      ?.getGeneratedQuestionnaireResponse();

              //Do something with the generated response
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireSliversViewRenderer(
        questionnaire: questionnaire,
        getRendererControllerInstance:
            (QuestionnaireRendererController controller) =>
                this.controller.rendererController = controller,
      ),
    );
  }
}
