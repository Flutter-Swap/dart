import 'package:swap_server_sample/src/dashboard/auth/auth.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:swap_server_sample/src/dashboard/database/logs.dart';
import 'package:swap_server_sample/src/dashboard/views/view.dart';

import 'database/datatable.dart';
import 'database/sessions.dart';
import 'database/users.dart';
import 'views/widgets/dashboard.dart';

class DashboardServerApp {
  Handler build() {
    var app = Router();

    final DatabaseTables database = (
      users: MemoryUserTable(
        users: {
          'admin': (
            username: 'admin',
            password: 'admin',
            role: UserRole.admin,
          ),
          'user': (
            username: 'user',
            password: 'user',
            role: UserRole.user,
          ),
        },
      ),
      logs: FakeLogTable(),
      sessions: FakeSessionTable(),
    );

    app.get(
      '/dashboard',
      View(
        database: database,
        widget: (context) async {
          return const Dashboard();
        },
      ).call,
    );

    return const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addMiddleware(
          auth(
            key: '3xamp!e',
            database: database,
          ),
        )
        .addHandler(
          app.call,
        );
  }
}
