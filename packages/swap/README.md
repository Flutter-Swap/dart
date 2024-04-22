# swap

Server-driven UI for Flutter.

This package provides a way to express [rfw](https://pub.dev/packages/rfw) widgets just as if it was written in Dart for Flutter.

It also adds many useful widgets to bring reactiveness to distant widgets.

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

## See also

* [flutter_shelf]() 
* [flutter_swap]() 

## Contributing

When adding a new widget, make sure that its API surface is as close as possible to the official Flutter widget. This makes it easy to copy-paste widget sources from Flutter to Swap.

## Thanks 

* [HTMX](https://htmx.org/) for its swapping concept based on requests 