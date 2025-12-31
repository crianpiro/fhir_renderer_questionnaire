import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

class ListViewRenderer extends StatelessWidget {
  final Questionnaire questionnaire;
  ListViewRenderer({super.key, required this.questionnaire});

  QuestionnaireRendererController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuestionnaireListViewRenderer"),
        actions: [
          IconButton(
            onPressed: () {
              var a = controller?.getGeneratedQuestionnaireResponse();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        questionnaire: questionnaire,
        getRendererControllerInstance:
            (QuestionnaireRendererController controller) =>
                this.controller = controller,
      ),
    );
  }
}
