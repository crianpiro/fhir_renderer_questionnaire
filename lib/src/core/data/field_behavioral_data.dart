import 'package:flutter/material.dart';

class FieldBehavioralData {
  final int index;
  final bool enabled;
  final bool markedRequired;
  final FocusNode focusNode;
  final TextEditingController? textController;

  FieldBehavioralData({
    required this.index,
    required this.enabled,
    required this.markedRequired,
    required this.focusNode,
    this.textController,
  });

  FieldBehavioralData copyWith({
    int? index,
    bool? enabled,
    bool? markedRequired,
    FocusNode? focusNode,
    TextEditingController? textController,
  }) =>
      FieldBehavioralData(
        index: index ?? this.index,
        markedRequired: markedRequired ?? this.markedRequired,
        enabled: enabled ?? this.enabled,
        focusNode: focusNode ?? this.focusNode,
        textController: textController ?? this.textController,
      );
}
