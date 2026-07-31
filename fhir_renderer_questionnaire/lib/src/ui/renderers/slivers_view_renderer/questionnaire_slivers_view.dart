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
      // Only initialize keys when the list is empty (first build)
      // or when the number of items changes (items enabled/disabled)
      final needsKeyUpdate = inheritedData.rendererController.groupBundleKeys.isEmpty ||
          inheritedData.rendererController.groupBundleKeys.length != items.length;

      if (needsKeyUpdate) {
        inheritedData.rendererController.groupBundleKeys.clear();
        for (var item in items) {
          final linkId = item.linkId.valueString;
          inheritedData.rendererController.groupBundleKeys.add(
            GlobalKey(debugLabel: 'sliver_item_$linkId'),
          );
        }
      }

      return GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        // Only detect taps on empty space, not on child widgets
        behavior: HitTestBehavior.opaque,
        child: CustomScrollView(
          controller: inheritedData.rendererController.listViewScrollController,
          slivers: List.generate(items.length, (index) {
            final item = items[index];
            final globalKey = inheritedData.rendererController.groupBundleKeys[index];

            return QuestionnaireSliverItemWrapper(
              key: globalKey,
              questionnaireItem: item,
              index: index,
              isLastItem: index == items.length - 1,
            );
          }),
        ),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
