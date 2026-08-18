import 'package:flutter/material.dart';

import '../boxes/questionnaire_reference_item.dart';
import 'sliver_base_decorator.dart';

/// Sliver version of QuestionnaireReferenceItem.
///
/// Wraps the reference input widget in a sliver-compatible container.
final class QuestionnaireSliverReferenceItem extends QuestionnaireReferenceItem {
  const QuestionnaireSliverReferenceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final boxWidget = super.buildQuestionnaireItem(context);

    return SliverBaseDecorator(
      title: questionnaireItem.text,
      roundBottomBorder: isLastItem,
      child: SliverToBoxAdapter(
        child: boxWidget,
      ),
    );
  }
}
