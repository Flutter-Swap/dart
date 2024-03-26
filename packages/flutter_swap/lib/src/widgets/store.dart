import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/model/slot_value.dart';

import 'notifications/notification.dart';

class SwapStore extends StatefulWidget {
  const SwapStore({
    super.key,
    required this.child,
  });

  final Widget child;

  static SwapStoreState of(BuildContext context) {
    final state = context.findAncestorStateOfType<SwapStoreState>();
    assert(state != null, 'Unable to find an instance of SwapStore...');
    return state!;
  }

  static SlotValue read(BuildContext context, String slotId) {
    return InheritedSwapStore.read(context, slotId);
  }

  @override
  State<SwapStore> createState() => SwapStoreState();
}

typedef FutureOperation = (int id, Future<Widget>? future);

class SwapStoreState extends State<SwapStore> {
  final _data = <String, SlotValue>{};
  final _futures = <String, FutureOperation>{};

  /// Reset the slot with the given [id].
  void reset(String id) async {
    var (previousId, _) = _futures.putIfAbsent(
        id,
        () => (
              0,
              null,
            ));

    _futures[id] = (
      previousId++,
      null,
    );

    setState(() {
      _data[id] = const SlotValue.notSwapped();
    });
  }

  /// Swaps the slot with the given [id] with the given [newChild].
  void swap(String id, Widget newChild) async {
    var (previousId, _) = _futures.putIfAbsent(
        id,
        () => (
              0,
              null,
            ));

    _futures[id] = (
      previousId++,
      null,
    );

    setState(() {
      _data[id] = SlotValueSwapped(
        child: newChild,
      );
    });
  }

  /// Swaps asynchronously the slot with the given [id] with the
  /// given [newChild].
  Future<void> asyncSwap(String id, Future<Widget> future) async {
    final previousChild = switch (_data[id]) {
      SlotValueSwapped(child: final child) => child,
      SlotValueSwapping(previousChild: final child) => child,
      SlotValueSwapFailed(previousChild: final child) => child,
      _ => null,
    };

    var (previousId, _) = _futures.putIfAbsent(
        id,
        () => (
              0,
              null,
            ));
    final futureId = previousId++;

    _futures[id] = (
      futureId,
      future,
    );
    SlotValue result = SlotValue.swapping(
      previousChild: previousChild,
    );
    if (_futures[id]?.$1 == futureId) {
      setState(() {
        _data[id] = result;
      });
    }

    try {
      result = SlotValue.swapped(
        child: await future,
      );
    } catch (e, st) {
      result = SlotValue.swapFailed(
        error: e,
        stackTrace: st,
        previousChild: previousChild,
      );
    }

    if (_futures[id]?.$1 == futureId) {
      setState(() {
        _data[id] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SwapNotification>(
      onNotification: (notification) {
        switch (notification) {
          case ResetSwapNotification notification:
            reset(notification.slotId);
            return true;
          case SwapSwapNotification notification:
            swap(notification.slotId, notification.newChild);
            return true;
          case AsyncSwapNotification notification:
            asyncSwap(notification.slotId, notification.swap);
            return true;
          default:
            return false;
        }
      },
      child: InheritedSwapStore(
        data: _data,
        child: widget.child,
      ),
    );
  }
}

class InheritedSwapStore extends InheritedModel<String> {
  const InheritedSwapStore({
    super.key,
    required super.child,
    required this.data,
  });

  final Map<String, SlotValue> data;

  static InheritedSwapStore? maybeOf(BuildContext context, [String? aspect]) {
    return InheritedModel.inheritFrom<InheritedSwapStore>(context,
        aspect: aspect);
  }

  static SlotValue read(BuildContext context, String slotId) {
    final result = maybeOf(context, slotId);
    assert(
        result != null, 'Unable to find an instance of InheritedSwapState...');
    return result!.data[slotId] ?? const SlotValueNotSwapped();
  }

  @override
  bool updateShouldNotify(covariant InheritedSwapStore oldWidget) {
    return mapEquals(oldWidget.data, data);
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedSwapStore oldWidget,
    Set<String> dependencies,
  ) {
    Map<String, SlotValue> dataSubset(Map<String, SlotValue> data) {
      return {
        for (var dependency in dependencies)
          dependency: data[dependency] ?? const SlotValueNotSwapped(),
      };
    }

    final oldSubset = dataSubset(oldWidget.data);
    final subset = dataSubset(data);
    return mapEquals(oldSubset, subset);
  }
}
