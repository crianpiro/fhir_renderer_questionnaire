import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

/// Abstract factory for creating questionnaire item widgets.
///
/// Defines the interface for creating both box-based and sliver-based
/// questionnaire components. Implementations should create the appropriate
/// widget type (box or sliver) for each item type.
abstract class QuestionnaireComponentFactory {
  /// Creates a display item widget.
  Widget createDisplayItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a boolean (Yes/No) item widget.
  Widget createBooleanItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a text field item widget (for string, text, integer, decimal, url, quantity types).
  Widget createFieldItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a date/time picker item widget (for date, dateTime, time types).
  Widget createDateTimeItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a single-choice item widget.
  Widget createChoiceItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a multi-choice (open-choice) item widget.
  Widget createOpenChoiceItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a group item widget (container for nested items).
  Widget createGroupItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  );

  /// Creates a placeholder widget for unimplemented item types.
  Widget createUnimplementedItem(
    String typeName,
    bool isLastItem,
  );

  /// Creates an item wrapper widget (used for custom builders).
  /// Returns QuestionnaireItemWrapper for box factory,
  /// QuestionnaireSliverItemWrapper for sliver factory.
  Widget createItemWrapper({
    required int index,
    required QuestionnaireItem questionnaireItem,
    required bool isLastItem,
  });
}
