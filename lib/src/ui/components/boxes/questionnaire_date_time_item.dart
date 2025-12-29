import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/data/questionnaire_renderer_data.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

class QuestionnaireDateTimeItem extends QuestionnaireBaseItem {
  const QuestionnaireDateTimeItem({
    super.key,
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
  });

  Widget getItemIcon() {
    switch (questionnaireItem.type) {
      case QuestionnaireItemType.time:
        return Icon(Icons.av_timer);
      case QuestionnaireItemType.dateTime:
      default:
        return Icon(Icons.calendar_month);
    }
  }

  String extractDisplayText(
    QuestionnaireResponseItem? questionnaireResponseItem,
  ) {
    String displayText = "";

    switch (questionnaireItem.type) {
      case QuestionnaireItemType.dateTime:
        if (questionnaireResponseItem
                ?.answer?.firstOrNull?.valueDateTime?.valueDateTime !=
            null) {
          displayText = DateFormat.yMd()
              .add_jm()
              .format(
                questionnaireResponseItem!
                    .answer!.first.valueDateTime!.valueDateTime!,
              )
              .toString();
        } else {
          displayText = "Select date & time";
        }
        break;
      case QuestionnaireItemType.date:
        if (questionnaireResponseItem
                ?.answer?.firstOrNull?.valueDate?.valueDateTime !=
            null) {
          displayText = DateFormat.yMd()
              .format(
                questionnaireResponseItem!
                    .answer!.first.valueDate!.valueDateTime!,
              )
              .toString();
        } else {
          displayText = "Select date";
        }
      case QuestionnaireItemType.time:
        if (questionnaireResponseItem
                ?.answer?.firstOrNull?.valueTime?.valueString !=
            null) {
          displayText = questionnaireResponseItem!
              .answer!.firstOrNull!.valueTime!.valueString!;
        } else {
          displayText = "Select time";
        }
      default:
        break;
    }

    return displayText;
  }

  Future<QuestionnaireResponseAnswer?> onSelectValue(
    BuildContext context,
    QuestionnaireResponseItem? currentResponseItem,
  ) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    ValueXQuestionnaireResponseAnswer? selectedAnswer;

    if (questionnaireItem.type == QuestionnaireItemType.dateTime ||
        questionnaireItem.type == QuestionnaireItemType.date) {
      selectedDate = await showDatePicker(
        context: context,
        initialDate:
            currentResponseItem?.answer?.firstOrNull?.valueDate?.valueDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      );

      if (selectedDate != null) {
        selectedAnswer = FhirDate.fromDateTime(selectedDate);
      }
    }

    if (context.mounted &&
        (selectedDate != null &&
                questionnaireItem.type == QuestionnaireItemType.dateTime ||
            questionnaireItem.type == QuestionnaireItemType.time)) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          currentResponseItem?.answer?.firstOrNull?.valueDate?.valueDateTime ??
              DateTime.now(),
        ),
      );

      if (selectedDate != null && selectedTime != null) {
        selectedAnswer = FhirDateTime.fromDateTime(
          DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      } else if (selectedTime != null) {
        selectedAnswer = FhirTime.fromUnits(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        );
      }
    }
    if (selectedAnswer != null) {
      return QuestionnaireResponseAnswer(valueX: selectedAnswer);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentResponseItem = findQuestionnaireResponseItem(
      QuestionnaireRendererData.of(context).questionnaireResponse,
      questionnaireItem.linkId.valueString,
    );

    String? displayText = extractDisplayText(currentResponseItem);

    return BaseDecorator(
      title: questionnaireItem.text?.valueString,
      roundBottomBorder: isLastItem,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        onPressed: () async {
          final selectedValue = await onSelectValue(
            context,
            currentResponseItem,
          );

          if (context.mounted && selectedValue != null) {
            QuestionnaireRendererData.of(context).onResponseChanged(
              FhirRendererQuestionnaireResponseUtils
                  .setResponseAnswerInQuestionnaireResponse(
                QuestionnaireRendererData.of(context).questionnaireResponse,
                questionnaireItem,
                selectedValue,
              ),
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: getItemIcon(),
            ),
            Text(displayText),
          ],
        ),
      ),
    );
  }
}
