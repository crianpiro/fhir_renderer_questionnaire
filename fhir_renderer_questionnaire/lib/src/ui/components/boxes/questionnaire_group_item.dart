import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/group_filtering_mixin.dart';
import 'questionnaire_group_segments.dart';

/// Default group item: the whole group card built as a single widget.
///
/// Stacks the same segments the list view renderer emits as individual entries
/// (see [QuestionnaireGroupHeader] and [QuestionnaireGroupChild]), so the card's
/// look lives in one place.
class QuestionnaireGroupItem extends QuestionnaireBaseItem
    with GroupFilteringMixin {
  const QuestionnaireGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final List<QuestionnaireItem> items = getFilteredGroupItems(
            questionnaireItem, InheritedQuestionnaireRenderer.of(context)) ??
        const <QuestionnaireItem>[];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuestionnaireGroupHeader(
          group: questionnaireItem,
          hasChildren: items.isNotEmpty,
        ),
        for (var i = 0; i < items.length; i++)
          QuestionnaireGroupChild(
            questionnaireItem: items[i],
            index: i,
            isLastChild: items.length - 1 == i,
          ),
      ],
    );
  }
}
