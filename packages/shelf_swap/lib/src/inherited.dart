import 'package:shelf/shelf.dart';
import 'package:swap/swap.dart';

/// An [InheritedWidget] that provides the current [Request] to its descendants.
///
/// This allows widgets to access the current Shelf elements without having to
/// pass them down manually.
class InheritedShelf extends InheritedWidget {
  const InheritedShelf({
    required this.request,
    required super.child,
  });

  final Request request;

  static ShelfData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<InheritedShelf>();
    if (widget == null) {
      throw AssertionError('An InheritedShelf is required to use the request.');
    }
    return (request: widget.request,);
  }
}

typedef ShelfData = ({
  Request request,
});
