import 'package:flutter/material.dart';

import '../boxes/questionnaire_choice_item.dart';

final class QuestionnaireSliverChoiceItem extends QuestionnaireChoiceItem {
  const QuestionnaireSliverChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    // Reuse parent implementation and wrap in SliverToBoxAdapter
    // This ensures consistency with the box version and supports repeats property
    final boxWidget = super.buildQuestionnaireItem(context);

    return SliverToBoxAdapter(
      child: boxWidget,
    );
  }
}
