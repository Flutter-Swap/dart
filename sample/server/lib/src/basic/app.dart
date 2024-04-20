import 'package:swap_server_sample/src/basic/widgets/context.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swap/shelf_swap.dart';

class BasicServerApp {
  Handler build() {
    var app = Router();

    app.get('/context', widget((context) async {
      return const Context();
    }));

    return const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addHandler(
          app.call,
        );
  }
}
