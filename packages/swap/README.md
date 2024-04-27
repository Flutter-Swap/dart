# swap

Server-driven UI for Flutter.

This package provides a way to express [rfw](https://pub.dev/packages/rfw) widgets just as if it was written in Dart for Flutter.

It also adds a few useful widgets to bring reactiveness to distant widgets.

> Swap is still an experimental project. 
>
> Use it at your own risks!

# Example

```dart
import 'package:swap/swap.dart';

void main() {
    final encodedWidget = encodeWidget(const HelloWorld());
    /// ,,,
}

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
                    'Hello',
                    style: TextStyle(
                    fontSize: 100,
                    letterSpacing: 2.0,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w100,
                    ),
                ),
                Text(
                    'World',
                    style: TextStyle(
                        fontSize: 78,
                        letterSpacing: 4.0,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w600,
                    ),
                ),
                Swap(
                    path: '/user/John',
                    trigger: SwapTrigger.init(),
                    loading: Text('...'),
                    child: Text('Oops'),
                ),
            ],
        ),
    );
  }
}
```

## Custom widgets

You can create a custom server widget that mirrors your Flutter instance by providing a `Widget` implementation and its corresponding `RenderElement`.

```dart
class Example extends Widget {
  const Example({
    super.key,
    required this.path,
    required this.child,
  });

  final String path;
  final Widget child;

  @override
  RenderObject<Widget> createRenderObject() {
    return RenderSwap(widget: this);
  }
}
```

The render object is responsible for building an RFW blob node from the current widget.

```dart
class RenderExample extends ParentRenderObject<Swap> {
  RenderExample({
    required super.widget,
  })  : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Example',
      {
        'path': widget.path,
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}
```

On the Flutter side, you need to declare a custom deserializer.

```dart
'Example': (BuildContext context, DataSource source) {
    return Swap(
        path: source.v<String>(['path'])!,
        child: source.child(['child']),
    );
},
```

You can take a look at the swap library implementation for more details.
 
## General principles

- All the provided widget API surface should always stay as close as possible as the Flutter one. This makes it easier for typical Flutter devs to develop Swap widget by reusing their knowledge, but also makes it easier to moves a server widget to a Flutter one if needed.
- Swap widgets will always stay stateless. It would be possible to create long living stateful widgets by keeping an open connection, but we don't think it feets the overall philisophy of Swap. We want it to stay simple! This might be misleading because a few widgets are stateful in the Flutter world (*`FutureBuilder` for example*), but they are in fact built once in Swap before being sent to the client. This is just a design choice to keep the same API surface as Flutter. 

## See also

* [flutter_shelf](../shelf_swap/) 
* [flutter_swap](../flutter_swap/) 

## Contributing

When adding a new widget, make sure that its API surface is as close as possible to the official Flutter widget. This makes it easy to copy-paste widget sources from Flutter to Swap.

## Thanks 

* [HTMX](https://htmx.org/) for its swapping concept based on requests 