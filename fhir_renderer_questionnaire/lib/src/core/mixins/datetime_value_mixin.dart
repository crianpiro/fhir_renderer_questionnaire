import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Mixin providing date/time value extraction and selection logic for FHIR questionnaire items.
///
/// Handles date, dateTime, and time type questions including display formatting and picker logic.
mixin DateTimeValueMixin {
  /// Extracts and formats the display text for a date/time item.
  ///
  /// Checks both the response item and initial values, formatting appropriately
  /// based on the question type (date, dateTime, or time).
  ///
  /// Returns a formatted string or a placeholder prompt if no value is set.
  String extractDisplayText(
    QuestionnaireResponseItem? responseItem,
    QuestionnaireItem questionnaireItem,
  ) {
    String displayText = "";

    switch (questionnaireItem.type) {
      case QuestionnaireItemType.dateTime:
        if (responseItem?.answer?.firstOrNull?.valueDateTime?.valueDateTime !=
            null) {
          displayText = DateFormat.yMd()
              .add_jm()
              .format(responseItem!.answer!.first.valueDateTime!.valueDateTime!)
              .toString();
        } else if (questionnaireItem.initial != null &&
            questionnaireItem.initial!.isNotEmpty &&
            questionnaireItem.initial!.first.valueX is FhirDateTime &&
            (questionnaireItem.initial!.first.valueX as FhirDateTime)
                    .valueDateTime !=
                null) {
          displayText = DateFormat.yMd()
              .add_jm()
              .format(
                (questionnaireItem.initial!.first.valueX as FhirDateTime)
                    .valueDateTime!,
              )
              .toString();
        } else {
          displayText = "Select date & time";
        }
        break;
      case QuestionnaireItemType.date:
        if (responseItem?.answer?.firstOrNull?.valueDate?.valueDateTime !=
            null) {
          displayText = DateFormat.yMd()
              .format(
                responseItem!.answer!.first.valueDate!.valueDateTime!,
              )
              .toString();
        } else if (questionnaireItem.initial != null &&
            questionnaireItem.initial!.isNotEmpty &&
            questionnaireItem.initial!.first.valueX is FhirDate &&
            (questionnaireItem.initial!.first.valueX as FhirDate)
                    .valueDateTime !=
                null) {
          displayText = DateFormat.yMd()
              .format(
                (questionnaireItem.initial!.first.valueX as FhirDate)
                    .valueDateTime!,
              )
              .toString();
        } else {
          displayText = "Select date";
        }
        break;
      case QuestionnaireItemType.time:
        if (responseItem?.answer?.firstOrNull?.valueTime?.valueString != null) {
          displayText =
              responseItem!.answer!.firstOrNull!.valueTime!.valueString!;
        } else if (questionnaireItem.initial != null &&
            questionnaireItem.initial!.isNotEmpty &&
            questionnaireItem.initial!.first.valueX is FhirTime &&
            (questionnaireItem.initial!.first.valueX as FhirTime).valueString !=
                null) {
          displayText = (questionnaireItem.initial!.first.valueX as FhirTime)
              .valueString!;
        } else {
          displayText = "Select time";
        }
        break;
      default:
        break;
    }

    return displayText;
  }

  /// Returns the appropriate icon for the date/time item type.
  ///
  /// [type] selects the icon (clock for [QuestionnaireItemType.time], calendar
  /// otherwise). [color] is applied to the resulting [Icon].
  Widget getItemIcon(QuestionnaireItemType type, Color color) {
    switch (type) {
      case QuestionnaireItemType.time:
        return Icon(
          Icons.av_timer,
          color: color,
        );
      case QuestionnaireItemType.dateTime:
      default:
        return Icon(
          Icons.calendar_month,
          color: color,
        );
    }
  }

  /// Shows the appropriate picker(s) for selecting a date/time value.
  ///
  /// Depending on the question type:
  /// - date: Shows date picker only
  /// - time: Shows time picker only
  /// - dateTime: Shows both date and time pickers sequentially
  ///
  /// Returns a QuestionnaireResponseAnswer with the selected value, or null if cancelled.
  Future<QuestionnaireResponseAnswer?> onSelectValue(
    BuildContext context,
    QuestionnaireItem questionnaireItem,
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
        lastDate: DateTime.now().add(const Duration(days: 365)),
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
}
