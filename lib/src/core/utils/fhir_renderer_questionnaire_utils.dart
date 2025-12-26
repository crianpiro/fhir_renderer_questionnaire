import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'package:intl/intl.dart';

class FhirRendererQuestionnaireUtils {
  static bool isQuestionnaireItemEnabled(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem,
  ) {
    if (questionnaireItem.enableWhen != null) {
      List<QuestionnaireEnableWhen> enableWhen = questionnaireItem.enableWhen!;

      bool enabled = false;
      for (QuestionnaireEnableWhen enableWhenCondition in enableWhen) {
        QuestionnaireResponseItem? questionnaireResponseItem =
            FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
          questionnaireResponse,
          enableWhenCondition.question.valueString,
        );

        if (questionnaireResponseItem != null) {
          if (questionnaireItem.enableBehavior?.valueEnum ==
              EnableWhenBehaviorEnum.all) {
            return questionnaireResponseItem.answer?.every(
                  (answerInItem) => _compareAnswerAndCondition(
                    answerInItem,
                    enableWhenCondition,
                  ),
                ) ??
                false;
          } else {
            return questionnaireResponseItem.answer?.any(
                  (answerInItem) => _compareAnswerAndCondition(
                    answerInItem,
                    enableWhenCondition,
                  ),
                ) ??
                false;
          }
        } else {
          continue;
        }
      }

      return enabled;
    }
    return true;
  }

  static bool _compareAnswerAndCondition(
    QuestionnaireResponseAnswer questionnaireResponseAnswer,
    QuestionnaireEnableWhen questionnaireEnableWhen,
  ) {
    final double? numericValue = _getNumericValueFromResponseAnswer(
      questionnaireResponseAnswer.valueX,
    );

    final double? enableWhenNumericValue =
        _getNumericValueFromQuestionnaireAnswerEnableWhen(
      questionnaireEnableWhen.answerX,
    );

    if (numericValue != null && enableWhenNumericValue != null) {
      switch (questionnaireEnableWhen.operator_) {
        case QuestionnaireItemOperator.eq:
          return numericValue == enableWhenNumericValue;
        case QuestionnaireItemOperator.ge:
          return numericValue >= enableWhenNumericValue;
        case QuestionnaireItemOperator.gt:
          return numericValue > enableWhenNumericValue;
        case QuestionnaireItemOperator.le:
          return numericValue <= enableWhenNumericValue;
        case QuestionnaireItemOperator.lt:
          return numericValue < enableWhenNumericValue;
        case QuestionnaireItemOperator.ne:
          return numericValue != enableWhenNumericValue;
        default:
          return false;
      }
    } else {
      final dynamic enableWhenAnswerCondition =
          questionnaireEnableWhen.answerCoding?.code?.valueString ??
              questionnaireEnableWhen.answerBoolean?.valueBoolean ??
              questionnaireEnableWhen.answerReference?.reference?.valueString ??
              questionnaireEnableWhen.answerString?.valueString;
      final dynamic responseAnswer = questionnaireResponseAnswer
              .valueCoding?.code?.valueString ??
          questionnaireResponseAnswer.valueBoolean?.valueBoolean ??
          questionnaireResponseAnswer.valueReference?.reference?.valueString ??
          questionnaireResponseAnswer.valueString?.valueString;

      switch (questionnaireEnableWhen.operator_) {
        case QuestionnaireItemOperator.eq:
          return enableWhenAnswerCondition == responseAnswer;
        case QuestionnaireItemOperator.exists:
          return responseAnswer is bool &&
              enableWhenAnswerCondition is bool &&
              responseAnswer == enableWhenAnswerCondition;
        case QuestionnaireItemOperator.ne:
          return enableWhenAnswerCondition != responseAnswer;
        default:
          return false;
      }
    }
  }

  static double? _getNumericValueFromQuestionnaireAnswerEnableWhen(
    AnswerXQuestionnaireEnableWhen? questResponseAnswer,
  ) {
    if (questResponseAnswer == null) {
      return null;
    }
    switch (questResponseAnswer) {
      case FhirDate _:
        if (questResponseAnswer.valueDateTime != null) {
          return questResponseAnswer.valueDateTime!.millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirDateTime _:
        if (questResponseAnswer.valueDateTime != null) {
          return questResponseAnswer.valueDateTime!.millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirTime _:
        if (questResponseAnswer.valueString != null) {
          return DateFormat.Hm()
              .parse(questResponseAnswer.valueString!)
              .millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirDecimal _:
        if (questResponseAnswer.valueDouble != null) {
          return questResponseAnswer.valueDouble!;
        }
        break;
      case FhirInteger _:
        if (questResponseAnswer.valueInt != null) {
          return questResponseAnswer.valueInt!.toDouble();
        }
        break;
      case Quantity _:
        if (questResponseAnswer.value != null) {
          return questResponseAnswer.value!.valueInt?.toDouble() ?? 0;
        }
        break;
      case FhirString _:
        if (questResponseAnswer.valueString != null &&
            (questResponseAnswer.valueString!.isInteger ||
                questResponseAnswer.valueString!.isDecimal())) {
          return double.parse(questResponseAnswer.valueString!);
        }
        break;
      case FhirBoolean _:
      case Reference _:
      case Attachment _:
      case Coding _:
      case FhirUri _:
      default:
        break;
    }

    return null;
  }

  static double? _getNumericValueFromResponseAnswer(
    ValueXQuestionnaireResponseAnswer? questResponseAnswer,
  ) {
    if (questResponseAnswer == null) {
      return null;
    }
    switch (questResponseAnswer) {
      case FhirDate _:
        if (questResponseAnswer.valueDateTime != null) {
          return questResponseAnswer.valueDateTime!.millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirDateTime _:
        if (questResponseAnswer.valueDateTime != null) {
          return questResponseAnswer.valueDateTime!.millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirTime _:
        if (questResponseAnswer.valueString != null) {
          return DateFormat.Hm()
              .parse(questResponseAnswer.valueString!)
              .millisecondsSinceEpoch
              .toDouble();
        }
        break;
      case FhirDecimal _:
        if (questResponseAnswer.valueDouble != null) {
          return questResponseAnswer.valueDouble!;
        }
        break;
      case FhirInteger _:
        if (questResponseAnswer.valueInt != null) {
          return questResponseAnswer.valueInt!.toDouble();
        }
        break;
      case Quantity _:
        if (questResponseAnswer.value != null) {
          return questResponseAnswer.value!.valueInt?.toDouble() ?? 0;
        }
        break;
      case FhirString _:
        if (questResponseAnswer.valueString != null &&
            (questResponseAnswer.valueString!.isInteger ||
                questResponseAnswer.valueString!.isDecimal())) {
          return double.parse(questResponseAnswer.valueString!);
        }
        break;
      case FhirBoolean _:
      case Reference _:
      case Attachment _:
      case Coding _:
      case FhirUri _:
      default:
        break;
    }

    return null;
  }
}
