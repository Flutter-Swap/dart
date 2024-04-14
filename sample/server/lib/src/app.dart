import 'package:swap_server_sample/src/widgets/context.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/widgets/rfwtxt.dart';

import 'widgets/hello.dart';

class ServerApp {
  Handler build() {
    var app = Router();

    app.get('/rfwtxt', (Request request) async {
      return Response.ok(
        rfwtxt,
        headers: {
          'Content-Type': 'text/plain',
        },
      );
    });

    app.get('/hello', widget((context) async {
      return const HelloWorld();
    }));

    app.get('/context', widget((context) async {
      return const Context();
    }));

    return const Pipeline().addMiddleware(logRequests()).addHandler(app.call);
  }
}
