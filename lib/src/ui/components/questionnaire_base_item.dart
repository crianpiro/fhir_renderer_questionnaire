import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../core/data/field_behavioral_data.dart';
import '../layout/inherited_questionnaire_renderer.dart';
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
    if (!InheritedQuestionnaireRenderer.of(context)
        .internalController
        .indexedItems
        .containsKey(localId)) {
      itemFocus = FocusNode();
      final currentIndex = InheritedQuestionnaireRenderer.of(context)
          .internalController
          .indexedItems
          .length;
      InheritedQuestionnaireRenderer.of(context)
          .internalController
          .indexedItems[localId] = FieldBehavioralData(
        index: currentIndex,
        enabled: true,
        markedRequired: false,
        focusNode: itemFocus,
      );
    } else {
      itemFocus = InheritedQuestionnaireRenderer.of(context)
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
      if (InheritedQuestionnaireRenderer.of(
            context,
          ).checkRequiredItems &&
          (responseItem?.answer == null ||
              (responseItem?.answer?.isEmpty ?? false))) {
        if (InheritedQuestionnaireRenderer.of(context)
            .internalController
            .indexedItems
            .containsKey(localId)) {
          InheritedQuestionnaireRenderer.of(context)
                  .internalController
                  .indexedItems[localId] =
              InheritedQuestionnaireRenderer.of(context)
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
