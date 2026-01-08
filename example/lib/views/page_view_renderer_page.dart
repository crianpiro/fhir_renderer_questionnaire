import 'dart:developer';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  RendererQuestionnaireController rendererController =
      RendererQuestionnaireController();
}

class CustomQuestionnaireControlller extends RendererQuestionnaireController {}

class PageViewExamplePage extends StatelessWidget {
  final Questionnaire questionnaire;
  PageViewExamplePage({super.key, required this.questionnaire});

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
                  controller.rendererController.generateQuestionnaireResponse();

              //Do something with the generated response
              log(generatedQuestionnaireResponse.toString());
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnairePageViewRenderer(
        questionnaire: questionnaire,
        rendererController: controller.rendererController,
      ),
    );
  }
}
