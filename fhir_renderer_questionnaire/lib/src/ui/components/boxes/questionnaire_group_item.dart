import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.only(bottom: 10.0),
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
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2))),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Text(
              itemTextTitle ??
                  questionnaireItem.code?.firstOrNull?.code?.valueString ??
                  "",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
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
