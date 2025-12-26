import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/widgets.dart';

typedef QuestionnaireDisplayWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireItem questionnaireItem,
);

typedef QuestionnaireDateTimeWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(QuestionnaireResponseAnswer answerOption) onAnswerChanged,
);

typedef QuestionnaireBooleanWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(bool answer) onAnswerChanged,
);

typedef QuestionnaireGroupWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireItem questionnaireItem,
);

typedef QuestionnaireChoiceWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(QuestionnaireAnswerOption answerOption) onAnswerOptionSelected,
);

typedef QuestionnaireFieldWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(String answer) onAnswerChanged,
);
