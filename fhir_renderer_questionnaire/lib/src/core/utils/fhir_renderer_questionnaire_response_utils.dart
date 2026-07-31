import 'package:fhir_r4/fhir_r4.dart';
import '../extensions/fhir_extensions.dart';

/// Utility class for managing and manipulating FHIR Questionnaire Response objects.
///
/// This class provides static methods to:
/// * Set or update answers in questionnaire responses
/// * Handle single and multiple answer options
/// * Generate initial questionnaire responses from questionnaire definitions
/// * Search for items within questionnaire response hierarchies
final class FhirRendererQuestionnaireResponseUtils {
  /// Sets or replaces the answer for a specific questionnaire item in the response.
  ///
  /// Searches through the response item hierarchy to find the item matching the
  /// questionnaire item's linkId and replaces its answer with the provided answer.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The questionnaire response to modify
  ///   * [questionnaireItem] - The questionnaire item containing the linkId to search for
  ///   * [responseAnswer] - The answer to set (null to clear answers)
  ///
  /// Returns:
  ///   A new [QuestionnaireResponse] with the updated answer.
  static QuestionnaireResponse setResponseAnswerInQuestionnaireResponse(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem,
    QuestionnaireResponseAnswer? responseAnswer,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

    if (questionnaireResponse.item != null) {
      for (QuestionnaireResponseItem responseItem
          in questionnaireResponse.item!) {
        final foundItem = _setAnswerInResponseItem(
          responseItem,
          questionnaireItem.linkId.valueString,
          responseAnswer,
        );

        if (foundItem != null) {
          modifiedItems.add(foundItem);
        } else {
          modifiedItems.add(responseItem);
        }
      }
    }

    return questionnaireResponse.copyWith(item: modifiedItems);
  }

  /// Adds or removes an answer option from a questionnaire item's answers.
  ///
  /// Handles toggling of multiple choice answers by either adding the answer option
  /// if not already present or removing it if already present (toggle behavior).
  ///
  /// Honors the FHIR SDC `questionnaire-optionExclusive` extension to support a
  /// master "all"/"none" option within a multi-select item:
  ///   * Selecting an exclusive option clears every other selection.
  ///   * Selecting a non-exclusive option clears any currently selected
  ///     exclusive options.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The questionnaire response to modify
  ///   * [questionnaireItem] - The questionnaire item to update
  ///   * [questionnaireAnswerOption] - The answer option to toggle
  ///
  /// Returns:
  ///   A new [QuestionnaireResponse] with the toggled answer.
  static QuestionnaireResponse setMultipleAnswerOptionsInQuestionnaireResponse(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem,
    QuestionnaireAnswerOption questionnaireAnswerOption,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

    final bool isOptionExclusive = questionnaireAnswerOption.isOptionExclusive;
    final Set<String> exclusiveOptionCodes = {};
    for (final option
        in questionnaireItem.answerOption ?? <QuestionnaireAnswerOption>[]) {
      if (option.isOptionExclusive) {
        final code = option.valueCoding?.code?.valueString;
        if (code != null) {
          exclusiveOptionCodes.add(code);
        }
      }
    }

    if (questionnaireResponse.item != null) {
      for (QuestionnaireResponseItem responseItem
          in questionnaireResponse.item!) {
        final foundItem = _addAnswerToResponseItem(
          responseItem,
          questionnaireItem.linkId.valueString,
          _getQuestionnaireResponseAnswerFromAnswerOption(
            questionnaireItem.type,
            questionnaireAnswerOption,
          ),
          isOptionExclusive,
          exclusiveOptionCodes,
        );

        if (foundItem != null) {
          modifiedItems.add(foundItem);
        } else {
          modifiedItems.add(responseItem);
        }
      }
    }

    return questionnaireResponse.copyWith(item: modifiedItems);
  }

