import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../boxes/questionnaire_boolean_item.dart';
import '../questionnaire_styles.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverBooleanItem extends QuestionnaireBooleanItem {
  const QuestionnaireSliverBooleanItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final selectedResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    bool? selectedValue =
        getInitialOrSelectedValue(selectedResponseItem, questionnaireItem);

    return SliverBaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      children: [
        SliverToBoxAdapter(
          child: RadioListTile(
            value: true,
            title: const Text("Yes"),
            groupValue: selectedValue,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: const RoundedRectangleBorder(
                borderRadius: QuestionnaireStyles.cardRadius),
            onChanged: (v) => onOptionChanged(context, v ?? false),
          ),
        ),
        SliverToBoxAdapter(
          child: RadioListTile(
            value: false,
            title: const Text("No"),
            groupValue: selectedValue,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: const RoundedRectangleBorder(
                borderRadius: QuestionnaireStyles.cardRadius),
            onChanged: (v) => onOptionChanged(context, v ?? false),
          ),
        ),
      ],
    );
  }
}
