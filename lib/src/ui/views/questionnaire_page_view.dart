import 'package:fhir_renderer_questionnaire/src/core/data/questionnaire_renderer_data.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_item_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:fhir_r4/fhir_r4.dart';

class QuestionnairePageView extends StatelessWidget {
  const QuestionnairePageView({super.key});

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
      return SafeArea(
        child: PageView.builder(
          controller: QuestionnaireRendererData.of(context).pageViewController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: QuestionnaireItemWrapper(
                questionnaireItem: items[index],
                index: index,
                isLastItem: items.length - 1 == index,
              ),
            );
          },
        ),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
