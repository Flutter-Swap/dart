import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/client/request.dart';
import 'package:flutter_swap/src/widgets/configuration.dart';
import 'package:flutter_swap/src/widgets/form.dart';

import 'notifications/notification.dart';
import 'store.dart';

class SwapFetcher extends StatelessWidget {
  const SwapFetcher({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Fetches the widget at the given [path] and swaps the slot with the given
  /// [id] with the fetched widget.
  ///
  /// The [method] is the HTTP method to use for the request.
  ///
  /// A [body] can be sent with the request.
  static Future<void> fetch(
    BuildContext context,
    String id,
    String method,
    String path, {
    dynamic body,
  }) async {
    final store = SwapStore.of(context);
    final configuration = SwapConfiguration.of(context);
    final formData = SwapFormData.of(context);
    return store.asyncSwap(id, () async {
      final response = await configuration.client.fetch(
        SwapClientRequest(
          method,
          path,
          body: switch (body) {
            null => method == 'POST' ? formData : null,
            _ => body,
          },
        ),
      );
      return configuration.deserializer.deserialize(response);
    }());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FetchSwapNotification>(
      onNotification: (notification) {
        fetch(
          context,
          notification.slotId,
          notification.method,
          notification.path,
          body: notification.body,
        );
        return true;
      },
      child: child,
    );
  }
}
