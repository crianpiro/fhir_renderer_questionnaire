import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../../../core/mixins/choice_base_mixin.dart';
import '../../../core/mixins/choice_widget_builder_mixin.dart';

class QuestionnaireChoiceItem extends QuestionnaireBaseItem
    with ChoiceBaseMixin, ChoiceWidgetBuilderMixin {
  const QuestionnaireChoiceItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final repeats = questionnaireItem.repeats?.valueBoolean ?? false;

    final selectedResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    return BaseDecorator(
      roundBottomBorder: isLastItem,
      title: itemTextTitle,
      children: buildOptionWidgets(
        context: context,
        questionnaireItem: questionnaireItem,
        selectedResponseItem: selectedResponseItem,
        repeats: repeats,
      ),
    );
  }
}