  /// Sets an answer option for a questionnaire item, replacing any existing answers.
  ///
  /// Converts the answer option to the appropriate response answer format based on
  /// the questionnaire item type and sets it as the sole answer.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The questionnaire response to modify
  ///   * [questionnaireItem] - The questionnaire item to update
  ///   * [questionnaireAnswerOption] - The answer option to set
  ///
  /// Returns:
  ///   A new [QuestionnaireResponse] with the updated answer.
  static QuestionnaireResponse setAnswerOptionInQuestionnaireResponse(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem,
    QuestionnaireAnswerOption questionnaireAnswerOption,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

    if (questionnaireResponse.item != null) {
      for (QuestionnaireResponseItem responseItem
          in questionnaireResponse.item!) {
        final foundItem = _setAnswerInResponseItem(
          responseItem,
          questionnaireItem.linkId.valueString,
          _getQuestionnaireResponseAnswerFromAnswerOption(
            questionnaireItem.type,
            questionnaireAnswerOption,
          ),
        );

        if (foundItem != null) {
          modifiedItems.add(foundItem);
        } else {
          modifiedItems.add(responseItem);
        }
      }
    }

    return questionnaireResponse.copyWith(item: modifiedItems);
  }

  /// Recursively searches for and sets an answer in a questionnaire response item.
  ///
  /// If the item's linkId matches the target linkId, updates its answer. Otherwise,
  /// recursively searches through child items.
  ///
  /// Parameters:
  ///   * [responseItem] - The response item to search and modify
  ///   * [questionnaireItemLinkId] - The linkId of the item to find
  ///   * [answer] - The answer to set
  ///
  /// Returns:
  ///   The modified response item if found, null otherwise.
  static QuestionnaireResponseItem? _setAnswerInResponseItem(
    QuestionnaireResponseItem responseItem,
    String? questionnaireItemLinkId,
    QuestionnaireResponseAnswer? answer,
  ) {
    if (responseItem.linkId.valueString == questionnaireItemLinkId) {
      return _setResponseAnswer(responseItem, answer);
    } else if (responseItem.item != null) {
      List<QuestionnaireResponseItem>? items = [];

      for (QuestionnaireResponseItem subItem in responseItem.item!) {
        final found = _setAnswerInResponseItem(
          subItem,
          questionnaireItemLinkId,
          answer,
        );

        if (found != null) {
          items.add(found);
        } else {
          items.add(subItem);
        }
      }

      return responseItem.copyWith(item: items);
    } else {
      return null;
    }
  }

  /// Recursively searches for and adds an answer to a questionnaire response item.
  ///
  /// If the item's linkId matches the target linkId, adds the answer to the
  /// existing answers list. Otherwise, recursively searches through child items.
  ///
  /// Parameters:
  ///   * [responseItem] - The response item to search and modify
  ///   * [questionnaireItemLinkId] - The linkId of the item to find
  ///   * [answer] - The answer to add
  ///   * [isOptionExclusive] - Whether the toggled option is mutually exclusive
  ///   * [exclusiveOptionCodes] - Codes of all exclusive options on the item
  ///
  /// Returns:
  ///   The modified response item if found, null otherwise.
  static QuestionnaireResponseItem? _addAnswerToResponseItem(
    QuestionnaireResponseItem responseItem,
    String? questionnaireItemLinkId,
    QuestionnaireResponseAnswer answer,
    bool isOptionExclusive,
    Set<String> exclusiveOptionCodes,
  ) {
    if (responseItem.linkId.valueString == questionnaireItemLinkId) {
      return _setMultipleResponseAnswers(
        responseItem,
        answer,
        isOptionExclusive,
        exclusiveOptionCodes,
      );
    } else if (responseItem.item != null) {
      List<QuestionnaireResponseItem>? items = [];

      for (QuestionnaireResponseItem subItem in responseItem.item!) {
        final found = _addAnswerToResponseItem(
          subItem,
          questionnaireItemLinkId,
          answer,
          isOptionExclusive,
          exclusiveOptionCodes,
        );

        if (found != null) {
          items.add(found);
        } else {
          items.add(subItem);
        }
      }

      return responseItem.copyWith(item: items);
    } else {
      return null;
    }
  }

