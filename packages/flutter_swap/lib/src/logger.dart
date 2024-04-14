class SwapLogger {
  const SwapLogger();

  static SwapLogger instance = const SwapLogger();

  void error({
    required Object error,
    String? message,
    StackTrace? stackTrace,
  }) {
    log(
      SwapLogLevel.error,
      message ?? error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void log(
    SwapLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}
}

enum SwapLogLevel {
  debug,
  info,
  warning,
  error,
}
