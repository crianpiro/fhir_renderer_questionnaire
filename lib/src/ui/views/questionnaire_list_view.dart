import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_item_wrapper.dart';
import 'package:flutter/material.dart';

class QuestionnaireListView extends StatelessWidget {
  const QuestionnaireListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<QuestionnaireItem>? items = QuestionnaireRendererData.of(context)
        .questionnaire
        .item
        ?.where(
          (i) => FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
            QuestionnaireRendererData.of(context).questionnaireResponse,
            i,
          ),
        )
        .toList();

    if (items != null) {
      return ListView.builder(
        itemCount: items.length,
        controller:
            QuestionnaireRendererData.of(context).listViewScrollController,
        itemBuilder: (context, index) {
          return QuestionnaireItemWrapper(
            questionnaireItem: items[index],
            index: index,
            isLastItem: items.length - 1 == index,
          );
        },
      );
    }

    return BaseDecorator(title: "No items to list", roundBottomBorder: false);
  }
}
