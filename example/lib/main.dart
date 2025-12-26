import 'package:example/mocks.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final abc = mockAnamneseQuestionnaire.toJsonString();
    return MaterialApp(
      title: 'FHIR Questionnaire Renderer',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fhir Questionnaire Builder"),
          actions: [
            IconButton(
              onPressed: () {
                CubitA.handler?.getGeneratedQuestionnaireResponse;
              },
              icon: Icon(Icons.abc),
            ),
          ],
        ),
        body: QuestionnairePageViewRenderer(
          questionnaire: mockAnamneseQuestionnaire,
          getRendererControllerInstance: (handler) {
            CubitA.handler = handler;
          },
        ),
      ),
    );
  }
}

class CubitA {
  static QuestionnaireRendererController? handler;
}
