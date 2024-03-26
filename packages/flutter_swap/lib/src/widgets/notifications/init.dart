import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/widgets/store.dart';

import 'notification.dart';

/// Sends a [SwapNotification] when initialized.
class SwapInit extends StatefulWidget {
  const SwapInit({
    super.key,
    required this.notification,
    required this.child,
  });

  final Widget child;

  /// The notification that is sent to the nearest [SwapStore] in the widget
  /// tree when this is initialized.
  final SwapNotification notification;

  @override
  State<SwapInit> createState() => _InitState();
}

class _InitState extends State<SwapInit> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.notification.dispatch(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
