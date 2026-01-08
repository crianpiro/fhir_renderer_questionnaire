import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/extensions/mapping_extension.dart';
import '../../../core/utils/fhir_renderer_questionnaire_utils.dart';
import '../questionnaire_base_item.dart';
import 'questionnaire_sliver_item_wrapper.dart';

final class QuestionnaireSliverGroupItem extends QuestionnaireBaseItem {
  const QuestionnaireSliverGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    List<QuestionnaireItem>? items = questionnaireItem.item?.where((item) {
      InheritedQuestionnaireRenderer questionnaireRendererData =
          InheritedQuestionnaireRenderer.of(context);
      final enabled = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
        questionnaireRendererData.questionnaireResponse,
        item,
      );
      if (InheritedQuestionnaireRenderer.of(context)
          .rendererController
          .indexedItems
          .containsKey(
            item.linkId.valueString!,
          )) {
        final itemData = InheritedQuestionnaireRenderer.of(context)
            .rendererController
            .indexedItems[item.linkId.valueString!]!;
        InheritedQuestionnaireRenderer.of(context)
                .rendererController
                .indexedItems[item.linkId.valueString!] =
            itemData.copyWith(enabled: enabled);
      }
      return enabled;
    }).toList();

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text(questionnaireItem.text?.valueString ??
              questionnaireItem.code?.firstOrNull?.code?.valueString ??
              ""),
        ),
        if (items != null)
          ...(items.mapIndexed((subIndex, subItem) {
            return QuestionnaireSliverItemWrapper(
              questionnaireItem: subItem,
              index: subIndex,
              isLastItem: items.length - 1 == subIndex,
            );
          }).toList()),
      ],
    );
  }
}
