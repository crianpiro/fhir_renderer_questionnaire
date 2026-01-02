import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  QuestionnaireRendererController? rendererController;
}

class ListViewExamplePage extends StatelessWidget {
  final Questionnaire questionnaire;
  ListViewExamplePage({super.key, required this.questionnaire});

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
      body: QuestionnaireListViewRenderer(
        questionnaire: questionnaire,
        getRendererControllerInstance:
            (QuestionnaireRendererController controller) =>
                this.controller.rendererController = controller,
        // choiceItemBuilder: (
        //   index,
        //   isLastItem,
        //   selectedResponse,
        //   questionnaireItem,
        //   onAnswerOptionSelected,
        // ) {
        //   return Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "${questionnaireItem.text}",
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        //         ),
        //         SegmentedChoice<QuestionnaireAnswerOption>(
        //           selectedValue:
        //               questionnaireItem.answerOption
        //                   ?.where(
        //                     (item) =>
        //                         item.valueCoding ==
        //                         selectedResponse
        //                             ?.answer
        //                             ?.firstOrNull
        //                             ?.valueCoding,
        //                   )
        //                   .firstOrNull,
        //           values: questionnaireItem.answerOption!,
        //           valueNameResolver:
        //               (value) => "${value.valueCoding?.display?.valueString}",
        //           enabled: true,
        //           onSelectedValueChanged: (value) {
        //             onAnswerOptionSelected(value);
        //           },
        //         ),
        //       ],
        //     ),
        //   );
        // },
      ),
    );
  }
}
