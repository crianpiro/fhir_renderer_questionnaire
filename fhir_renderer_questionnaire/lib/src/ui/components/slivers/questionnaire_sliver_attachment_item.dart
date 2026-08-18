import 'package:flutter/material.dart';

import '../boxes/questionnaire_attachment_item.dart';
import 'sliver_base_decorator.dart';

/// Sliver version of QuestionnaireAttachmentItem.
///
/// Wraps the attachment picker widget in a sliver-compatible container.
final class QuestionnaireSliverAttachmentItem extends QuestionnaireAttachmentItem {
  const QuestionnaireSliverAttachmentItem({
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
