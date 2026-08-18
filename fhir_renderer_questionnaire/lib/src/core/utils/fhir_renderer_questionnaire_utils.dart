import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
import 'package:fhir_renderer_questionnaire/src/core/controllers/renderer_questionnaire_controller.dart';
import 'fhir_renderer_questionnaire_response_utils.dart';

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
    if (controller != null) {
      final responseHash = questionnaireResponse.hashCode;
      final cached = controller.getCachedEnableWhen(
        questionnaireItem.linkId,
        responseHash,
      );
      if (cached != null) {
        return cached;
      }
    }

    // Compute the result
    final result = _evaluateEnableWhen(questionnaireResponse, questionnaireItem);

    // Cache the result if controller is provided
    if (controller != null) {
      controller.cacheEnableWhen(
        questionnaireItem.linkId,
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
    if (questionnaireItem.enableWhen != null && questionnaireItem.enableWhen!.isNotEmpty) {
      List<QuestionnaireEnableWhen> enableWhen = questionnaireItem.enableWhen!;

      // Determine the behavior (default is "any" / OR logic)
      final isAndBehavior =
          questionnaireItem.enableBehavior == QuestionnaireEnableBehavior.all;

      // Evaluate each enableWhen condition
      for (QuestionnaireEnableWhen enableWhenCondition in enableWhen) {
        QuestionnaireResponseItem? questionnaireResponseItem =
            FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
          questionnaireResponse,
          enableWhenCondition.question,
        );

        // Check if this condition is satisfied
        bool conditionSatisfied = false;
        if (questionnaireResponseItem != null &&
            questionnaireResponseItem.answer != null &&
            questionnaireResponseItem.answer!.isNotEmpty) {
          // Use .every() or .any() based on enableBehavior to evaluate
          // multiple answers within this single item
          conditionSatisfied = isAndBehavior
              ? questionnaireResponseItem.answer!.every(
                  (answerInItem) => _compareAnswerAndCondition(
                    answerInItem,
                    enableWhenCondition,
                  ),
                )
              : questionnaireResponseItem.answer!.any(
                  (answerInItem) => _compareAnswerAndCondition(
                    answerInItem,
                    enableWhenCondition,
                  ),
                );
        }

        // Short-circuit based on behavior
        if (isAndBehavior) {
          // AND logic: if any condition fails, item is disabled
          if (!conditionSatisfied) {
            return false;
          }
        } else {
          // OR logic: if any condition succeeds, item is enabled
          if (conditionSatisfied) {
            return true;
          }
        }
      }

      // Determine final result based on behavior
      // - AND behavior: reached here means all conditions satisfied = true
      // - OR behavior: reached here means no conditions satisfied = false
      return isAndBehavior;
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
      questionnaireResponseAnswer,
    );

    final double? enableWhenNumericValue =
        _getNumericValueFromQuestionnaireAnswerEnableWhen(
      questionnaireEnableWhen,
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
          questionnaireEnableWhen.answerCoding?.code ??
              questionnaireEnableWhen.answerBoolean ??
              questionnaireEnableWhen.answerReference?.reference ??
              questionnaireEnableWhen.answerString;
      final dynamic responseAnswer = questionnaireResponseAnswer
              .valueCoding?.code ??
          questionnaireResponseAnswer.valueBoolean ??
          questionnaireResponseAnswer.valueReference?.reference ??
          questionnaireResponseAnswer.valueString;

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

  /// Reduces a comparable answer value to a number, so `>`/`<`/`>=`/`<=`
  /// work uniformly across the types that have an ordering.
  ///
  /// Dates and dateTimes become milliseconds since epoch; times become
  /// milliseconds since midnight. Both sides of a comparison go through this
  /// same conversion, so the units only need to be consistent, not absolute.
  /// Types with no natural ordering (boolean, coding, reference, attachment)
  /// return null, which sends the caller down the equality path instead.
  static double? _numericValue({
    FhirDate? date,
    FhirDateTime? dateTime,
    FhirTime? time,
    double? decimal,
    int? integer,
    Quantity? quantity,
    String? string,
  }) {
    if (date != null) {
      return date.toDateTime()?.millisecondsSinceEpoch.toDouble();
    }
    if (dateTime != null) {
      return dateTime.toDateTime()?.millisecondsSinceEpoch.toDouble();
    }
    if (time != null) {
      final seconds = time.secondsSinceMidnight;
      return seconds == null ? null : (seconds * Duration.millisecondsPerSecond)
          .toDouble();
    }
    if (decimal != null) return decimal;
    if (integer != null) return integer.toDouble();
    if (quantity != null) return quantity.value ?? 0.0;
    // A numeric answer stored as a string still compares numerically.
    if (string != null) return double.tryParse(string);
    return null;
  }

  /// The numeric form of an `enableWhen` condition's answer, if it has one.
  static double? _getNumericValueFromQuestionnaireAnswerEnableWhen(
    QuestionnaireEnableWhen enableWhen,
  ) => _numericValue(
        date: enableWhen.answerDate,
        dateTime: enableWhen.answerDateTime,
        time: enableWhen.answerTime,
        decimal: enableWhen.answerDecimal,
        integer: enableWhen.answerInteger,
        quantity: enableWhen.answerQuantity,
        string: enableWhen.answerString,
      );

  /// The numeric form of a response answer, if it has one.
  static double? _getNumericValueFromResponseAnswer(
    QuestionnaireResponseAnswer answer,
  ) => _numericValue(
        date: answer.valueDate,
        dateTime: answer.valueDateTime,
        time: answer.valueTime,
        decimal: answer.valueDecimal,
        integer: answer.valueInteger,
        quantity: answer.valueQuantity,
        string: answer.valueString,
      );
}
