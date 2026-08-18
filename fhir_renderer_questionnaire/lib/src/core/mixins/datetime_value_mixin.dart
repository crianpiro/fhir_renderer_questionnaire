import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';
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
        final selected =
            responseItem?.answer?.firstOrNull?.valueDateTime?.toDateTime();
        final initial =
            questionnaireItem.initial?.firstOrNull?.valueDateTime?.toDateTime();
        final value = selected ?? initial;
        displayText = value != null
            ? DateFormat.yMd().add_jm().format(value)
            : "Select date & time";
        break;
      case QuestionnaireItemType.date:
        final selected =
            responseItem?.answer?.firstOrNull?.valueDate?.toDateTime();
        final initial =
            questionnaireItem.initial?.firstOrNull?.valueDate?.toDateTime();
        final value = selected ?? initial;
        displayText =
            value != null ? DateFormat.yMd().format(value) : "Select date";
        break;
      case QuestionnaireItemType.time:
        final selected = responseItem?.answer?.firstOrNull?.valueTime?.value;
        final initial = questionnaireItem.initial?.firstOrNull?.valueTime?.value;
        displayText = selected ?? initial ?? "Select time";
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

    // Only one of these ends up set, matching the item's type.
    FhirDate? answerDate;
    FhirDateTime? answerDateTime;
    FhirTime? answerTime;

    if (questionnaireItem.type == QuestionnaireItemType.dateTime ||
        questionnaireItem.type == QuestionnaireItemType.date) {
      selectedDate = await showDatePicker(
        context: context,
        initialDate:
            currentResponseItem?.answer?.firstOrNull?.valueDate?.toDateTime(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (selectedDate != null) {
        answerDate = FhirDate.fromDateTime(selectedDate);
      }
    }

    if (context.mounted &&
        (selectedDate != null &&
                questionnaireItem.type == QuestionnaireItemType.dateTime ||
            questionnaireItem.type == QuestionnaireItemType.time)) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          currentResponseItem?.answer?.firstOrNull?.valueDate?.toDateTime() ??
              DateTime.now(),
        ),
      );

      if (selectedDate != null && selectedTime != null) {
        answerDate = null;
        answerDateTime = FhirDateTime.fromDateTime(
          DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      } else if (selectedTime != null) {
        answerTime = FhirTime.fromDateTime(
          DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute),
        );
      }
    }

    if (answerDate != null || answerDateTime != null || answerTime != null) {
      return QuestionnaireResponseAnswer(
        valueDate: answerDate,
        valueDateTime: answerDateTime,
        valueTime: answerTime,
      );
    }

    return null;
  }
}
