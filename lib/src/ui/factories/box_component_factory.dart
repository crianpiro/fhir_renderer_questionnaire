import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

import 'questionnaire_component_factory.dart';
import '../components/boxes/questionnaire_display_item.dart';
import '../components/boxes/questionnaire_boolean_item.dart';
import '../components/boxes/questionnaire_field_item.dart';
import '../components/boxes/questionnaire_date_time_item.dart';
import '../components/boxes/questionnaire_choice_item.dart';
import '../components/boxes/questionnaire_open_choice_item.dart';
import '../components/boxes/questionnaire_group_item.dart';
import '../components/boxes/base_decorator.dart';

/// Factory implementation for creating box-based (traditional Container-based) questionnaire widgets.
///
/// This factory creates standard Flutter widgets using Containers and Columns
/// for questionnaire items, suitable for use in ListView and PageView renderers.
final class BoxComponentFactory implements QuestionnaireComponentFactory {
  const BoxComponentFactory();

  @override
  Widget createDisplayItem(
    int index,
    bool isLastItem,
    QuestionnaireItem item,
  ) {
    return QuestionnaireDisplayItem(
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
    return QuestionnaireBooleanItem(
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
    return QuestionnaireFieldItem(
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
    return QuestionnaireDateTimeItem(
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
    return QuestionnaireChoiceItem(
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
    return QuestionnaireOpenChoiceItem(
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
    return QuestionnaireGroupItem(
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
    return BaseDecorator(
      title: "Unimplemented type: $typeName",
      useNotImplementedStyle: true,
      roundBottomBorder: false,
    );
  }
}
