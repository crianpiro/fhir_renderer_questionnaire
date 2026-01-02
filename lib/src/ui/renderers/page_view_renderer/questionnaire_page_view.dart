import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:flutter/material.dart';

import 'package:fhir_r4/fhir_r4.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_utils.dart';
import '../../components/boxes/questionnaire_item_wrapper.dart';

final class QuestionnairePageView extends StatelessWidget {
  const QuestionnairePageView({super.key});

  @override
  Widget build(BuildContext context) {
    List<QuestionnaireItem>? items = InheritedQuestionnaireRenderer.of(context)
        .questionnaire
        .item
        ?.where(
          (i) => FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
            InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
            i,
          ),
        )
        .toList();

    if (items != null) {
      return SafeArea(
        child: PageView.builder(
          controller:
              InheritedQuestionnaireRenderer.of(context).pageViewController,
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
