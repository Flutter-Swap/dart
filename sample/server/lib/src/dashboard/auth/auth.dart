import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:swap_server_sample/src/dashboard/database/datatable.dart';

/// An authentication middleware which associates a users to the request when
/// a basic authentication header is present.
///
/// The [users] map is used to authenticate the user. The entry key is the
/// username.
///
/// The [key] is used to encrypt the request password.
Middleware auth({
  required String key,
  required DatabaseTables database,
}) =>
    (innerHandler) {
      return (Request request) {
        final header = request.headers['authorization'];
        if (header == null) {
          return innerHandler(request);
        }

        final parts = header.split(' ');
        if (parts.length != 2 || parts.first != 'Basic') {
          return innerHandler(request);
        }

        final auth = String.fromCharCodes(base64.decode(parts.last));
        final index = auth.indexOf(':');
        if (index == -1) {
          return innerHandler(request);
        }

        final username = auth.substring(0, index);
        final password = auth.substring(index + 1);
        final user = database.users.get(username);
        if (user == null || user.password != password) {
          return Response.unauthorized('Unmauthorized');
        }

        return innerHandler(
          request.change(
            context: {
              'user': user,
            },
          ),
        );
      };
    };
