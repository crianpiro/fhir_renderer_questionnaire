import 'dart:developer';

import 'package:example/data/mocks.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  RendererQuestionnaireController rendererController =
      RendererQuestionnaireController(
        questionnaire: example,
        pageViewController: PageController(initialPage: 2),
      );
}

class PageViewExamplePage extends StatelessWidget {
  PageViewExamplePage({super.key});

  final CubitOrBlocOrController controller = CubitOrBlocOrController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuestionnairePageViewRenderer"),
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
        rendererController: controller.rendererController,
      ),
    );
  }
}
