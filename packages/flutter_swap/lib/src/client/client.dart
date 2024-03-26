import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/client/io.dart';
import 'package:flutter_swap/src/widgets/configuration.dart';

import 'request.dart';
import 'response.dart';

///
abstract class SwapClient {
  const SwapClient();

  const factory SwapClient.http({
    required String baseUrl,
  }) = IOHttpSwapClient;

  static SwapClient of(BuildContext context) {
    return SwapConfiguration.of(context).client;
  }

  Future<SwapClientResponse> fetch(SwapClientRequest request);
}
