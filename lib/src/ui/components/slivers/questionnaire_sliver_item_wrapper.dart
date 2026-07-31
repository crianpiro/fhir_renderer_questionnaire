import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../boxes/questionnaire_item_wrapper.dart';
import '../questionnaire_styles.dart';
import '../../factories/sliver_component_factory.dart';

/// Sliver variant of QuestionnaireItemWrapper for use in CustomScrollView contexts.
///
/// Inherits the assignQuestionnaireWidget logic from the parent class but uses
/// SliverComponentFactory to create sliver-based widgets instead of box widgets.
/// Overrides only the build method to wrap items in sliver-appropriate containers.
final class QuestionnaireSliverItemWrapper extends QuestionnaireItemWrapper {
  const QuestionnaireSliverItemWrapper({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  }) : super(factory: const SliverComponentFactory());

  @override
  Widget build(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    assignDependents(inheritedData);

    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      inheritedData.questionnaireResponse,
      itemLinkId,
    );

    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Focus(
          focusNode: assignFocusNode(inheritedData),
          // width: double.infinity instead of MediaQuery sizing, so items
          // don't subscribe to MediaQuery and rebuild on keyboard animations.
          child: const SizedBox(
            height: 0,
            width: double.infinity,
          ),
        ),
      ),
      DecoratedSliver(
        decoration: (isRequired &&
                inheritedData.checkRequiredItems &&
                (responseItem?.answer == null ||
                    (responseItem?.answer?.isEmpty ?? false)))
            ? QuestionnaireStyles.requiredItemDecoration(context)
            : const BoxDecoration(),
        sliver: SliverIgnorePointer(
          ignoring: inheritedData.readOnly
              ? inheritedData.readOnly
              : questionnaireItem.readOnly?.valueBoolean ?? false,
          sliver: assignQuestionnaireWidget(inheritedData),
        ),
      )
    ]);
  }
}
