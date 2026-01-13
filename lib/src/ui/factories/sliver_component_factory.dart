import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import 'questionnaire_component_factory.dart';
import '../components/slivers/questionnaire_sliver_display_item.dart';
import '../components/slivers/questionnaire_sliver_boolean_item.dart';
import '../components/slivers/questionnaire_sliver_field_item.dart';
import '../components/slivers/questionnaire_sliver_date_time_item.dart';
import '../components/slivers/questionnaire_sliver_choice_item.dart';
import '../components/slivers/questionnaire_sliver_open_choice_item.dart';
import '../components/slivers/questionnaire_sliver_group_item.dart';
import '../components/slivers/questionnaire_sliver_attachment_item.dart';
import '../components/slivers/questionnaire_sliver_reference_item.dart';
import '../components/slivers/questionnaire_sliver_item_wrapper.dart';
import '../components/slivers/sliver_base_decorator.dart';

/// Factory implementation for creating sliver-based questionnaire widgets.
///
/// This factory creates Sliver widgets for use in CustomScrollView contexts,
/// suitable for the SliversViewRenderer with advanced scrolling effects.
final class SliverComponentFactory implements QuestionnaireComponentFactory {
  const SliverComponentFactory();

  @override
  Widget createDisplayItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverDisplayItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createBooleanItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverBooleanItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createFieldItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverFieldItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createDateTimeItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverDateTimeItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createChoiceItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverChoiceItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createOpenChoiceItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverOpenChoiceItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createGroupItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverGroupItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createAttachmentItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverAttachmentItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createReferenceItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireSliverReferenceItem(
      index: index,
      questionnaireItem: item,
      isLastItem: isLastItem,
    );
  }

  @override
  Widget createUnimplementedItem(
    String typeName,
    bool isLastItem,
  ) {
    return SliverBaseDecorator(
      title: "Unimplemented type: $typeName",
      useNotImplementedStyle: true,
      roundBottomBorder: false,
    );
  }

  @override
  Widget createItemWrapper({
    required int index,
    required QuestionnaireItem questionnaireItem,
    required bool isLastItem,
  }) {
    return QuestionnaireSliverItemWrapper(
      index: index,
      questionnaireItem: questionnaireItem,
      isLastItem: isLastItem,
    );
  }
}
