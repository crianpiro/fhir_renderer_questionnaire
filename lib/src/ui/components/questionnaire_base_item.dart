import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../core/data/field_behavioral_data.dart';
import '../../core/data/questionnaire_renderer_data.dart';
import '../../core/utils/fhir_renderer_questionnaire_response_utils.dart';

abstract class QuestionnaireBaseItem extends StatelessWidget {
  final QuestionnaireItem questionnaireItem;
  final int index;
  final bool isLastItem;

  const QuestionnaireBaseItem({
    super.key,
    required this.questionnaireItem,
    required this.index,
    required this.isLastItem,
  });

  QuestionnaireResponseItem? findQuestionnaireResponseItem(
    QuestionnaireResponse questionnaireResponse,
    String? id,
  ) =>
      FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
        questionnaireResponse,
        questionnaireItem.linkId.valueString,
      );

  FocusNode assignFocusNode(BuildContext context) {
    FocusNode itemFocus;
    String localId = questionnaireItem.linkId.valueString!;
    if (!QuestionnaireRendererData.of(context)
        .internalController
        .indexedItems
        .containsKey(localId)) {
      itemFocus = FocusNode();
      final currentIndex = QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems
          .length;
      QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems[localId] = FieldBehavioralData(
        index: currentIndex,
        enabled: true,
        markedRequired: false,
        focusNode: itemFocus,
      );
    } else {
      itemFocus = QuestionnaireRendererData.of(context)
          .internalController
          .indexedItems[localId]!
          .focusNode;
    }

    return itemFocus;
  }

  bool markAsRequired(BuildContext context,
      QuestionnaireResponseItem? responseItem, bool isRequired) {
    String localId = questionnaireItem.linkId.valueString!;
    if (isRequired) {
      if (QuestionnaireRendererData.of(
            context,
          ).checkRequiredItems &&
          (responseItem?.answer == null ||
              (responseItem?.answer?.isEmpty ?? false))) {
        if (QuestionnaireRendererData.of(context)
            .internalController
            .indexedItems
            .containsKey(localId)) {
          QuestionnaireRendererData.of(context)
                  .internalController
                  .indexedItems[localId] =
              QuestionnaireRendererData.of(context)
                  .internalController
                  .indexedItems[localId]!
                  .copyWith(markedRequired: true);
        }

        return true;
      }
    }
    return false;
  }
}