  /// Sets a single answer for a response item, replacing any existing answers.
  ///
  /// Parameters:
  ///   * [responseItem] - The response item to update
  ///   * [responseAnswer] - The answer to set (null to clear answers)
  ///
  /// Returns:
  ///   A copy of the response item with the updated answer.
  static QuestionnaireResponseItem _setResponseAnswer(
    QuestionnaireResponseItem responseItem,
    QuestionnaireResponseAnswer? responseAnswer,
  ) =>
      responseItem.copyWith(
        answer: responseAnswer != null ? [responseAnswer] : [],
      );

  /// Adds or removes an answer from a response item's answers list (toggle behavior).
  ///
  /// Checks if an answer with the same coding already exists. If it does, removes it.
  /// If not, adds the new answer to the list while enforcing exclusivity:
  ///   * If the toggled option is exclusive, it becomes the sole answer.
  ///   * Otherwise, any currently selected exclusive options are removed before
  ///     the new answer is added.
  ///
  /// Parameters:
  ///   * [responseItem] - The response item to update
  ///   * [responseAnswer] - The answer to toggle
  ///   * [isOptionExclusive] - Whether the toggled option is mutually exclusive
  ///   * [exclusiveOptionCodes] - Codes of all exclusive options on the item
  ///
  /// Returns:
  ///   A copy of the response item with the toggled answer.
  static QuestionnaireResponseItem _setMultipleResponseAnswers(
    QuestionnaireResponseItem responseItem,
    QuestionnaireResponseAnswer responseAnswer,
    bool isOptionExclusive,
    Set<String> exclusiveOptionCodes,
  ) {
    final optionCode = responseAnswer.valueCoding?.code?.valueString;
    bool addedAnswer = responseItem.answer?.any(
          (i) => i.valueCoding?.code?.valueString == optionCode,
        ) ??
        false;
    List<QuestionnaireResponseAnswer> answers;
    if (addedAnswer) {
      // Toggle off: remove the selected option.
      answers = responseItem.answer
              ?.where(
                (i) => i.valueCoding?.code?.valueString != optionCode,
              )
              .toList() ??
          [];
    } else if (isOptionExclusive) {
      // Selecting an exclusive ("all"/"none") option clears every other choice.
      answers = [responseAnswer];
    } else {
      // Selecting a normal option drops any exclusive options first.
      answers = responseItem.answer
              ?.where(
                (i) => !exclusiveOptionCodes
                    .contains(i.valueCoding?.code?.valueString),
              )
              .toList() ??
          [];
      answers.add(responseAnswer);
    }

    return responseItem.copyWith(answer: answers);
  }

  /// Converts a questionnaire answer option to a questionnaire response answer.
  ///
  /// Maps the answer option's value to the appropriate response answer value type
  /// based on the questionnaire item type.
  ///
  /// Parameters:
  ///   * [questionnaireItemType] - The type of the questionnaire item
  ///   * [answer] - The answer option to convert
  ///
  /// Returns:
  ///   A [QuestionnaireResponseAnswer] with the appropriate value type.
  static QuestionnaireResponseAnswer
      _getQuestionnaireResponseAnswerFromAnswerOption(
    QuestionnaireItemType questionnaireItemType,
    QuestionnaireAnswerOption answer,
  ) {
    ValueXQuestionnaireResponseAnswer? valueX;
    switch (questionnaireItemType) {
      case QuestionnaireItemType.string:
      case QuestionnaireItemType.text:
        valueX = answer.valueString;
        break;
      case QuestionnaireItemType.url:
        valueX = FhirUri(answer.valueString);
        break;
      case QuestionnaireItemType.integer:
        valueX = answer.valueInteger;
        break;
      case QuestionnaireItemType.choice:
      case QuestionnaireItemType.openChoice:
        valueX = answer.valueCoding;
        break;
      case QuestionnaireItemType.date:
        valueX = answer.valueDate;
        break;
      case QuestionnaireItemType.time:
        valueX = answer.valueTime;
        break;
      case QuestionnaireItemType.decimal:
      case QuestionnaireItemType.boolean:
      case QuestionnaireItemType.dateTime:
      case QuestionnaireItemType.quantity:
      case QuestionnaireItemType.attachment:
      case QuestionnaireItemType.display_:
      case QuestionnaireItemType.group:
      default:
        break;
    }

    return QuestionnaireResponseAnswer(valueX: valueX);
  }

