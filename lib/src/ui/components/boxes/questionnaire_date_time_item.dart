import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';
import '../questionnaire_styles.dart';
import '../../../core/mixins/datetime_value_mixin.dart';

class QuestionnaireDateTimeItem extends QuestionnaireBaseItem
    with DateTimeValueMixin {
  const QuestionnaireDateTimeItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final currentResponseItem = findQuestionnaireResponseItem(
      InheritedQuestionnaireRenderer.of(context).questionnaireResponse,
      itemLinkId,
    );

    String displayText =
        extractDisplayText(currentResponseItem, questionnaireItem);

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          minimumSize: const Size(double.infinity, 44),
          alignment: Alignment.centerLeft,
          shape: const RoundedRectangleBorder(
              borderRadius: QuestionnaireStyles.cardRadius),
        ),
        onPressed: () async {
          final selectedValue = await onSelectValue(
            context,
            questionnaireItem,
            currentResponseItem,
          );

          if (context.mounted && selectedValue != null) {
            InheritedQuestionnaireRenderer.of(context).onResponseChanged(
              FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                InheritedQuestionnaireRenderer.of(context)
                    .questionnaireResponse,
                questionnaireItem,
                selectedValue,
              ),
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: getItemIcon(questionnaireItem.type,
                  Theme.of(context).colorScheme.primary),
            ),
            Text(displayText),
          ],
        ),
      ),
    );
  }
}
