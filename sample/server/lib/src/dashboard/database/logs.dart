enum LogLevel {
  info,
  warning,
  error,
}

typedef Log = ({
  LogLevel level,
  DateTime timestamp,
  String message,
});

abstract class LogTable {
  const LogTable();

  Future<List<Log>> getLastLogs();
}

class FakeLogTable extends LogTable {
  const FakeLogTable();

  @override
  Future<List<Log>> getLastLogs() async {
    return [
      (
        level: LogLevel.info,
        timestamp: DateTime.now(),
        message: 'This is an info message',
      ),
      (
        level: LogLevel.warning,
        timestamp: DateTime.now().add(const Duration(seconds: -5)),
        message: 'This is a warning message',
      ),
      (
        level: LogLevel.error,
        timestamp: DateTime.now().add(const Duration(seconds: -10)),
        message: 'This is an error message',
      ),
    ];
  }
}
