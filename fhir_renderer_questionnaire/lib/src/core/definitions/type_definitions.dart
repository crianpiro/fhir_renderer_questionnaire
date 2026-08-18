import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:flutter/widgets.dart';

/// A typedef for building a display widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [questionnaireItem]: The questionnaire item to be displayed.
typedef QuestionnaireDisplayWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireItem questionnaireItem,
);

/// A typedef for building a DateTime widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [selectedResponse]: The current response item selected, if any.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onAnswerChanged]: Callback when the answer is changed.
typedef QuestionnaireDateTimeWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(QuestionnaireResponseAnswer answerOption) onAnswerChanged,
);

/// A typedef for building a Boolean widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [selectedResponse]: The current boolean response item selected, if any.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onAnswerChanged]: Callback when the boolean answer is changed.
typedef QuestionnaireBooleanWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(bool answer) onAnswerChanged,
);

/// A typedef for building a group widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [questionnaireItem]: The questionnaire group item to be displayed.
/// [childrenAssigner]: A function to assign default widget to the group item children.
typedef QuestionnaireGroupWidgetBuilder = Widget Function(
    int index,
    bool isLastItem,
    QuestionnaireItem questionnaireItem,
    Widget Function(QuestionnaireItem questionnaireItem, int index)
        childrenAssigner);

/// A typedef for building a choice widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [selectedResponse]: The current choice response item selected, if any.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onAnswerOptionSelected]: Callback when a choice answer option is selected.
typedef QuestionnaireChoiceWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(QuestionnaireAnswerOption answerOption) onAnswerOptionSelected,
);

/// A typedef for building a field widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [selectedResponse]: The current field response item selected, if any.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onAnswerChanged]: Callback when the field answer is changed.
typedef QuestionnaireFieldWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  TextEditingController fieldController,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(String answer) onAnswerChanged,
);

/// A typedef for building a reference widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [referenceController]: The controller for the reference input field.
/// [displayController]: The controller for the display name input field.
/// [selectedResponse]: The current reference response item selected, if any.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onReferenceChanged]: Callback when the reference value is changed.
///   Takes the reference string (e.g., "Patient/123") and display name.
typedef QuestionnaireReferenceWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  TextEditingController referenceController,
  TextEditingController displayController,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(String referenceString, String displayName) onReferenceChanged,
);

/// A typedef for building an attachment widget for a questionnaire.
///
/// [index]: The index of the item in the questionnaire.
/// [isLastItem]: Determines if this is the last item in the questionnaire.
/// [selectedResponse]: The current attachment response item selected, if any.
///   Access the attachment via `selectedResponse?.answer?.firstOrNull?.valueAttachment`.
/// [questionnaireItem]: The questionnaire item to be processed.
/// [onAttachmentChanged]: Callback when attachment is added or removed.
///   Pass an Attachment object to set, or null to clear.
typedef QuestionnaireAttachmentWidgetBuilder = Widget Function(
  int index,
  bool isLastItem,
  QuestionnaireResponseItem? selectedResponse,
  QuestionnaireItem questionnaireItem,
  Function(Attachment? attachment) onAttachmentChanged,
);
