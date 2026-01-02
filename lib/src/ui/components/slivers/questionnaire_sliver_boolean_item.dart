import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../boxes/questionnaire_boolean_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverBooleanItem extends QuestionnaireBooleanItem {
  const QuestionnaireSliverBooleanItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    final selectedResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );

    bool? selectedValue =
        selectedResponseItem?.answer?.firstOrNull?.valueBoolean?.valueBoolean;

    return SliverBaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      children: [
        SliverToBoxAdapter(
          child: RadioListTile(
            value: true,
            title: const Text("Ja"),
            groupValue: selectedValue,
            onChanged: (v) => onOptionChanged(context, v ?? false),
          ),
        ),
        SliverToBoxAdapter(
          child: RadioListTile(
            value: false,
            title: const Text("Nein"),
            groupValue: selectedValue,
            onChanged: (v) => onOptionChanged(context, v ?? false),
          ),
        ),
      ],
    );
  }
}
