import 'package:flutter/foundation.dart';
import 'package:flutter_swap/flutter_swap.dart';

class ConsoleSwapLogger extends SwapLogger {
  @override
  void log(SwapLogLevel level, String message,
      {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print(message);
    }
  }
}
