import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import '../data/field_behavioral_data.dart';

class InternalQuestionnaireController {
  final QuestionnaireResponse Function() generateQuestionnaireResponse;

  final PageController? pageViewController;
  final ScrollController? listViewScrollController;

  final Map<String, FieldBehavioralData> indexedItems = {};

  InternalQuestionnaireController({
    this.listViewScrollController,
    this.pageViewController,
    required this.generateQuestionnaireResponse,
  });
}
