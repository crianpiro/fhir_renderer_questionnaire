import 'package:flutter/material.dart';
import '../boxes/questionnaire_display_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverDisplayItem extends QuestionnaireDisplayItem {
  const QuestionnaireSliverDisplayItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    return SliverBaseDecorator(
      title: questionnaireItem.text,
      roundBottomBorder: isLastItem,
    );
  }
}
