import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/slivers/questionnaire_sliver_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/inherited_questionnaire_renderer.dart';
import 'package:flutter/material.dart';

class QuestionnaireSliversView extends StatelessWidget {
  const QuestionnaireSliversView({super.key});

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
      // Clear old keys before adding new ones
      inheritedData.rendererController.groupBundleKeys.clear();

      return CustomScrollView(
        controller: inheritedData.rendererController.listViewScrollController,
        slivers: List.generate(items.length, (index) {
          final item = items[index];
          final linkId = item.linkId.valueString;
          final globalKey = GlobalKey(debugLabel: 'sliver_item_$linkId');
          inheritedData.rendererController.groupBundleKeys.add(globalKey);

          return QuestionnaireSliverItemWrapper(
            key: globalKey,
            questionnaireItem: item,
            index: index,
            isLastItem: index == items.length - 1,
          );
        }),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
