# shelf_swap

Server-driven UI for Flutter.

This package provides a swap handler for [shelf]() based servers.

> Swap is still an experimental project. 
>
> Use it at your own risks!

## Example

```dart
import 'package:server/src/widgets/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swap/shelf_swap.dart';

import 'widgets/hello.dart';

void main() {
    var app = Router();

    app.get('/hello', widget((context) async {
      return const HelloWorld();
    }));

    app.get('/user/<userId>', (Request request, String userId) {
      return widget((context) async {
        return User(userId: userId);
      })(request);
    });

    final pipeline =  const Pipeline().addMiddleware(logRequests()).addHandler(app);

    final server = await shelf_io.serve(
        pipeline,
        'localhost',
        8080,
    );

    // Enable content compression
    server.autoCompress = true;

    print('Serving at http://${server.address.host}:${server.port}');
}

class HelloWorld extends StatelessWidget {
  const HelloWorld({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Hello!');
  }
}

class User extends StatelessWidget {
  const User({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Text('Hello ${userId}!');
  }
}
```

## See also

* [swap]() 
* [flutter_swap]() 

## Thanks 

* [HTMX](https://htmx.org/) for its swapping concept based on requests 