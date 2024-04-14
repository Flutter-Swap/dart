import 'package:shelf_swap/shelf_swap.dart';

class Context extends StatelessWidget {
  const Context({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shelf = InheritedShelf.of(context);
    final name = shelf.request.url.queryParameters['name'];
    return Text(
      'Hello $name',
      style: TextStyle(
        fontSize: 100,
        letterSpacing: 2.0,
        color: Color(0xFF000000),
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
