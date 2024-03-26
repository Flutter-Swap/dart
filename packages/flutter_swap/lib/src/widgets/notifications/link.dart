import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/widgets/store.dart';

import 'notification.dart';

/// Sends a [SwapNotification] when tapped.
class SwapLink extends StatelessWidget {
  const SwapLink({
    super.key,
    required this.notification,
    required this.child,
  });

  final Widget child;

  /// The notification that is sent to the nearest [SwapStore] in the widget
  /// tree when this is tapped.
  final SwapNotification notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        notification.dispatch(context);
      },
      child: child,
    );
  }
}
