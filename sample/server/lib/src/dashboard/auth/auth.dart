import 'dart:convert';

import 'package:shelf/shelf.dart';

final users = {
  'admin': 'adm1n!',
  'user': 'us3r?',
};

/// An authentication middleware which associates a users to the request when
/// a basic authentication header is present.
///
/// The user credentials are checked against the [database] and if they are
/// valid the user is associated with the request.
Middleware auth() => (innerHandler) {
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
        final effectivePassword = users[username];
        if (effectivePassword == null || effectivePassword != password) {
          return Response.unauthorized('Unmauthorized');
        }

        return innerHandler(
          request.change(
            context: {
              'user': username,
            },
          ),
        );
      };
    };
