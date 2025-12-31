import 'package:flutter/material.dart';

final class SegmentedChoice<T extends Object> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final bool enabled;
  final String Function(T value) valueNameResolver;
  final void Function(T value) onSelectedValueChanged;
  SegmentedChoice({
    required this.values,
    required this.enabled,
    required this.selectedValue,
    required this.valueNameResolver,
    required this.onSelectedValueChanged,
    super.key,
  }) : assert(values.isNotEmpty, "The option values can't be empty");

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {}
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<T>(
            emptySelectionAllowed: true,
            segments:
                values
                    .map(
                      (entry) => ButtonSegment<T>(
                        value: entry,
                        enabled: enabled,
                        label: Text(valueNameResolver(entry)),
                      ),
                    )
                    .toList(),
            selected: selectedValue != null ? {selectedValue!} : {},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                onSelectedValueChanged(newSelection.first);
              }
            },
          ),
        ),
      ],
    );
  }
}
