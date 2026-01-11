import 'package:flutter/widgets.dart';

final class ItemBehavioralData {
  final int index;
  final bool markAsRequired;
  final List<String>? dependentOn;
  final FocusNode focusNode;
  final TextEditingController? textController;

  ItemBehavioralData(
      {required this.index,
      required this.markAsRequired,
      required this.focusNode,
      this.textController,
      this.dependentOn});

  ItemBehavioralData copyWith({
    int? index,
    bool? enabled,
    bool? markAsRequired,
    FocusNode? focusNode,
    List<String>? dependentOn,
    TextEditingController? textController,
  }) =>
      ItemBehavioralData(
        index: index ?? this.index,
        focusNode: focusNode ?? this.focusNode,
        dependentOn: dependentOn ?? this.dependentOn,
        markAsRequired: markAsRequired ?? this.markAsRequired,
        textController: textController ?? this.textController,
      );
}
