import 'package:fhir_r4/fhir_r4.dart';
import '../extensions/fhir_extensions.dart';

class FhirRendererQuestionnaireResponseUtils {
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

  static QuestionnaireResponse setMultipleAnswerOptionsInQuestionnaireResponse(
    QuestionnaireResponse questionnaireResponse,
    QuestionnaireItem questionnaireItem,
    QuestionnaireAnswerOption questionnaireAnswerOption,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

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

  static QuestionnaireResponseItem? _setAnswerInResponseItem(
    QuestionnaireResponseItem responseItem,
    String? questionnaireItemLinkId,
    QuestionnaireResponseAnswer? answer,
  ) {
    if (responseItem.linkId == questionnaireItemLinkId) {
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

  static QuestionnaireResponseItem? _addAnswerToResponseItem(
    QuestionnaireResponseItem responseItem,
    String? questionnaireItemLinkId,
    QuestionnaireResponseAnswer answer,
  ) {
    if (responseItem.linkId == questionnaireItemLinkId) {
      return _setMultipleResponseAnswers(responseItem, answer);
    } else if (responseItem.item != null) {
      List<QuestionnaireResponseItem>? items = [];

      for (QuestionnaireResponseItem subItem in responseItem.item!) {
        final found = _addAnswerToResponseItem(
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

  static QuestionnaireResponseItem _setResponseAnswer(
    QuestionnaireResponseItem responseItem,
    QuestionnaireResponseAnswer? responseAnswer,
  ) =>
      responseItem.copyWith(
        answer: responseAnswer != null ? [responseAnswer] : [],
      );

  static QuestionnaireResponseItem _setMultipleResponseAnswers(
    QuestionnaireResponseItem responseItem,
    QuestionnaireResponseAnswer responseAnswer,
  ) {
    bool addedAnswer = responseItem.answer?.any(
          (i) =>
              i.valueCoding?.code?.valueString ==
              responseAnswer.valueCoding?.code?.valueString,
        ) ??
        false;
    List<QuestionnaireResponseAnswer> answers;
    if (addedAnswer) {
      answers = responseItem.answer
              ?.where(
                (i) =>
                    i.valueCoding?.code?.valueString !=
                    responseAnswer.valueCoding?.code?.valueString,
              )
              .toList() ??
          [];
    } else {
      answers = responseItem.answer?.toList() ?? [];
      answers.add(responseAnswer);
    }

    return responseItem.copyWith(answer: answers);
  }

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

  static List<QuestionnaireResponseAnswer>? generateAnswers(
    QuestionnaireItem item,
  ) {
    List<QuestionnaireResponseAnswer>? answers;

    if (item.linkId.valueString == "NIT_SVAn_08_01") {
      print("HERE");
    }

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
