import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

class ListViewRenderer extends StatelessWidget {
  final Questionnaire questionnaire;
  const ListViewRenderer({super.key, required this.questionnaire});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QuestionnaireListViewRenderer")),
      body: QuestionnaireListViewRenderer(
        questionnaire: questionnaire,
        getRendererControllerInstance:
            (QuestionnaireRendererController controller) {},
      ),
    );
  }
}
