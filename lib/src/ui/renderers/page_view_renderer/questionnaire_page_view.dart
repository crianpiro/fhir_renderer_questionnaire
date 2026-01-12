import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/inherited_questionnaire_renderer.dart';
import 'package:flutter/material.dart';

class QuestionnairePageView extends StatelessWidget {
  const QuestionnairePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    List<QuestionnaireItem>? items = inheritedData.questionnaire.item
        ?.where(
          (i) => FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
            inheritedData.questionnaireResponse,
            i,
            controller: inheritedData.rendererController,
          ),
        )
        .toList();

    if (items != null) {
      return SafeArea(
        child: PageView.builder(
          controller: inheritedData.rendererController.pageViewController,
          itemCount: items.length,
          onPageChanged: inheritedData.onPageChanged,
          itemBuilder: (context, index) {
            final item = items[index];
            return SingleChildScrollView(
              child: QuestionnaireItemWrapper(
                key: ValueKey(item.linkId.valueString),
                questionnaireItem: item,
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
