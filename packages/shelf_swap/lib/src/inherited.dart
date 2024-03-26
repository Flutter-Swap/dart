import 'package:shelf/shelf.dart';
import 'package:swap/swap.dart';

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