  /// Generates questionnaire response answers from a questionnaire item's initial values.
  ///
  /// Extracts the initial value from the questionnaire item and converts it to the
  /// appropriate response answer format based on the item type. Supports all FHIR
  /// questionnaire item types.
  ///
  /// Parameters:
  ///   * [item] - The questionnaire item to extract initial values from
  ///
  /// Returns:
  ///   A list containing the generated answer, or null if no initial value exists.
  static List<QuestionnaireResponseAnswer>? generateAnswers(
    QuestionnaireItem item,
  ) {
    List<QuestionnaireResponseAnswer>? answers;

    ValueXQuestionnaireResponseAnswer? valueX =
        item.initial?.firstOrNull?.valueCoding;
    if (valueX == null) {
      switch (item.type) {
        case QuestionnaireItemType.string:
        case QuestionnaireItemType.text:
          valueX = item.initial?.firstOrNull?.valueString;
          break;
        case QuestionnaireItemType.url:
          valueX = item.initial?.firstOrNull?.valueUri;
          break;
        case QuestionnaireItemType.integer:
          valueX = item.initial?.firstOrNull?.valueInteger;
          break;
        case QuestionnaireItemType.decimal:
          valueX = item.initial?.firstOrNull?.valueDecimal;
          break;
        case QuestionnaireItemType.boolean:
          valueX = item.initial?.firstOrNull?.valueBoolean;
          break;
        case QuestionnaireItemType.choice:
        case QuestionnaireItemType.openChoice:
          valueX = item.initial?.firstOrNull?.valueCoding;
          break;
        case QuestionnaireItemType.date:
          valueX = item.initial?.firstOrNull?.valueDate;
          break;
        case QuestionnaireItemType.time:
          valueX = item.initial?.firstOrNull?.valueTime;
          break;
        case QuestionnaireItemType.dateTime:
          valueX = item.initial?.firstOrNull?.valueDateTime;
          break;
        case QuestionnaireItemType.quantity:
          valueX = item.initial?.firstOrNull?.valueQuantity;
          break;
        case QuestionnaireItemType.attachment:
          valueX = item.initial?.firstOrNull?.valueAttachment;
          break;
        case QuestionnaireItemType.display_:
        // Exclude this type as it doesn't require an answer from the user.
        case QuestionnaireItemType.group:
          // The answers of a group are the answers of the children
          break;
        default:
      }
    }

    if (valueX != null) {
      answers = [QuestionnaireResponseAnswer(valueX: valueX)];
    }

    return answers;
  }

  /// Generates a questionnaire response item from a questionnaire item.
  ///
  /// Recursively creates response items for all child items and generates answers
  /// from initial values. Filters answers to only include those matching the
  /// questionnaire's answer options.
  ///
  /// Parameters:
  ///   * [questionnaireItem] - The questionnaire item to convert
  ///
  /// Returns:
  ///   A [QuestionnaireResponseItem] with populated answers and child items.
  static QuestionnaireResponseItem generateQuestionnaireResponseItem(
    QuestionnaireItem questionnaireItem,
  ) {
    final List<QuestionnaireResponseItem> responseItems = [];
    for (var subItem in questionnaireItem.item ?? []) {
      responseItems.add(generateQuestionnaireResponseItem(subItem));
    }
    final answers = generateAnswers(questionnaireItem);
    return QuestionnaireResponseItem(
      linkId: questionnaireItem.linkId,
      definition: questionnaireItem.definition,
      text: questionnaireItem.text,
      answer: answers
          ?.where(
            (answer) => (questionnaireItem.answerOption?.any(
                  (option) => answer.valueX == option.valueX,
                ) ??
                false),
          )
          .toList(),
      item: responseItems,
      // extension_: subItem.item.extension_,
    );
  }

