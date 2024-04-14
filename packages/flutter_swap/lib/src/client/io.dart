import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'client.dart';
import 'request.dart';
import 'response.dart';

class IOHttpSwapClient extends SwapClient {
  const IOHttpSwapClient({
    required this.baseUrl,
  });

  final String baseUrl;

  Uri buildUri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  @override
  Future<SwapClientResponse> fetch(SwapClientRequest request) async {
    final client = HttpClient();
    final urlRequest = await client.openUrl(
      request.method,
      buildUri(request.path),
    );
    if (request.headers case final headers?) {
      for (var header in headers.entries) {
        urlRequest.headers.set(header.key, header.value);
      }
    }

    if (request.body case final body?) {
      final json = jsonEncode(body);
      urlRequest.write(json);
    }

    final response = await urlRequest.close();
    final respBody = <int>[];
    await for (var data in response) {
      respBody.addAll(data);
    }

    return switch (response.headers.contentType?.mimeType) {
      'text/plain' => SwapClientResponse.rfwtxt(
          utf8.decode(respBody),
        ),
      'application/rfw' => SwapClientResponse.rfw(
          Uint8List.fromList(respBody),
        ),
      'application/rfwtxt' => SwapClientResponse.rfwtxt(
          utf8.decode(respBody),
        ),
      'application/json' => SwapClientResponse.json(
          jsonDecode(
            utf8.decode(respBody),
          ),
        ),
      _ => throw Exception(
          'Unknown content type'
          ': ${response.headers.contentType}',
        ),
    };
  }
}
