import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/group_filtering_mixin.dart';
import 'questionnaire_item_wrapper.dart';

/// Collapsible group item rendered as a Material [ExpansionTile].
///
/// Alternative to [QuestionnaireGroupItem] for scenarios where users benefit
/// from collapsing long sections of a questionnaire. Enabled via the
/// `useExpansibleGroups` flag on [BoxComponentFactory] or supported renderers
/// (e.g. [QuestionnaireListViewRenderer]). The tile starts expanded and
/// filters nested items through [GroupFilteringMixin] so `enableWhen` rules
/// are honored.
class QuestionnaireExpansibleGroupItem extends QuestionnaireBaseItem
    with GroupFilteringMixin {
  const QuestionnaireExpansibleGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    List<QuestionnaireItem>? items = getFilteredGroupItems(
        questionnaireItem, InheritedQuestionnaireRenderer.of(context));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(2, 2),
                color:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3))
          ]),
      child: ExpansionTile(
        shape: const Border(),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        initiallyExpanded: true,
        title: Text(
          itemTextTitle ??
              questionnaireItem.code?.firstOrNull?.code?.valueString ??
              "",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        children: [
          if (items != null)
            ...List.generate(
                items.length,
                (i) => QuestionnaireItemWrapper(
                      questionnaireItem: items[i],
                      index: i,
                      isLastItem: items.length - 1 == i,
                    )),
        ],
      ),
    );
  }
}
