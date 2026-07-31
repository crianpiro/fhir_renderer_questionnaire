import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../boxes/questionnaire_item_wrapper.dart';
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
    assignDependents(InheritedQuestionnaireRenderer.of(context));

    final isRequired = questionnaireItem.required_?.valueBoolean ?? false;
    final responseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Focus(
          focusNode:
              assignFocusNode(InheritedQuestionnaireRenderer.of(context)),
          child: SizedBox(
            height: 0,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
      DecoratedSliver(
        decoration: BoxDecoration(
          border: (isRequired &&
                  InheritedQuestionnaireRenderer.of(
                    context,
                  ).checkRequiredItems &&
                  (responseItem?.answer == null ||
                      (responseItem?.answer?.isEmpty ?? false)))
              ? Border.all(color: Colors.red)
              : null,
        ),
        sliver: SliverIgnorePointer(
          ignoring: InheritedQuestionnaireRenderer.of(context).readOnly
              ? InheritedQuestionnaireRenderer.of(context).readOnly
              : questionnaireItem.readOnly?.valueBoolean ?? false,
          sliver: assignQuestionnaireWidget(
              InheritedQuestionnaireRenderer.of(context)),
        ),
      )
    ]);
  }
}
