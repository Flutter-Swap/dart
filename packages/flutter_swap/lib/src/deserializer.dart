import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:rfw/formats.dart';
import 'package:rfw/rfw.dart';

import 'client/response.dart';
import 'widgets/configuration.dart';
import 'widgets/notifications/init.dart';
import 'widgets/notifications/link.dart';
import 'widgets/notifications/notification.dart';
import 'widgets/scope.dart';
import 'widgets/slot.dart';
import 'widgets/swap.dart';

class SwapLibraryDeserializer {
  const SwapLibraryDeserializer({
    this.customLibraries = const <LibraryName, LocalWidgetLibrary>{},
  });

  final Map<LibraryName, LocalWidgetLibrary> customLibraries;

  static SwapLibraryDeserializer of(BuildContext context) {
    return SwapConfiguration.of(context).deserializer;
  }

  static const mainName = LibraryName(['main']);
  static const swapName = LibraryName(['swap']);
  static const coreName = LibraryName(['core', 'widgets']);

  /// Deserializes the given [value] into a [Widget].
  ///
  /// The [value] can be either a [String] (rfwtxt) or a [Uint8List] (rfw).
  Widget deserialize(SwapClientResponse value) {
    final library = switch (value) {
      RfwTextSwapClientResponse(body: final value) => parseLibraryFile(value),
      RfwSwapClientResponse(body: final value) => decodeLibraryBlob(value),
      JsonSwapClientResponse _ =>
        throw UnsupportedError('JSON is not supported by default serializer'),
    };

    final runtime = Runtime()
      ..update(coreName, createCoreWidgets())
      ..update(swapName, createSwapWidgets());

    library.imports.add(const Import(coreName));
    library.imports.add(const Import(swapName));

    for (var entry in customLibraries.entries) {
      library.imports.add(Import(entry.key));
      runtime.update(entry.key, entry.value);
    }

    runtime.update(mainName, library);

    return Builder(builder: (context) {
      return RemoteWidget(
        runtime: runtime,
        data: DynamicContent(),
        widget: const FullyQualifiedWidgetName(mainName, 'root'),
        onEvent: (String name, DynamicMap arguments) {
          //SwapStore.event(context, name, arguments);
        },
      );
    });
  }
}

LocalWidgetLibrary createSwapWidgets() =>
    LocalWidgetLibrary(_swapWidgetsDefinitions);

// In these widgets we make an effort to expose every single argument available.
Map<String, LocalWidgetBuilder> get _swapWidgetsDefinitions =>
    <String, LocalWidgetBuilder>{
      // Keep these in alphabetical order and add any new widgets to the list
      // in the documentation above.

      'Swap': (BuildContext context, DataSource source) {
        final loading = source.optionalChild(['loading']);
        return Swap(
          path: source.v<String>(['path'])!,
          method: source.v<String>(['method']) ?? 'GET',
          target: source.v<String>(['target']),
          trigger: _swapTrigger(source, ['trigger']),
          loadingBuilder: loading == null ? null : (context, data) => loading,
          child: source.child(['child']),
        );
      },
      'SwapScope': (BuildContext context, DataSource source) {
        return SwapScope(
          child: source.child(['child']),
        );
      },
      'Slot': (BuildContext context, DataSource source) {
        final loading = source.optionalChild(['loading']);
        return Slot(
          identifier: source.v<String>(['identifier'])!,
          swappingBuilder:
              loading != null ? (context, previousChild) => loading : null,
          notSwappedBuilder: (context) => source.child(['child']),
        );
      },
      'SwapInit': (BuildContext context, DataSource source) {
        return SwapInit(
          notification: _swapNotification(source, ['notification']),
          child: source.child(['child']),
        );
      },
      'SwapLink': (BuildContext context, DataSource source) {
        return SwapLink(
          notification: _swapNotification(source, ['notification']),
          child: source.child(['child']),
        );
      },
    };

SwapTrigger _swapTrigger(DataSource source, List<Object> key) {
  final String? type = source.v<String>([...key, 'type']);
  return switch (type) {
    'tap' => const TapSwapTrigger(),
    'init' => const InitSwapTrigger(),
    _ => throw UnsupportedError('Unknown trigger type: $type'),
  };
}

SwapNotification _swapNotification(DataSource source, List<Object> key) {
  final String? type = source.v<String>([...key, 'type']);
  return switch (type) {
    'fetch' => SwapNotification.fetch(
        source.v<String>([...key, 'slotId'])!,
        source.v<String>([...key, 'method'])!,
        source.v<String>([...key, 'path'])!,
        body: source.v<String>([...key, 'body']),
      ),
    'reset' => SwapNotification.reset(
        source.v<String>([...key, 'slotId'])!,
      ),
    'swap' => SwapNotification.swap(
        source.v<String>([...key, 'slotId'])!,
        source.child([key, 'child']),
      ),
    'setFormData' => SwapNotification.setFormData(
        source.v<String>([...key, 'key'])!,
        source.v<String>([...key, 'value']),
      ),
    'custom' => SwapNotification.custom(
        source.v<String>([...key, 'identifier'])!,
        source.v<String>([...key, 'data']),
      ),
    _ => throw UnsupportedError('Unknown notification type: $type'),
  };
}
