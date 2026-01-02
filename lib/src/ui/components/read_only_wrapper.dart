import 'package:flutter/widgets.dart';

final class ReadOnlyWrapper extends StatelessWidget {
  final Widget child;
  final bool ignoring;
  const ReadOnlyWrapper({
    required this.ignoring,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(ignoring: ignoring, child: child);
  }
}
