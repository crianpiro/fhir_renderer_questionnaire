import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_item.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import 'questionnaire_sliver_item_wrapper.dart';

final class QuestionnaireSliverGroupItem extends QuestionnaireGroupItem {
  const QuestionnaireSliverGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    List<QuestionnaireItem>? items = getFilteredGroupItems(
        questionnaireItem, InheritedQuestionnaireRenderer.of(context));

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          title: Text(
            questionnaireItem.text?.valueString ??
                questionnaireItem.code?.firstOrNull?.code?.valueString ??
                "",
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        if (items != null)
          ...List.generate(
              items.length,
              (i) => QuestionnaireSliverItemWrapper(
                    questionnaireItem: items[i],
                    index: i,
                    isLastItem: items.length - 1 == i,
                  ))
      ],
    );
  }
}
