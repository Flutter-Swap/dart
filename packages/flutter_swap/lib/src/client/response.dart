import 'dart:typed_data';

sealed class SwapClientResponse {
  const SwapClientResponse();

  const factory SwapClientResponse.rfwtxt(String body) =
      RfwTextSwapClientResponse;

  const factory SwapClientResponse.rfw(Uint8List body) = RfwSwapClientResponse;

  const factory SwapClientResponse.json(dynamic body) = JsonSwapClientResponse;
}

class RfwTextSwapClientResponse extends SwapClientResponse {
  const RfwTextSwapClientResponse(this.body);
  final String body;
}

class RfwSwapClientResponse extends SwapClientResponse {
  const RfwSwapClientResponse(this.body);
  final Uint8List body;
}

class JsonSwapClientResponse extends SwapClientResponse {
  const JsonSwapClientResponse(this.body);
  final dynamic body;
}
