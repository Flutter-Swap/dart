// ignore_for_file: depend_on_referenced_packages

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:swap/rfw.dart';

class RfwtxtController {
  Router get router {
    final result = Router();

    result.get(
      '/',
      (request) {
        final name = request.url.queryParameters['name'] ?? 'World';
        final text = '''import core.widgets;
widget root = Column(
  mainAxisAlignment: "center",
  crossAxisAlignment: "center",
  children: [
    Text(
      text: "Hello, $name!",
      style: TextStyle(
        fontSize: 100.0,
        color: 0xFF0055AA,
      ),
    ),
  ],
);''';

        final library = parseLibraryFile(text);
        final bytes = encodeLibraryBlob(library);
        return Response.ok(
          bytes,
          headers: {
            'Content-Type': 'application/rfw',
          },
        );
      },
    );

    return result;
  }
}
