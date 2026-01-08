import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/widgets.dart';

import '../../../fhir_renderer_questionnaire.dart';
import 'inherited_questionnaire_renderer.dart';
import '../../core/definitions/type_definitions.dart';

/// A base abstract class for FHIR Questionnaire renderers.
///
/// This class handles the shared logic for rendering questionnaires, including
/// state management, response generation, and providing builder callbacks for
/// customizing the appearance of different questionnaire item types.
abstract class BaseQuestionnaireRenderer extends StatefulWidget {
  /// Creates a [BaseQuestionnaireRenderer].
  ///
  /// [questionnaire] and [rendererController] are required.
  const BaseQuestionnaireRenderer({
    super.key,
    required this.rendererController,
    this.choiceItemBuilder,
    this.openChoiceItemBuilder,
    this.fieldItemBuilder,
    this.dateTimeItemBuilder,
    this.groupItemBuilder,
    this.boolItemBuilder,
    this.displayItemBuilder,
  });

  /// Controller to manage the state and actions of the questionnaire renderer.
  final RendererQuestionnaireController rendererController;

  /// Custom builder for choice items.
  final QuestionnaireChoiceWidgetBuilder? choiceItemBuilder;

  /// Custom builder for open-choice items.
  final QuestionnaireChoiceWidgetBuilder? openChoiceItemBuilder;

  /// Custom builder for field items (text, integer, decimal, string, time, url).
  final QuestionnaireFieldWidgetBuilder? fieldItemBuilder;

  /// Custom builder for date/time items.
  final QuestionnaireDateTimeWidgetBuilder? dateTimeItemBuilder;

  /// Custom builder for group items.
  final QuestionnaireGroupWidgetBuilder? groupItemBuilder;

  /// Custom builder for boolean items.
  final QuestionnaireBooleanWidgetBuilder? boolItemBuilder;

  /// Custom builder for display items.
  final QuestionnaireDisplayWidgetBuilder? displayItemBuilder;
}

/// The base state for [BaseQuestionnaireRenderer].
///
/// Manages the [questionnaireResponse] state and handles communication
/// with the [rendererController].
abstract class BaseQuestionnaireState extends State<BaseQuestionnaireRenderer>
    with WidgetsBindingObserver {
  /// The current response state of the questionnaire.
  late QuestionnaireResponse questionnaireResponse;
  late bool readOnly;

  /// Whether to validate and check required items.
  bool checkRequiredItems = false;

  /// Helper to access the current response from the inherited widget.
  QuestionnaireResponse? generateQuestionnaireResponse() {
    return InheritedQuestionnaireRenderer.of(context).questionnaireResponse;
  }

  /// Updates the local state when the questionnaire response changes.
  void onResponseChanged(QuestionnaireResponse updatedQuestionnaireResponse) {
    setState(() {
      questionnaireResponse = updatedQuestionnaireResponse;
    });
  }

  /// Triggered when the controller requests to generate/validate the response.
  ///
  /// This sets [checkRequiredItems] to true, forcing validation UI updates,
  /// and focuses the first missing required field if any.
  QuestionnaireResponse onGenerateQuestionnaireResponse() {
    setState(() {
      checkRequiredItems = true;
    });

    //Add the markAsRequired here instead of in building time.
    if (widget.rendererController.indexedItems.isNotEmpty) {
      for (var entry in widget.rendererController.indexedItems.entries) {
        if (entry.value.markedRequired) {
          entry.value.focusNode.requestFocus();
          break;
        }
      }
    }
    return questionnaireResponse;
  }

  void onReadOnlyModeChanged() {
    setState(() {
      readOnly = widget.rendererController.forceReadOnlyView;
    });
  }

  /// Callback executed after the widget is created.
  ///
  /// Used to scroll to the initial index if specified in the controller.
  void onCreated(_) {
    if ((widget is QuestionnaireSliversViewRenderer ||
            widget is QuestionnaireListViewRenderer) &&
        widget.rendererController.groupBundleKeys.isNotEmpty &&
        widget.rendererController.groupBundleKeys.length >
            widget.rendererController.sliversInitialIndex &&
        widget
                .rendererController
                .groupBundleKeys[widget.rendererController.sliversInitialIndex]
                .currentContext !=
            null) {
      Scrollable.ensureVisible(
        widget
            .rendererController
            .groupBundleKeys[widget.rendererController.sliversInitialIndex]
            .currentContext!,
      );
    }
  }

  @override
  void initState() {
    questionnaireResponse =
        widget.rendererController.initialQuestionnaireResponse!;
    readOnly = widget.rendererController.forceReadOnlyView;
    widget.rendererController.onGenerateQuestionnaireResponse =
        onGenerateQuestionnaireResponse;
    widget.rendererController.onReadOnlyModeChanged = onReadOnlyModeChanged;
    WidgetsBinding.instance.addPostFrameCallback(onCreated);
    super.initState();
  }
}
