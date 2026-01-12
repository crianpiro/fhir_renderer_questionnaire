import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/renderer_questionnaire_controller.dart';
import 'fhir_renderer_questionnaire_response_utils.dart';
import 'package:intl/intl.dart';

/// Utility class for evaluating and processing FHIR Questionnaire conditions.
///
/// This class provides static methods to:
/// * Evaluate enable/disable conditions for questionnaire items
/// * Compare questionnaire responses against conditional logic
/// * Extract and convert numeric values from various FHIR answer types
final class FhirRendererQuestionnaireUtils {
  /// Determines if a questionnaire item is enabled based on enable/disable conditions,
  /// with optional caching support.
  ///
  /// Evaluates the `enableWhen` conditions of a questionnaire item against the current
  /// questionnaire response. Supports both 'all' (AND logic) and 'any' (OR logic) behaviors.
  ///
  /// When a [controller] is provided, results are cached to avoid redundant evaluations.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The current questionnaire response to evaluate against
  ///   * [questionnaireItem] - The questionnaire item with potential enable conditions
  ///   * [controller] - Optional controller for caching results
  ///
  /// Returns:
  ///   `true` if the item has no enable conditions or if the conditions are satisfied,
  ///   `false` otherwise.
  static bool isQuestionnaireItemEnabled(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem, {
    RendererQuestionnaireController? controller,
  }) {
    // Check cache if controller is provided
    if (controller != null && questionnaireItem.linkId.valueString != null) {
      final responseHash = questionnaireResponse.hashCode;
      final cached = controller.getCachedEnableWhen(
        questionnaireItem.linkId.valueString!,
        responseHash,
      );
      if (cached != null) {
        return cached;
      }
    }

    // Compute the result
    final result = _evaluateEnableWhen(questionnaireResponse, questionnaireItem);

    // Cache the result if controller is provided
    if (controller != null && questionnaireItem.linkId.valueString != null) {
      controller.cacheEnableWhen(
        questionnaireItem.linkId.valueString!,
        questionnaireResponse.hashCode,
        result,
      );
    }

    return result;
  }

  /// Internal method that performs the actual enableWhen evaluation.
  static bool _evaluateEnableWhen(
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

  /// Compares a questionnaire response answer against an enable/disable condition.
  ///
  /// Evaluates the relationship between an answer and a condition using the specified
  /// operator (equals, not equals, greater than, less than, exists, etc.).
  /// Supports both numeric and non-numeric comparisons.
  ///
  /// Parameters:
  ///   * [questionnaireResponseAnswer] - The answer to evaluate
  ///   * [questionnaireEnableWhen] - The condition to check against
  ///
  /// Returns:
  ///   `true` if the answer satisfies the condition, `false` otherwise.
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

  /// Extracts a numeric value from a questionnaire enable/disable condition answer.
  ///
  /// Converts various FHIR answer types (Date, DateTime, Time, Decimal, Integer, Quantity, String)
  /// to numeric values for comparison. Unsupported types return null.
  ///
  /// Parameters:
  ///   * [questResponseAnswer] - The enable/disable condition answer to extract from
  ///
  /// Returns:
  ///   A numeric value as a `double` if conversion is possible, `null` otherwise.
  ///   Dates/DateTimes are converted to milliseconds since epoch.
  ///   Times are parsed and converted to milliseconds since epoch.
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

  /// Extracts a numeric value from a questionnaire response answer.
  ///
  /// Converts various FHIR answer types (Date, DateTime, Time, Decimal, Integer, Quantity, String)
  /// to numeric values for comparison. Unsupported types return null.
  ///
  /// Parameters:
  ///   * [questResponseAnswer] - The response answer to extract from
  ///
  /// Returns:
  ///   A numeric value as a `double` if conversion is possible, `null` otherwise.
  ///   Dates/DateTimes are converted to milliseconds since epoch.
  ///   Times are parsed and converted to milliseconds since epoch.
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
