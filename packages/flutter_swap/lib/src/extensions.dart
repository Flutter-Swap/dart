import 'package:flutter/widgets.dart';

import 'widgets/notifications/notification.dart';

extension SwapOperationExtension on BuildContext {
  /// The [SwapOperation] for this [BuildContext].
  SwapOperation get swap => SwapOperation(this);
}

class SwapOperation {
  const SwapOperation(this.context);

  final BuildContext context;

  /// Swaps the slot at the given [slotId] with the given [newChild].
  void call(
    String slotId,
    Widget newChild,
  ) {
    SwapNotification.swap(
      slotId,
      newChild,
    ).dispatch(context);
  }

  /// Swaps the slot at the given [slotId] with the given [newChild].
  void async(
    String slotId,
    Widget newChild,
    Future<Widget> swap,
  ) {
    SwapNotification.async(
      slotId,
      swap,
    ).dispatch(context);
  }

  /// Sends a GET request at [path] to the given path and swaps the given
  /// [target] with the resulting deserialized widget.
  void get(
    String slotId,
    String path,
  ) {
    SwapNotification.fetch(
      slotId,
      'GET',
      path,
    ).dispatch(context);
  }

  /// Sends a POST request at [path] to the given path and swaps the given
  /// [target] with the resulting deserialized widget.
  void post(
    String slotId,
    String path, {
    dynamic body,
  }) =>
      SwapNotification.fetch(
        slotId,
        'POST',
        path,
        body: body,
      ).dispatch(context);

  /// Sends a POST request at [path] to the given path and swaps the given
  /// [target] with the resulting deserialized widget.
  void fetch(
    String slotId,
    String method,
    String path,
  ) =>
      SwapNotification.fetch(
        slotId,
        method,
        path,
      ).dispatch(context);

  /// Reset the slot at the given [slotId].
  void reset(String slotId) {
    SwapNotification.reset(
      slotId,
    ).dispatch(context);
  }

  /// All the added data will be sent as the body of post requests.
  void setFormData(
    String key,
    dynamic value,
  ) {
    SwapNotification.setFormData(
      key,
      value,
    ).dispatch(context);
  }
}
