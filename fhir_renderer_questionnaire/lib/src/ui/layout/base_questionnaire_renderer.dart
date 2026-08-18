import 'package:flutter/widgets.dart';

import '../../../fhir_renderer_questionnaire.dart';
import 'inherited_questionnaire_renderer.dart';

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
    this.referenceItemBuilder,
    this.attachmentItemBuilder,
    this.useExpansibleGroups = false,
  });

  /// Whether to render group items as collapsible [ExpansionTile]-based widgets.
  ///
  /// When `true`, the default group item is replaced with
  /// [QuestionnaireExpansibleGroupItem]. Defaults to `false`, preserving the
  /// standard [QuestionnaireGroupItem] look.
  ///
  /// Currently only honored by [QuestionnaireListViewRenderer].
  final bool useExpansibleGroups;

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

  /// Custom builder for reference items.
  final QuestionnaireReferenceWidgetBuilder? referenceItemBuilder;

  /// Custom builder for attachment items.
  final QuestionnaireAttachmentWidgetBuilder? attachmentItemBuilder;
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
    // Clear the enableWhen cache when response changes to avoid stale state
    widget.rendererController.clearEnableWhenCache();
    // Keep the controller's view of the response current so validate() can run
    // at any time without going through response generation.
    widget.rendererController
        .attachRenderer(response: updatedQuestionnaireResponse);
    if (context.mounted) {
      setState(() {
        questionnaireResponse = updatedQuestionnaireResponse;
      });
    }
  }

  /// Triggered when the controller requests to generate/validate the response.
  ///
  /// Sets [checkRequiredItems] to true so built items highlight, verifies the
  /// response against the questionnaire model, and reveals the first problem.
  ///
  /// Verification deliberately does not consult the widget tree: renderers
  /// build items lazily, so an unanswered required item further down the
  /// questionnaire may have no widget — and no [FocusNode] — at this point.
  QuestionnaireResponse onGenerateQuestionnaireResponse() {
    if (context.mounted) {
      setState(() {
        checkRequiredItems = true;
      });
    }

    final findings = widget.rendererController.validate();
    widget.rendererController.lastFindings = findings;

    if (findings.isNotEmpty) {
      // After this frame, so the highlighting setState above has been applied
      // and the scroll views report up-to-date extents.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) revealFinding(findings.first);
      });
    }

    return questionnaireResponse;
  }

  /// Number of attempts [revealFinding] makes before giving up.
  ///
  /// Each attempt jumps to an estimated offset and lets a frame build; the
  /// estimate improves as more of the list is laid out. A handful of passes is
  /// enough to land on the item in practice.
  static const int _revealAttempts = 6;

  /// Brings the item behind [finding] into view, building it if necessary.
  ///
  /// Focusing the item is the goal: [QuestionnaireItemWrapper] calls
  /// `Scrollable.ensureVisible` when an item takes focus, which lands the item
  /// exactly. That only works once the item is built, so for an item that is
  /// still unbuilt this jumps to an offset estimated from the item's position
  /// in the questionnaire, then retries on the next frame.
  void revealFinding(QuestionnaireFinding finding, {int attempt = 0}) {
    if (!mounted) return;

    final controller = widget.rendererController;
    final focusNode = controller.indexedItems[finding.linkId]?.focusNode;

    if (focusNode != null && focusNode.context != null) {
      focusNode.requestFocus();
      return;
    }

    if (attempt >= _revealAttempts) return;

    _approachFinding(finding);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      revealFinding(finding, attempt: attempt + 1);
    });
  }

  /// Moves the viewport closer to [finding] without needing its widget.
  void _approachFinding(QuestionnaireFinding finding) {
    final controller = widget.rendererController;

    final pageController = controller.pageViewController;
    if (pageController != null && pageController.hasClients) {
      if (pageController.page?.round() != finding.topLevelIndex) {
        pageController.jumpToPage(finding.topLevelIndex);
      }
      return;
    }

    // The views hand their ScrollController to the ListView/CustomScrollView;
    // when the host supplied none, the scroll view attaches to the primary one.
    final scrollController = controller.listViewScrollController ??
        PrimaryScrollController.maybeOf(context);
    if (scrollController == null || !scrollController.hasClients) return;

    final position = scrollController.position;
    final target = position.maxScrollExtent * finding.documentFraction;
    scrollController.jumpTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  void onReadOnlyModeChanged() {
    if (context.mounted) {
      setState(() {
        readOnly = widget.rendererController.forceReadOnlyView;
      });
    }
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
    widget.rendererController.attachRenderer(
      response: questionnaireResponse,
      revealFinding: revealFinding,
    );
    widget.rendererController.onGenerateQuestionnaireResponse =
        onGenerateQuestionnaireResponse;
    widget.rendererController.onReadOnlyModeChanged = onReadOnlyModeChanged;
    WidgetsBinding.instance.addPostFrameCallback(onCreated);
    widget.rendererController.onExternalResponseUpdate = onResponseChanged;
    super.initState();
  }

  @override
  void dispose() {
    widget.rendererController.initialQuestionnaireResponse =
        questionnaireResponse;
    widget.rendererController.onExternalResponseUpdate = null;
    widget.rendererController.detachRenderer();
    // Note: Controller disposal is the responsibility of the owner, not the renderer
    super.dispose();
  }
}
