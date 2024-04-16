typedef Session = ({
  String username,
  DateTime connection,
});

abstract class SessionTable {
  const SessionTable();

  Future<List<Session>> getActiveSessions();
}

class FakeSessionTable extends SessionTable {
  const FakeSessionTable();

  @override
  Future<List<Session>> getActiveSessions() async {
    return [
      (
        username: 'admin',
        connection: DateTime.now(),
      ),
      (
        username: 'user',
        connection: DateTime.now().add(const Duration(seconds: -5)),
      ),
      (
        username: 'user2',
        connection: DateTime.now().add(const Duration(seconds: -10)),
      ),
      (
        username: 'user',
        connection: DateTime.now().add(const Duration(seconds: -20)),
      ),
    ];
  }
}
