import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../questionnaire_base_item.dart';
import '../questionnaire_styles.dart';
import '../../../core/extensions/fhir_extensions.dart';
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
          borderRadius: QuestionnaireStyles.cardRadius,
          color: Theme.of(context).colorScheme.surface,
          boxShadow: QuestionnaireStyles.cardShadow(context)),
      child: ExpansionTile(
        shape: const Border(),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        initiallyExpanded: true,
        title: QuestionnaireStyles.groupTitleRow(context,
            title: questionnaireItem.displayTitle),
        children: [
          QuestionnaireStyles.groupHeaderDivider(context),
          if (items != null)
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) QuestionnaireStyles.childDivider(context),
              QuestionnaireItemWrapper(
                questionnaireItem: items[i],
                index: i,
                isLastItem: items.length - 1 == i,
              ),
            ],
        ],
      ),
    );
  }
}
