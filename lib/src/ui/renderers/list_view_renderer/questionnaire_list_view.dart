import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/core/utils/fhir_renderer_questionnaire_utils.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/base_decorator.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_segments.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_item_wrapper.dart';
import 'package:fhir_renderer_questionnaire/src/ui/factories/box_component_factory.dart';
import 'package:fhir_renderer_questionnaire/src/ui/layout/inherited_questionnaire_renderer.dart';
import 'package:flutter/material.dart';

class QuestionnaireListView extends StatelessWidget {
  final bool useExpansibleGroups;
  const QuestionnaireListView({super.key, this.useExpansibleGroups = false});

  @override
  Widget build(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    List<QuestionnaireItem>? items = inheritedData.questionnaire.item
        ?.where(
          (i) => FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
            inheritedData.questionnaireResponse,
            i,
            controller: inheritedData.rendererController,
          ),
        )
        .toList();

    if (items != null) {
      final entries = _buildListEntries(items, inheritedData);

      return GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        // Only detect taps on empty space, not on child widgets
        behavior: HitTestBehavior.opaque,
        child: ListView.builder(
          itemCount: entries.length,
          controller: inheritedData.rendererController.listViewScrollController,
          itemBuilder: (context, index) => entries[index],
        ),
      );
    }

    return const BaseDecorator(
        title: "No items to list", roundBottomBorder: false);
  }

  /// Flattens default-rendered groups into one list entry per child.
  ///
  /// A group rendered as a single Column forces the whole group subtree to be
  /// built and laid out the moment it enters the cache extent, which defeats
  /// ListView.builder's laziness and causes frame spikes on scroll. Emitting
  /// the header and each child as separate entries keeps builds per-question.
  ///
  /// Nested groups flatten too, so depth doesn't reintroduce the problem: their
  /// entries are hoisted into the same flat list and re-create the enclosing
  /// surfaces with [QuestionnaireGroupSurface].
  ///
  /// Groups with a custom [InheritedQuestionnaireRenderer.groupItemBuilder] or
  /// rendered as expansible tiles keep the original single-entry rendering.
  List<Widget> _buildListEntries(
    List<QuestionnaireItem> items,
    InheritedQuestionnaireRenderer inheritedData,
  ) {
    final factory =
        BoxComponentFactory(useExpansibleGroups: useExpansibleGroups);
    final entries = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isLastItem = index == items.length - 1;

      if (!_shouldFlatten(item, inheritedData)) {
        entries.add(QuestionnaireItemWrapper(
          key: ValueKey(item.linkId.valueString),
          factory: factory,
          questionnaireItem: item,
          index: index,
          isLastItem: isLastItem,
        ));
        continue;
      }

      entries.addAll(_groupEntries(item, inheritedData));
    }

    return entries;
  }

  /// Whether [item] is a group this renderer draws itself, and may therefore
  /// slice into separate entries.
  bool _shouldFlatten(
    QuestionnaireItem item,
    InheritedQuestionnaireRenderer inheritedData,
  ) =>
      item.type == QuestionnaireItemType.group &&
      inheritedData.groupItemBuilder == null &&
      !useExpansibleGroups;

  /// Builds the entries for one group: its header, then its children.
  ///
  /// A child that is itself a flattenable group contributes its own entries,
  /// each wrapped in a [QuestionnaireGroupSurface] that stands in for this
  /// group's card — the surface those entries would have been painted on had
  /// they stayed inside it.
  List<Widget> _groupEntries(
    QuestionnaireItem group,
    InheritedQuestionnaireRenderer inheritedData,
  ) {
    final children = group.item
            ?.where(
              (child) =>
                  FhirRendererQuestionnaireUtils.isQuestionnaireItemEnabled(
                inheritedData.questionnaireResponse,
                child,
                controller: inheritedData.rendererController,
              ),
            )
            .toList() ??
        <QuestionnaireItem>[];

    final entries = <Widget>[
      QuestionnaireGroupHeader(
        key: ValueKey('${group.linkId.valueString}_header'),
        group: group,
        hasChildren: children.isNotEmpty,
      ),
    ];

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final isLastChild = i == children.length - 1;

      if (!_shouldFlatten(child, inheritedData)) {
        entries.add(QuestionnaireGroupChild(
          key: ValueKey(child.linkId.valueString),
          questionnaireItem: child,
          index: i,
          isLastChild: isLastChild,
        ));
        continue;
      }

      final nested = _groupEntries(child, inheritedData);
      for (var j = 0; j < nested.length; j++) {
        entries.add(QuestionnaireGroupSurface(
          key: ValueKey('${child.linkId.valueString}_surface_$j'),
          closes: isLastChild && j == nested.length - 1,
          leadingDivider: i > 0 && j == 0,
          child: nested[j],
        ));
      }
    }

    return entries;
  }
}
