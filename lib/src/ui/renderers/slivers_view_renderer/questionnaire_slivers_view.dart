import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_utils.dart';
import '../../components/boxes/base_decorator.dart';
import '../../components/slivers/questionnaire_sliver_item_wrapper.dart';

final class QuestionnaireSliversView extends StatelessWidget {
  const QuestionnaireSliversView({super.key});

  @override
  Widget build(BuildContext context) {
    List<QuestionnaireItem>? items = InheritedQuestionnaireRenderer.of(context)
        .questionnaire
        .item
        ?.where(
          (i) => FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
            InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
            i,
          ),
        )
        .toList();

    if (items != null) {
      return CustomScrollView(
        slivers: items.map((item) {
          final index = items.indexOf(item);
          return QuestionnaireSliverItemWrapper(
            questionnaireItem: item,
            index: index,
            isLastItem: index == items.length - 1,
          );
        }).toList(),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }
}
