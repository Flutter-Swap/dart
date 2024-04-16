import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/dashboard/database/logs.dart';
import 'package:swap_server_sample/src/dashboard/database/sessions.dart';
import 'package:swap_server_sample/src/dashboard/database/users.dart';

typedef DatabaseTables = ({
  UserTable users,
  LogTable logs,
  SessionTable sessions,
});

class Database extends InheritedWidget {
  const Database({
    super.key,
    required super.child,
    required this.data,
  });

  final DatabaseTables data;

  static DatabaseTables of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Database>()!.data;
  }
}
