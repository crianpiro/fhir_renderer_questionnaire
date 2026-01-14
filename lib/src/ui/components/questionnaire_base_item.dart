import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../../core/data/item_behavioral_data.dart';
import '../../core/extensions/fhir_extensions.dart';
import '../layout/inherited_questionnaire_renderer.dart';
import '../../core/utils/fhir_renderer_questionnaire_utils.dart';
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
        itemLinkId,
      );

  String? get itemLinkId => questionnaireItem.linkId.valueString;
  String? get itemTextTitle => questionnaireItem.text?.valueString;

  FocusNode assignFocusNode(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer) {
    return inheritedQuestionnaireRenderer
        .rendererController.indexedItems[itemLinkId]!.focusNode;
  }

  bool isItemEnabled(
      QuestionnaireResponse questionnaireResponse, QuestionnaireItem item) {
    return FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
      questionnaireResponse,
      item,
    );
  }

  TextEditingController getAssignedTextController(
      InheritedQuestionnaireRenderer questionnaireRendererData,
      String initialValue) {
    TextEditingController controller;
    if (questionnaireRendererData.rendererController.indexedItems.containsKey(
          itemLinkId,
        ) &&
        questionnaireRendererData
                .rendererController.indexedItems[itemLinkId]!.textController ==
            null) {
      final currentResponseItem = findQuestionnaireResponseItem(
        questionnaireRendererData.questionnaireResponse,
        itemLinkId,
      );

      controller = TextEditingController(
        text: currentResponseItem
                ?.answer?.firstOrNull?.valueString?.valueString ??
            initialValue,
      );

      questionnaireRendererData.rendererController.indexedItems[itemLinkId!] =
          questionnaireRendererData
              .rendererController.indexedItems[itemLinkId!]!
              .copyWith(textController: controller);
    } else {
      controller = questionnaireRendererData
          .rendererController.indexedItems[itemLinkId]!.textController!;
    }

    return controller;
  }

  void assignDependents(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer) {
    // Only assign if not already present to avoid recreating FocusNode on every build
    if (!inheritedQuestionnaireRenderer.rendererController.indexedItems
        .containsKey(itemLinkId!)) {
      final dependents = questionnaireItem.enableWhen
          ?.map((condition) => "${condition.question.valueString}")
          .toList();

      final currentIndex =
          inheritedQuestionnaireRenderer.rendererController.indexedItems.length;
      inheritedQuestionnaireRenderer
              .rendererController.indexedItems[itemLinkId!] =
          ItemBehavioralData(
              index: currentIndex,
              markAsRequired: false,
              focusNode: FocusNode(),
              dependentOn: dependents,
              regexValidationPattern: questionnaireItem.regexValidationPattern,
              regexValidationError: questionnaireItem.regexValidationErrorMessage);
    }
  }

  bool markAsRequired(
      InheritedQuestionnaireRenderer inheritedQuestionnaireRenderer,
      QuestionnaireResponseItem? responseItem,
      bool isRequired) {
    if (isRequired) {
      if (inheritedQuestionnaireRenderer.checkRequiredItems &&
          (responseItem?.answer == null ||
              (responseItem?.answer?.isEmpty ?? false))) {
        if (inheritedQuestionnaireRenderer.rendererController.indexedItems
            .containsKey(itemLinkId)) {
          inheritedQuestionnaireRenderer
                  .rendererController.indexedItems[itemLinkId!] =
              inheritedQuestionnaireRenderer
                  .rendererController.indexedItems[itemLinkId]!
                  .copyWith(markAsRequired: true);
        }

        return true;
      }
    }
    return false;
  }

  Widget buildQuestionnaireItem(BuildContext context);

  @override
  Widget build(BuildContext context) {
    assignDependents(InheritedQuestionnaireRenderer.of(context));
    return buildQuestionnaireItem(context);
  }
}
