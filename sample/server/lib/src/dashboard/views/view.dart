import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swap/shelf_swap.dart' as swap;
import 'package:swap_server_sample/src/dashboard/database/datatable.dart';

typedef AsyncWidgetBuilder = Future<swap.Widget> Function(
    swap.BuildContext context);

class View {
  const View({
    required this.database,
    required this.widget,
  });

  final DatabaseTables database;
  final AsyncWidgetBuilder widget;

  FutureOr<Response> call(Request req) {
    return swap.widget(
      (context) async {
        final result = await widget(context);
        return Database(
          data: database,
          child: result,
        );
      },
    )(req);
  }
}
