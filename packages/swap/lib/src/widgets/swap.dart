import 'package:swap/src/rendering/base.dart';
import 'package:swap/src/rendering/swap.dart';
import 'package:swap/src/widgets/base.dart';

/// A trigger for [Swap].
sealed class SwapTrigger {
  const SwapTrigger();

  const factory SwapTrigger.init() = InitSwapTrigger;

  const factory SwapTrigger.tap() = TapSwapTrigger;
}

/// Swaps when the widget is initialized.
class InitSwapTrigger extends SwapTrigger {
  const InitSwapTrigger();
}

/// Swaps when the widget is tapped.
class TapSwapTrigger extends SwapTrigger {
  const TapSwapTrigger();
}

class Swap extends Widget {
  const Swap({
    super.key,
    this.method = 'GET',
    required this.path,
    this.target,
    this.trigger = const TapSwapTrigger(),
    this.loading,
    required this.child,
  });

  final String method;
  final String path;
  final String? target;
  final SwapTrigger trigger;
  final Widget child;
  final Widget? loading;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSwap(widget: this);
  }
}

class SwapScope extends Widget {
  const SwapScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSwapScope(widget: this);
  }
}

class Slot extends Widget {
  const Slot({
    super.key,
    required this.identifier,
    required this.child,
  });

  final Widget identifier;
  final Widget child;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSlot(widget: this);
  }
}

class SwapInit extends Widget {
  const SwapInit({
    super.key,
    required this.notification,
    required this.child,
  });

  final SwapNotification notification;
  final Widget child;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSwapInit(widget: this);
  }
}

class SwapLink extends Widget {
  const SwapLink({
    super.key,
    required this.notification,
    required this.child,
  });

  final SwapNotification notification;
  final Widget child;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSwapLink(widget: this);
  }
}

sealed class SwapNotification {
  /// Create a new [SwapNotification].
  const SwapNotification();

  const factory SwapNotification.reset(
    String slotId,
  ) = ResetSwapNotification._;

  const factory SwapNotification.fetch(
    String slotId,
    String method,
    String path, {
    dynamic body,
  }) = FetchSwapNotification._;

  const factory SwapNotification.swap(
    String slotId,
    Widget newChild,
  ) = SwapSwapNotification._;

  const factory SwapNotification.setFormData(
    String key,
    dynamic value,
  ) = SetFormDataSwapNotification._;

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
