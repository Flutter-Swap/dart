import 'package:shelf/shelf_io.dart';
import 'package:shelf_swap/shelf_swap.dart';

Future<void> main() async {
  final server = await serve(widget((context) async {
    final request = InheritedShelf.of(context).request;
    final name = request.url.queryParameters['name'] ?? 'World';
    return Hello(
      name: name,
    );
  }), 'localhost', 8080)
    ..autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

class Hello extends StatelessWidget {
  const Hello({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text('Hello $name');
  }
}
