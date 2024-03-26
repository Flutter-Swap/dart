// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/widgets.dart';
import 'package:flutter_swap/src/deserializer.dart';
import 'package:flutter_swap/src/client/client.dart';

/// The swap configuration data.
typedef SwapConfigurationData = ({
  SwapClient client,
  SwapLibraryDeserializer deserializer,
});

/// A widget that provides the swap configuration to its descendants.
///
/// The [client] is the client used to fetch the data when using a [Fetcher]
@immutable
class SwapConfiguration extends InheritedWidget {
  SwapConfiguration({
    super.key,
    required SwapClient client,
    SwapLibraryDeserializer deserializer = const SwapLibraryDeserializer(),
    required super.child,
  }) : data = (
          client: client,
          deserializer: deserializer,
        );

  final SwapConfigurationData data;

  static SwapConfigurationData of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<SwapConfiguration>();
    assert(
      widget != null,
      'A SwapConfiguration is required to use Swap.',
    );
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant SwapConfiguration oldWidget) {
    return oldWidget.data != data;
  }
}
