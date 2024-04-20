import 'package:shelf/shelf.dart';

class RfwtxtServerApp {
  Handler build() {
    return const Pipeline()
        .addMiddleware(
      logRequests(),
    )
        .addHandler(
      (request) {
        final name = request.url.queryParameters['name'] ?? 'World';
        return Response.ok(
          ''''
    port core.widgets;
    widget root = Container(
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
    );''',
          headers: {
            'Content-Type': 'text/plain',
          },
        );
      },
    );
  }
}
