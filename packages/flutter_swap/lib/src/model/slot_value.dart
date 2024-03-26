import 'package:flutter/widgets.dart';

sealed class SlotValue {
  const SlotValue();

  const factory SlotValue.notSwapped() = SlotValueNotSwapped;

  const factory SlotValue.swapping({
    required Widget? previousChild,
  }) = SlotValueSwapping;

  const factory SlotValue.swapFailed({
    dynamic error,
    StackTrace? stackTrace,
    Widget? previousChild,
  }) = SlotValueSwapFailed;

  const factory SlotValue.swapped({
    required Widget child,
  }) = SlotValueSwapped;
}

class SlotValueNotSwapped extends SlotValue {
  const SlotValueNotSwapped();
}

class SlotValueSwapping extends SlotValue {
  const SlotValueSwapping({
    required this.previousChild,
  });

  final Widget? previousChild;
}

class SlotValueSwapFailed extends SlotValue {
  const SlotValueSwapFailed({
    this.error,
    this.stackTrace,
    this.previousChild,
  });

  final dynamic error;
  final StackTrace? stackTrace;
  final Widget? previousChild;
}

class SlotValueSwapped extends SlotValue {
  const SlotValueSwapped({
    required this.child,
  });

  final Widget child;
}
