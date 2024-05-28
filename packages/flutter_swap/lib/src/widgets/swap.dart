import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/widgets/slot.dart';

import 'notifications/notification.dart';
import 'notifications/init.dart';
import 'notifications/link.dart';

/// A trigger for [Swap].
sealed class SwapTrigger {
  const SwapTrigger();
}

/// Swaps when the widget is initialized.
class InitSwapTrigger extends SwapTrigger {
  const InitSwapTrigger();
}

/// Swaps when the widget is tapped.
class TapSwapTrigger extends SwapTrigger {
  const TapSwapTrigger();
}

/// A widget that swaps a [target] slot with the widget at the given [path] when
/// the [trigger] is triggered.
class Swap extends StatefulWidget {
  const Swap({
    super.key,
    this.method = 'GET',
    required this.path,
    this.target,
    this.trigger = const TapSwapTrigger(),
    this.loadingBuilder,
    required this.child,
  });

  final String method;
  final String path;
  final String? target;
  final SwapTrigger trigger;
  final Widget child;
  final SwappingWidgetBuilder? loadingBuilder;

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  static int _lastIdentifier = 0;
  late final String identifier = 'auto_${_lastIdentifier++}';

  Widget buildChild() {
    final notification = SwapNotification.fetch(
      widget.target ?? identifier,
      widget.method,
      widget.path,
    );
    return switch (widget.trigger) {
      InitSwapTrigger _ => SwapInit(
          notification: notification,
          child: widget.child,
        ),
      TapSwapTrigger _ => SwapLink(
          notification: notification,
          child: widget.child,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.target != null) {
      return buildChild();
    }
    return Slot(
      identifier: identifier,
      notSwappedBuilder: (context) => buildChild(),
      swappingBuilder: widget.loadingBuilder,
    );
  }
}
