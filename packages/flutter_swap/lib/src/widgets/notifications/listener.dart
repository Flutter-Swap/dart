import 'package:flutter/widgets.dart';

import 'notification.dart';

/// Listens to [CustomSwapNotification]s.
class SwapNotificationListener extends StatelessWidget {
  const SwapNotificationListener({
    super.key,
    required this.child,
    required this.onNotification,
  });

  final Widget child;

  final NotificationListenerCallback<CustomSwapNotification> onNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<CustomSwapNotification>(
      onNotification: onNotification,
      child: child,
    );
  }
}
