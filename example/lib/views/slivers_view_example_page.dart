import 'dart:developer';

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
              log(generatedQuestionnaireResponse?.toString() ?? "No response");
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
        groupItemBuilder: (
          index,
          isLastItem,
          questionnaireItem,
          childrenAssigner,
        ) {
          return SliverMainAxisGroup(
            slivers: [
              SliverAppBar(
                key: Key("${questionnaireItem.linkId.valueString}"),
                pinned: true,
                toolbarHeight: 50,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(Icons.title),
                    ),
                    Text("${questionnaireItem.text?.valueString}"),
                  ],
                ),
              ),
              if (questionnaireItem.item != null)
                DecoratedSliver(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverMainAxisGroup(
                      slivers:
                          questionnaireItem.item!.map((question) {
                            return DecoratedSliver(
                              decoration: BoxDecoration(
                                border: Border(
                                  top:
                                      question.item !=
                                              questionnaireItem.item!.first.item
                                          ? const BorderSide(
                                            color: Colors.black,
                                            width: 0.5,
                                          )
                                          : BorderSide.none,
                                ),
                              ),
                              sliver: childrenAssigner(question),
                            );
                          }).toList(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
