import 'dart:async';

import 'package:meta/meta.dart';
import 'package:swap/src/basic_types/basic_types.dart';
import 'package:swap/src/rendering/base.dart';

@immutable
abstract class Widget {
  const Widget({
    this.key,
  });

  final Key? key;

  RenderObject createRenderObject();
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context);

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderStatelessWidget(widget: this);
  }
}

abstract class InheritedWidget extends Widget {
  const InheritedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  RenderObject<InheritedWidget> createRenderObject() {
    return RenderInheritedWidget(widget: this);
  }
}

typedef WidgetBuilder = Widget Function(BuildContext context);

class Builder extends StatelessWidget {
  const Builder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

typedef FutureWidgetBuilder<T> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T> result,
);

/// The state of connection to an asynchronous computation.
///
/// The usual flow of state is as follows:
///
/// 1. [none], maybe with some initial data.
/// 2. [waiting], indicating that the asynchronous operation has begun,
///    typically with the data being null.
/// 3. [active], with data being non-null, and possible changing over time.
/// 4. [done], with data being non-null.
///
/// See also:
///
///  * [AsyncSnapshot], which augments a connection state with information
///    received from the asynchronous computation.
enum ConnectionState {
  /// Not currently connected to any asynchronous computation.
  ///
  /// For example, a [FutureBuilder] whose [FutureBuilder.future] is null.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  ///
  /// For example, a [Stream] that has returned at least one value, but is not
  /// yet done.
  active,

  /// Connected to a terminated asynchronous computation.
  done,
}

@immutable
class AsyncSnapshot<T> {
  /// Creates an [AsyncSnapshot] with the specified [connectionState],
  /// and optionally either [data] or [error] with an optional [stackTrace]
  /// (but not both data and error).
  const AsyncSnapshot._(
      this.connectionState, this.data, this.error, this.stackTrace)
      : assert(!(data != null && error != null)),
        assert(stackTrace == null || error != null);

  /// Creates an [AsyncSnapshot] in [ConnectionState.none] with null data and error.
  const AsyncSnapshot.nothing()
      : this._(ConnectionState.none, null, null, null);

  /// Creates an [AsyncSnapshot] in [ConnectionState.waiting] with null data and error.
  const AsyncSnapshot.waiting()
      : this._(ConnectionState.waiting, null, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] and with the specified [data].
  const AsyncSnapshot.withData(ConnectionState state, T data)
      : this._(state, data, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] with the specified [error]
  /// and a [stackTrace].
  ///
  /// If no [stackTrace] is explicitly specified, [StackTrace.empty] will be used instead.
  const AsyncSnapshot.withError(
    ConnectionState state,
    Object error, [
    StackTrace stackTrace = StackTrace.empty,
  ]) : this._(state, null, error, stackTrace);

  /// Current state of connection to the asynchronous computation.
  final ConnectionState connectionState;

  /// The latest data received by the asynchronous computation.
  ///
  /// If this is non-null, [hasData] will be true.
  ///
  /// If [error] is not null, this will be null. See [hasError].
  ///
  /// If the asynchronous computation has never returned a value, this may be
  /// set to an initial data value specified by the relevant widget. See
  /// [FutureBuilder.initialData] and [StreamBuilder.initialData].
  final T? data;

  /// Returns latest data received, failing if there is no data.
  ///
  /// Throws [error], if [hasError]. Throws [StateError], if neither [hasData]
  /// nor [hasError].
  T get requireData {
    if (hasData) {
      return data!;
    }
    if (hasError) {
      Error.throwWithStackTrace(error!, stackTrace!);
    }
    throw StateError('Snapshot has neither data nor error');
  }

  /// The latest error object received by the asynchronous computation.
  ///
  /// If this is non-null, [hasError] will be true.
  ///
  /// If [data] is not null, this will be null.
  final Object? error;

  /// The latest stack trace object received by the asynchronous computation.
  ///
  /// This will not be null iff [error] is not null. Consequently, [stackTrace]
  /// will be non-null when [hasError] is true.
  ///
  /// However, even when not null, [stackTrace] might be empty. The stack trace
  /// is empty when there is an error but no stack trace has been provided.
  final StackTrace? stackTrace;

  /// Returns whether this snapshot contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// This is always true if the asynchronous computation's last result was
  /// failure.
  bool get hasError => error != null;
}

class FutureBuilder<T> extends Widget {
  const FutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  final Future<T> future;
  final FutureWidgetBuilder<T> builder;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderFutureBuilder(widget: this);
  }
}
