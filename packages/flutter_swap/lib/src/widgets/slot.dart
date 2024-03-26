import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/model/slot_value.dart';
import 'package:flutter_swap/src/widgets/store.dart';

import 'loader.dart';

typedef SlotWidgetBuilder = Widget Function(
  BuildContext context,
  SlotValue state,
);

typedef SwappingWidgetBuilder = Widget Function(
  BuildContext context,
  Widget? previousChild,
);

typedef SwappingFailedBuilder = Widget Function(
  BuildContext context,
  Widget? previousChild,
  dynamic error,
  StackTrace? stackTrace,
);

/// A widget that can be swaped to another one.
class Slot extends StatelessWidget {
  const Slot.builder({
    super.key,
    required this.identifier,
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
  });

  Slot({
    super.key,
    required this.identifier,
    required WidgetBuilder notSwappedBuilder,
    SwappingWidgetBuilder? swappingBuilder,
    SwappingFailedBuilder? swapFailedBuilder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
  }) : builder = ((BuildContext context, SlotValue state) {
          return switch (state) {
            SlotValueSwapped(child: final child) => child,
            SlotValueSwapping(previousChild: final c) =>
              swappingBuilder?.call(context, c) ??
                  c ??
                  DefaultSwapLoader.of(context, c),
            SlotValueSwapFailed(
              error: final error,
              stackTrace: final st,
              previousChild: final c,
            ) =>
              swapFailedBuilder?.call(context, c, error, st) ??
                  c ??
                  notSwappedBuilder(context),
            _ => notSwappedBuilder(context), // Default
          };
        });

  static SlotData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SlotProvider>()!.data;
  }

  /// The duration of the entrance transition for the new [child] .
  final Duration? duration;

  /// The duration of the exit transition for the old [child] .
  final Duration? reverseDuration;

  /// The identifier of the slot.
  final String identifier;

  /// The widget builder for the slot.
  final SlotWidgetBuilder builder;

  /// The curve to apply when transitioning in a new [child].
  final Curve switchInCurve;

  /// The curve to apply when transitioning out an old [child].
  final Curve switchOutCurve;

  /// A function that wraps a new [child] with an animation that transitions
  /// the [child] in when the animation runs in the forward direction and out
  /// when the animation runs in the reverse direction. This is only called
  /// when a new [child] is set (not for each build), or when a new
  /// [transitionBuilder] is set. If a new [transitionBuilder] is set, then
  /// the transition is rebuilt for the current child and all previous children
  /// using the new [transitionBuilder]. The function must not return null.
  ///
  /// The default is [AnimatedSwitcher.defaultTransitionBuilder].
  ///
  /// The animation provided to the builder has the [duration] and
  /// [switchInCurve] or [switchOutCurve] applied as provided when the
  /// corresponding [child] was first provided.
  ///
  /// See also:
  ///
  ///  * [AnimatedSwitcherTransitionBuilder] for more information about
  ///    how a transition builder should function.
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// A function that wraps all of the children that are transitioning out, and
  /// the [child] that's transitioning in, with a widget that lays all of them
  /// out. This is called every time this widget is built. The function must not
  /// return null.
  ///
  /// The default is [AnimatedSwitcher.defaultLayoutBuilder].
  ///
  /// See also:
  ///
  ///  * [AnimatedSwitcherLayoutBuilder] for more information about
  ///    how a layout builder should function.
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  @override
  Widget build(BuildContext context) {
    final duration = this.duration;
    final status = SwapStore.read(
      context,
      identifier,
    );
    final child = builder(
      context,
      status,
    );
    if (duration == null) {
      return child;
    }

    return _SlotProvider(
      data: (
        slotId: identifier,
        value: status,
      ),
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: switchInCurve,
        switchOutCurve: switchOutCurve,
        transitionBuilder: transitionBuilder,
        layoutBuilder: layoutBuilder,
        reverseDuration: reverseDuration,
        child: KeyedSubtree(
          key: ValueKey(status),
          child: child,
        ),
      ),
    );
  }
}

typedef SlotData = ({
  String slotId,
  SlotValue value,
});

class _SlotProvider extends InheritedWidget {
  const _SlotProvider({
    required super.child,
    required this.data,
  });

  final SlotData data;

  @override
  bool updateShouldNotify(covariant _SlotProvider oldWidget) {
    return oldWidget.data != data;
  }
}
