import 'package:fhir_renderer_questionnaire/src/ui/components/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/questionnaire_base_item.dart';
import 'package:flutter/material.dart';

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
