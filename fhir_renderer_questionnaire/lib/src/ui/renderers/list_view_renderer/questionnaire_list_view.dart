import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/factories/box_component_factory.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/inherited_questionnaire_renderer.dart';
import 'package:flutter/material.dart';

class QuestionnaireListView extends StatelessWidget {
  final bool useExpansibleGroups;
  const QuestionnaireListView({super.key, this.useExpansibleGroups = false});

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
      return GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        // Only detect taps on empty space, not on child widgets
        behavior: HitTestBehavior.opaque,
        child: ListView.builder(
          itemCount: items.length,
          controller: inheritedData.rendererController.listViewScrollController,
          itemBuilder: (context, index) {
            final item = items[index];
            return QuestionnaireItemWrapper(
              key: ValueKey(item.linkId.valueString),
              factory:
                  BoxComponentFactory(useExpansibleGroups: useExpansibleGroups),
              questionnaireItem: item,
              index: index,
              isLastItem: items.length - 1 == index,
            );
          },
        ),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
