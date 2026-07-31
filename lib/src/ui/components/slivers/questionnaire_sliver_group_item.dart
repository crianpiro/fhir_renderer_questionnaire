import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_group_item.dart';
import 'package:flutter/material.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../questionnaire_styles.dart';
import '../../../core/extensions/fhir_extensions.dart';
import '../boxes/questionnaire_item_wrapper.dart';
import 'questionnaire_sliver_item_wrapper.dart';

final class QuestionnaireSliverGroupItem extends QuestionnaireGroupItem {
  const QuestionnaireSliverGroupItem({
    super.key,
    required super.index,
    required super.questionnaireItem,
    required super.isLastItem,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    final List<QuestionnaireItem> items =
        getFilteredGroupItems(questionnaireItem, inheritedData) ??
            const <QuestionnaireItem>[];

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 1,
          titleTextStyle: QuestionnaireStyles.groupTitleStyle(context),
          title: QuestionnaireStyles.groupTitleRow(context,
              title: questionnaireItem.displayTitle, ellipsize: true),
        ),
        if (_canBuildLazily(inheritedData, items))
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => QuestionnaireItemWrapper(
                key: ValueKey(items[i].linkId.valueString),
                questionnaireItem: items[i],
                index: i,
                isLastItem: items.length - 1 == i,
              ),
              childCount: items.length,
            ),
          )
        else
          ...List.generate(
              items.length,
              (i) => QuestionnaireSliverItemWrapper(
                    questionnaireItem: items[i],
                    index: i,
                    isLastItem: items.length - 1 == i,
                  )),
      ],
    );
  }

  /// Whether this group's children can go into a lazy [SliverList].
  ///
  /// A list of slivers is inflated in full as soon as it mounts, so a group
  /// spelled out that way builds every question it holds — the cost the list
  /// view renderer avoids by flattening. [SliverChildBuilderDelegate] builds
  /// only what the viewport needs, but its children are box widgets, so this
  /// path is only available where box widgets are equivalent:
  ///
  /// * no child may have a custom builder — builders for this renderer return
  ///   `Sliver*` widgets by contract, which cannot be a delegate's child;
  /// * no child may be a group — nested groups render as pinned [SliverAppBar]
  ///   headers, and pinning only works for a sliver in the scroll view.
  ///
  /// Everything else (fields, choices, booleans, dates, …) renders through
  /// [SliverBaseDecorator], which mirrors [BaseDecorator] exactly, so the lazy
  /// path is visually identical to the eager one.
  bool _canBuildLazily(
    InheritedQuestionnaireRenderer inheritedData,
    List<QuestionnaireItem> items,
  ) =>
      items.every((item) =>
          item.type != QuestionnaireItemType.group &&
          !inheritedData.hasCustomBuilderFor(item.type));
}
