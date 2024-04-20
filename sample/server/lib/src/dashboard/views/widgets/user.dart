import 'package:shelf_swap/shelf_swap.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFEFEFE),
      ),
      child: Center(
        child: Text(
          'No access',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
