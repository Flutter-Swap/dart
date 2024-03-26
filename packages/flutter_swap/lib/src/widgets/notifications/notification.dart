import 'package:flutter/widgets.dart';

abstract class SwapNotification extends Notification {
  /// Create a new [SwapNotification].
  const SwapNotification();

  /// Resets the widget of the slot with the given [slotId].
  ///
  /// The nearest [SwapStore] in the widget tree will handle this notification.
  const factory SwapNotification.reset(
    String slotId,
  ) = ResetSwapNotification._;

  /// Fetches a widget at the given [path], with the given [method], and updates
  /// the slot with the given [slotId].
  ///
  /// A [body] can be provided to be sent with the request.
  ///
  /// The nearest [SwapFetcher] in the widget tree will handle this notification.
  const factory SwapNotification.fetch(
    String slotId,
    String method,
    String path, {
    dynamic body,
  }) = FetchSwapNotification._;

  /// Swaps the slot at the given [slotId] with the given [newChild].
  ///
  /// The nearest [SwapStore] in the widget tree will handle this notification.
  const factory SwapNotification.swap(
    String slotId,
    Widget newChild,
  ) = SwapSwapNotification._;

  /// Swaps asynchronously the slot at the given [slotId] with the
  /// given [newChild].
  ///
  /// The nearest [SwapStore] in the widget tree will handle this notification.
  const factory SwapNotification.async(
    String slotId,
    Future<Widget> swap,
  ) = AsyncSwapNotification._;

  /// Sets the form data of [key] to [value].
  ///
  /// The nearest [SwapFormData] in the widget tree will handle this notification.
  const factory SwapNotification.setFormData(
    String key,
    dynamic value,
  ) = SetFormDataSwapNotification._;

  /// A custom event with the given [identifier] and [data].
  ///
  /// The nearest [SwapNotificationListener] in the widget tree will handle
  /// this notification.
  const factory SwapNotification.custom(
    String identifier,
    dynamic data,
  ) = CustomSwapNotification._;
}

class ResetSwapNotification extends SwapNotification {
  /// Create a new [ResetSwapNotification].
  const ResetSwapNotification._(
    this.slotId,
  );

  final String slotId;
}

class FetchSwapNotification extends SwapNotification {
  /// Create a new [ResetSwapNotification].
  const FetchSwapNotification._(
    this.slotId,
    this.method,
    this.path, {
    this.body,
  });

  final String slotId;
  final String method;
  final String path;
  final dynamic body;
}

class SwapSwapNotification extends SwapNotification {
  /// Create a new [SwapSwapNotification].
  const SwapSwapNotification._(
    this.slotId,
    this.newChild,
  );

  final String slotId;
  final Widget newChild;
}

class AsyncSwapNotification extends SwapNotification {
  /// Create a new [AsyncSwapNotification].
  const AsyncSwapNotification._(
    this.slotId,
    this.swap,
  );

  final String slotId;
  final Future<Widget> swap;
}

class SetFormDataSwapNotification extends SwapNotification {
  /// Create a new [SetFormDataSwapNotification].
  const SetFormDataSwapNotification._(
    this.key,
    this.value,
  );

  final String key;
  final dynamic value;
}

class CustomSwapNotification extends SwapNotification {
  /// Create a new [CustomSwapNotification].
  const CustomSwapNotification._(
    this.identifier,
    this.data,
  );

  final String identifier;
  final dynamic data;
}
