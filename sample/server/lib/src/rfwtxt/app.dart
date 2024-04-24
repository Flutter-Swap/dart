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
        final text = '''
    import core.widgets;
    widget root = Container(
      margin: [72],
      padding: [72],
      decoration: BoxDecoration(
        color: 0xFFEEEEEE,
        borderRadius: [24],
        boxShadow: [
          BoxShadow(
            color: 0x44000000,
            blurRadius: 56,
            offset: { x: 0.0, y: 8.0 },
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: "center",
        crossAxisAlignment: "center",
        children: [
          Text(
            text: "Hello, $name!",
            style: TextStyle(
              fontSize: 100,
              letterSpacing: 2.0,
              color: 0xFF000000,
            ),
          ),
        ],
      ),
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
