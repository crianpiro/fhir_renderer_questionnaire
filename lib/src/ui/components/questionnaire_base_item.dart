import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:flutter/material.dart';

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
}
