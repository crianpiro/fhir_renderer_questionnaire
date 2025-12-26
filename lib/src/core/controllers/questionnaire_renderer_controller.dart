import 'package:fhir_r4/fhir_r4.dart';

import 'internal_questionnaire_controller.dart';

class QuestionnaireRendererController {
  final InternalQuestionnaireController _internalController;

  QuestionnaireRendererController(this._internalController);

  QuestionnaireResponse get getGeneratedQuestionnaireResponse =>
      _internalController.generateQuestionnaireResponse.call();
}
