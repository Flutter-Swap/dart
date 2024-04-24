import 'package:swap_server_sample/src/pagination/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:swap_server_sample/src/rfwtxt/app.dart';

class ServerApp {
  Handler build() {
    var app = Router();

    app.mount('/rfwtxt', RfwtxtController().router.call);

    app.mount('/pagination', PaginationController().router.call);

    return const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addHandler(
          app.call,
        );
  }
}
