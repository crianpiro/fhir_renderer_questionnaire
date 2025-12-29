import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_utils.dart';
import '../../components/boxes/base_decorator.dart';
import '../../components/boxes/questionnaire_item_wrapper.dart';

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

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
