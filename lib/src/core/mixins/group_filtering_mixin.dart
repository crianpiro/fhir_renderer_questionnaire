import 'package:fhir_r4/fhir_r4.dart';

import '../../ui/layout/inherited_questionnaire_renderer.dart';
import '../utils/fhir_renderer_questionnaire_utils.dart';

/// Mixin providing group item filtering logic for FHIR questionnaire items.
///
/// Handles filtering of nested items within a group based on enableWhen conditions.
mixin GroupFilteringMixin {
  /// Filters group items based on their enableWhen conditions.
  ///
  /// Evaluates each nested item's enableWhen logic against the current questionnaire
  /// response and updates the item's enabled state in the controller.
  ///
  /// Returns a filtered list of enabled questionnaire items, or null if no items exist.
  List<QuestionnaireItem>? getFilteredGroupItems(
    QuestionnaireItem groupItem,
    InheritedQuestionnaireRenderer rendererData,
  ) {
    return groupItem.item?.where((item) {
      final enabled = FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
        rendererData.questionnaireResponse,
        item,
      );

      if (rendererData.rendererController.indexedItems.containsKey(
        item.linkId.valueString!,
      )) {
        final itemData = rendererData
            .rendererController.indexedItems[item.linkId.valueString!]!;
        rendererData.rendererController.indexedItems[item.linkId.valueString!] =
            itemData.copyWith(enabled: enabled);
      }
      return enabled;
    }).toList();
  }
}
