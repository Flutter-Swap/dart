import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef SwapLoaderWidgetBuilder = Widget Function(
  BuildContext context,
  Widget? previousChild,
);

/// The default loader widget used during the swapping process.
class DefaultSwapLoader extends InheritedWidget {
  const DefaultSwapLoader({
    super.key,
    required super.child,
    required this.loader,
  });

  final SwapLoaderWidgetBuilder loader;

  static Widget fallback(
    BuildContext context,
    Widget? previousChild,
  ) {
    return previousChild ?? const SwapLoader();
  }

  static Widget of(
    BuildContext context,
    Widget? previousChild,
  ) {
    return (context
            .dependOnInheritedWidgetOfExactType<DefaultSwapLoader>()
            ?.loader ??
        fallback)(context, previousChild);
  }

  @override
  bool updateShouldNotify(covariant DefaultSwapLoader oldWidget) {
    return false;
  }
}

class SwapLoader extends StatelessWidget {
  const SwapLoader({
    super.key,
    this.size = 24.0,
    this.color,
  });

  final Color? color;
  final double size;

  static Color fallbackColor(BuildContext context) {
    if (DefaultTextStyle.of(context).style.color case final color?) {
      return color;
    }

    final brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return const Color(0xFFEEEEEE);
    }

    return const Color(0xFF111111);
  }

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? fallbackColor(context);
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.12),
            ),
          ),
        ),
      ],
    );
  }
}
