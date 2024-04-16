import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:swap_server_sample/server.dart';

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
