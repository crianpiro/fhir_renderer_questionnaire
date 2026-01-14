import 'package:flutter/material.dart';

import '../boxes/questionnaire_open_choice_item.dart';

final class QuestionnaireSliverOpenChoiceItem
    extends QuestionnaireOpenChoiceItem {
  const QuestionnaireSliverOpenChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    // Get the base widgets from parent implementation
    final boxWidget = super.buildQuestionnaireItem(context);

    // Extract children from the BaseDecorator and wrap each in SliverToBoxAdapter
    // Since BaseDecorator uses Column with children, we need to extract them
    // The parent returns a BaseDecorator with children as a list of widgets
    final baseDecorator = boxWidget;

    // For sliver rendering, we need to wrap the entire box widget in a sliver
    return SliverToBoxAdapter(
      child: baseDecorator,
    );
  }
}
