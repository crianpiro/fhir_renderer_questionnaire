import 'package:flutter/material.dart';
import 'base_decorator.dart';
import 'questionnaire_base_item.dart';

class QuestionnaireDisplayItem extends QuestionnaireBaseItem {
  const QuestionnaireDisplayItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
    );
  }
}
