import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../core/data/questionnaire_renderer_data.dart';
import '../../core/extensions/mapping_extension.dart';
import '../../core/utils/fhir_renderer_questionnaire_utils.dart';
import 'questionnaire_base_item.dart';
import 'questionnaire_item_wrapper.dart';

class QuestionnaireGroupItem extends QuestionnaireBaseItem {
  const QuestionnaireGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    List<QuestionnaireItem>? items = questionnaireItem.item?.where((item) {
      QuestionnaireRendererData questionnaireRendererData =
          QuestionnaireRendererData.of(context);
      final enabled = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
        questionnaireRendererData.questionnaireResponse,
        item,
      );
      if (QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems
          .containsKey(
            item.linkId.valueString!,
          )) {
        final itemData = QuestionnaireRendererData.of(context)
            .internalController
            .indexedItems[item.linkId.valueString!]!;
        QuestionnaireRendererData.of(context)
                .internalController
                .indexedItems[item.linkId.valueString!] =
            itemData.copyWith(enabled: enabled);
      }
      return enabled;
    }).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              questionnaireItem.text?.valueString ??
                  questionnaireItem.code?.firstOrNull?.code?.valueString ??
                  "",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (items != null)
            ...(items.mapIndexed((subIndex, subItem) {
              return QuestionnaireItemWrapper(
                questionnaireItem: subItem,
                index: subIndex,
                isLastItem: items.length - 1 == subIndex,
              );
            }).toList()),
        ],
      ),
    );
  }
}
