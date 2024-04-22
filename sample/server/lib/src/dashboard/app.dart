import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/dashboard/auth/auth.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'widgets/dashboard.dart';

class DashboardServerApp {
  Handler build() {
    var app = Router();

    app.get(
      '/dashboard',
      widget(
        (context) async => const Dashboard(),
      ),
    );

    return const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addMiddleware(
          auth(),
        )
        .addHandler(
          app.call,
        );
  }
}
