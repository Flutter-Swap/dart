import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/dashboard/auth/extensions.dart';
import 'package:swap_server_sample/src/dashboard/views/widgets/user.dart';

import 'admin.dart';

class Dashboard extends StatelessWidget {
  const Dashboard();

  @override
  Widget build(BuildContext context) {
    final shelf = InheritedShelf.of(context);
    if (shelf.isAdmin) {
      return AdminDashboard();
    }
    return UserDashboard();
  }
}