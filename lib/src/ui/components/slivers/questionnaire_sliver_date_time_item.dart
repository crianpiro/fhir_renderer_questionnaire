import 'package:flutter/material.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import '../boxes/questionnaire_date_time_item.dart';
import 'sliver_base_decorator.dart';

class QuestionnaireSliverDateTimeItem extends QuestionnaireDateTimeItem {
  const QuestionnaireSliverDateTimeItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    final currentResponseItem = findQuestionnaireResponseItem(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );

    String? displayText = extractDisplayText(currentResponseItem);

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
              currentResponseItem,
            );

            if (context.mounted && selectedValue != null) {
              QuestionnaireRendererData.of(context).onResponseChanged(
                FhirRendererQuestionnaireResponseUtils
                    .setResponseAnswerInQuestionnaireResponse(
                  QuestionnaireRendererData.of(context).questionnaireResponse,
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
                child: getItemIcon(),
              ),
              Text(displayText),
            ],
          ),
        ),
      ),
    );
  }
}
