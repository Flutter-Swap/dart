import 'package:swap_server_sample/src/basic/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'dashboard/app.dart';

class ServerApp {
  Handler build() {
    var app = Router();

    app.get('/basic', BasicServerApp().build);

    app.get('/dashboard', DashboardServerApp().build);

    return const Pipeline().addHandler(
      app.call,
    );
  }
}
