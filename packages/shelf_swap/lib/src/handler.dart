/// Support for doing something awesome.
///
/// More dartdocs go here.
library shelf_swap;

import 'package:shelf/shelf.dart';
import 'package:swap/swap.dart';

import 'inherited.dart';

export 'package:swap/swap.dart';

/// A [RequestHandler] that builds a widget and returns it as a response.
///
/// The widget is encoded as a [BlobNode].
Handler widget(
    Future<Widget> Function(
      BuildContext context,
    ) build) {
  return (Request request) async {
    try {
      final root = InheritedShelf(
        request: request,
        child: Builder(
          builder: (context) {
            return FutureBuilder(
              future: build(context),
              builder: (context, result) {
                if (result.data case final data?) return data;
                if (result.error != null) print(result.error!);
                throw Response(500);
              },
            );
          },
        ),
      );

      final bytes = await encodeWidget(root);
      return Response.ok(
        bytes,
        headers: {
          'Content-Type': 'application/rfw',
        },
      );
    } catch (e) {
      if (e is Response) {
        return e;
      }

      rethrow;
    }
  };
}
