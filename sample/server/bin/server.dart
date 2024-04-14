import 'dart:io';

import 'package:swap_server_sample/src/app.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  var server = await shelf_io.serve(
    ServerApp().build(),
    InternetAddress.anyIPv4,
    int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080,
  );

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