  /// Generates an initial questionnaire response from a questionnaire definition.
  ///
  /// Creates a complete questionnaire response with initial values populated from
  /// the questionnaire item definitions. The response is marked as 'inProgress'.
  ///
  /// Parameters:
  ///   * [questionnaire] - The questionnaire definition to use
  ///
  /// Returns:
  ///   A new [QuestionnaireResponse] with initial values populated.
  static QuestionnaireResponse generateInitialQuestionnaireResponse(
    Questionnaire questionnaire,
  ) {
    final List<QuestionnaireResponseItem> responseItems = [];
    for (QuestionnaireItem subItem in questionnaire.item ?? []) {
      responseItems.add(generateQuestionnaireResponseItem(subItem));
    }

    final responseItem = QuestionnaireResponse(
      status: QuestionnaireResponseStatus.inProgress,
      questionnaire: questionnaire.getFhirCanonical,
      item: responseItems,
    );

    return responseItem;
  }

  /// Finds a questionnaire response item by its linkId.
  ///
  /// Searches through the response item hierarchy for an item with the matching linkId.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The questionnaire response to search
  ///   * [linkId] - The linkId to search for
  ///
  /// Returns:
  ///   The [QuestionnaireResponseItem] with the matching linkId, or null if not found.
  static QuestionnaireResponseItem? findIsolatedItemByLinkId(
    QuestionnaireResponse questionnaireResponse,
    String linkId,
  ) {
    List<QuestionnaireResponseItem> items = questionnaireResponse.item ?? [];
    for (QuestionnaireResponseItem responseItem in items) {
      final found = _findItem(responseItem, linkId);
      if (found != null) {
        return found;
      }
    }

    return null;
  }

  /// Finds a questionnaire response item by its linkId.
  ///
  /// Searches through the response item hierarchy for an item with the matching linkId.
  /// Handles nullable linkId parameter.
  ///
  /// Parameters:
  ///   * [questionnaireResponse] - The questionnaire response to search
  ///   * [linkId] - The linkId to search for (nullable)
  ///
  /// Returns:
  ///   The [QuestionnaireResponseItem] with the matching linkId, or null if not found.
  static QuestionnaireResponseItem? findIsolatedItem(
    QuestionnaireResponse questionnaireResponse,
    String? linkId,
  ) {
    List<QuestionnaireResponseItem> items = questionnaireResponse.item ?? [];
    for (QuestionnaireResponseItem responseItem in items) {
      final found = _findItem(responseItem, linkId);
      if (found != null) {
        return found;
      }
    }

    return null;
  }

  /// Recursively searches for a questionnaire response item by linkId.
  ///
  /// Checks if the current item's linkId matches the target, then recursively
  /// searches child items if no match is found.
  ///
  /// Parameters:
  ///   * [questionnaireResponseItem] - The response item to search from
  ///   * [linkId] - The linkId to search for
  ///
  /// Returns:
  ///   The [QuestionnaireResponseItem] with the matching linkId, or null if not found.
  static QuestionnaireResponseItem? _findItem(
    QuestionnaireResponseItem questionnaireResponseItem,
    String? linkId,
  ) {
    if (questionnaireResponseItem.linkId.valueString == linkId) {
      return questionnaireResponseItem;
    } else if (questionnaireResponseItem.item != null) {
      for (var element in questionnaireResponseItem.item!) {
        final found = _findItem(element, linkId);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }
}
