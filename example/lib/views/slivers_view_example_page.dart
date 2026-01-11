import 'dart:developer';

import 'package:example/data/mocks.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  RendererQuestionnaireController rendererController =
      RendererQuestionnaireController(
        sliversInitialIndex: 3,
        questionnaire: example,
        forceReadOnlyView: true,
      );
}

class SliversViewExamplePage extends StatelessWidget {
  SliversViewExamplePage({super.key});

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
      body: QuestionnaireSliversViewRenderer(
        rendererController: controller.rendererController,
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
                    Flexible(
                      child: Text(
                        "${questionnaireItem.text?.valueString}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
