import 'package:shelf_swap/shelf_swap.dart';

extension AuthShelfDataExtensions on ShelfData {
  String? get user => request.context['user'] as String?;

  bool get isAuthenticated => user != null;
}
