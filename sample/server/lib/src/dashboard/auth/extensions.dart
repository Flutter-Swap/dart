import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/dashboard/database/users.dart';

extension AuthShelfDataExtensions on ShelfData {
  User? get user => request.context['user'] as User?;

  bool get isAuthenticated => user != null;

  bool get isAdmin => user?.role == UserRole.admin;
}
