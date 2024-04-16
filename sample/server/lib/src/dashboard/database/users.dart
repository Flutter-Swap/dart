enum UserRole {
  admin,
  user,
}

typedef User = ({
  /// The username.
  String username,

  /// The encrypted password.
  String password,
  UserRole role,
});

abstract class UserTable {
  const UserTable();

  User? get(String username);
}

class MemoryUserTable extends UserTable {
  const MemoryUserTable({
    required Map<String, User> users,
  }) : _users = users;

  final Map<String, User> _users;

  @override
  User? get(String username) => _users[username];
}
