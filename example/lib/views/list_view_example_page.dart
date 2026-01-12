import 'dart:developer';

import 'package:example/data/regex_validation_mock.dart';
import 'package:example/widgets/segmented_choice.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  RendererQuestionnaireController rendererController =
      RendererQuestionnaireController(questionnaire: regexValidationExample);
}

class ListViewExamplePage extends StatelessWidget {
  ListViewExamplePage({super.key});

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
      body: QuestionnaireListViewRenderer(
        rendererController: controller.rendererController,
        choiceItemBuilder: (
          index,
          isLastItem,
          selectedResponse,
          questionnaireItem,
          onAnswerOptionSelected,
        ) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${questionnaireItem.text}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SegmentedChoice<QuestionnaireAnswerOption>(
                  selectedValue:
                      questionnaireItem.answerOption
                          ?.where(
                            (item) =>
                                item.valueCoding ==
                                selectedResponse
                                    ?.answer
                                    ?.firstOrNull
                                    ?.valueCoding,
                          )
                          .firstOrNull,
                  values: questionnaireItem.answerOption!,
                  valueNameResolver:
                      (value) => "${value.valueCoding?.display?.valueString}",
                  enabled: true,
                  onSelectedValueChanged: (value) {
                    onAnswerOptionSelected(value);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
