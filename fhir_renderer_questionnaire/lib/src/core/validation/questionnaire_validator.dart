import 'package:fhir_renderer_questionnaire/src/core/models/models.dart';

import '../controllers/renderer_questionnaire_controller.dart';
import '../extensions/fhir_extensions.dart';
import '../mixins/regex_validation_mixin.dart';
import '../utils/fhir_renderer_questionnaire_response_utils.dart';
import '../utils/fhir_renderer_questionnaire_utils.dart';
import 'questionnaire_finding.dart';

/// Verifies a [QuestionnaireResponse] against its [Questionnaire].
///
/// Works on the model, never on the widget tree: renderers build items lazily,
/// so an unanswered required item may not exist as a widget at all. Walking the
/// questionnaire instead means verification covers items the user has never
/// scrolled to.
///
/// Uses the same [RegexValidationMixin] the input widgets use, so a field that
/// shows an inline error also produces a finding, with the same message.
final class QuestionnaireValidator with RegexValidationMixin {
  const QuestionnaireValidator();

  /// Returns every problem in [response], in document order.
  ///
  /// Items disabled by `enableWhen` are skipped along with their descendants.
  /// Passing [controller] reuses its `enableWhen` cache.
  List<QuestionnaireFinding> validate(
    Questionnaire questionnaire,
    QuestionnaireResponse response, {
    RendererQuestionnaireController? controller,
  }) {
    final enabledItems = <_VisitedItem>[];
    final topLevel = questionnaire.item ?? const <QuestionnaireItem>[];

    var topLevelIndex = 0;
    for (final item in topLevel) {
      if (!_isEnabled(response, item, controller)) continue;
      _collect(response, item, controller, topLevelIndex, enabledItems);
      topLevelIndex++;
    }

    final findings = <QuestionnaireFinding>[];
    for (var order = 0; order < enabledItems.length; order++) {
      final visited = enabledItems[order];
      final finding = _inspect(
        response,
        visited,
        order: order,
        documentLength: enabledItems.length,
      );
      if (finding != null) findings.add(finding);
    }

    return findings;
  }

  /// Depth-first walk that records enabled items in the order they render.
  ///
  /// Groups are recorded too: they occupy an entry (their header) in every
  /// renderer, so counting them keeps [QuestionnaireFinding.documentOrder]
  /// aligned with the on-screen entry order used to estimate scroll offsets.
  void _collect(
    QuestionnaireResponse response,
    QuestionnaireItem item,
    RendererQuestionnaireController? controller,
    int topLevelIndex,
    List<_VisitedItem> into,
  ) {
    into.add(_VisitedItem(item: item, topLevelIndex: topLevelIndex));

    for (final child in item.item ?? const <QuestionnaireItem>[]) {
      if (!_isEnabled(response, child, controller)) continue;
      _collect(response, child, controller, topLevelIndex, into);
    }
  }

  QuestionnaireFinding? _inspect(
    QuestionnaireResponse response,
    _VisitedItem visited, {
    required int order,
    required int documentLength,
  }) {
    final item = visited.item;
    final linkId = item.linkId;

    // Groups hold no answer of their own and display items take no input.
    if (item.type == QuestionnaireItemType.group ||
        item.type == QuestionnaireItemType.display_) {
      return null;
    }

    final responseItem =
        FhirRendererQuestionnaireResponseUtils.findIsolatedItem(
      response,
      linkId,
    );
    final answers = responseItem?.answer;
    final isAnswered = answers != null && answers.isNotEmpty;

    QuestionnaireFinding buildFinding(
      QuestionnaireFindingReason reason, {
      String? message,
    }) =>
        QuestionnaireFinding(
          linkId: linkId,
          text: item.displayTitle,
          reason: reason,
          message: message,
          documentOrder: order,
          documentLength: documentLength,
          topLevelIndex: visited.topLevelIndex,
        );

    if (!isAnswered) {
      return (item.required_ ?? false)
          ? buildFinding(QuestionnaireFindingReason.missingRequired)
          : null;
    }

    final value = answers.first.valueString;
    if (value == null || value.isEmpty) return null;

    final message = validateInput(
      value,
      item.regexValidationPattern,
      item.regexValidationErrorMessage,
      itemType: item.type,
    );

    return message == null
        ? null
        : buildFinding(
            QuestionnaireFindingReason.invalidFormat,
            message: message,
          );
  }

  bool _isEnabled(
    QuestionnaireResponse response,
    QuestionnaireItem item,
    RendererQuestionnaireController? controller,
  ) =>
      FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
        response,
        item,
        controller: controller,
      );
}

/// An enabled item paired with the top-level item it descends from.
final class _VisitedItem {
  final QuestionnaireItem item;
  final int topLevelIndex;

  const _VisitedItem({required this.item, required this.topLevelIndex});
}
