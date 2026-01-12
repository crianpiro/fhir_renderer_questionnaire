import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/extensions/mapping_extension.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/group_filtering_mixin.dart';
import 'questionnaire_item_wrapper.dart';

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
    List<QuestionnaireItem>? items = getFilteredGroupItems(
        questionnaireItem, InheritedQuestionnaireRenderer.of(context));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer, width: 1)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              itemTextTitle ??
                  questionnaireItem.code?.firstOrNull?.code?.valueString ??
                  "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (items != null)
            ...(items.mapIndexed((subIndex, subItem) {
              return QuestionnaireItemWrapper(
                questionnaireItem: subItem,
                index: subIndex,
                isLastItem: items.length - 1 == subIndex,
              );
            }).toList()),
        ],
      ),
    );
  }
}
