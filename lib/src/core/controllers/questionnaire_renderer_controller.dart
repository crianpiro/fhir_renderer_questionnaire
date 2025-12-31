import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/widgets.dart';

import 'internal_questionnaire_controller.dart';

class QuestionnaireRendererController {
  final InternalQuestionnaireController _internalController;

  QuestionnaireRendererController(this._internalController);

  QuestionnaireResponse getGeneratedQuestionnaireResponse() {
    return _internalController.generateQuestionnaireResponse.call();
  }

  ScrollController? getScrollController() =>
      _internalController.listViewScrollController;

  PageController? getPageController() => _internalController.pageViewController;
}
