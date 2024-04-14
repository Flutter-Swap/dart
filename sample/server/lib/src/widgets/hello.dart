import 'package:shelf_swap/shelf_swap.dart';

class HelloWorld extends StatelessWidget {
  const HelloWorld({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(72),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 56,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Hello World',
            style: TextStyle(
              fontSize: 100,
              letterSpacing: 2.0,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
