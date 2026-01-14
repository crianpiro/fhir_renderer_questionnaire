import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_date_time_item.dart';
import 'sliver_base_decorator.dart';

final class QuestionnaireSliverDateTimeItem extends QuestionnaireDateTimeItem {
  const QuestionnaireSliverDateTimeItem({
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

    return SliverBaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      child: SliverToBoxAdapter(
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
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
                child: getItemIcon(questionnaireItem.type),
              ),
              Text(displayText),
            ],
          ),
        ),
      ),
    );
  }
}
