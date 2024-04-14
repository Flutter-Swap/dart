import 'package:client/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swap/flutter_swap.dart';

import 'config.dart';
import 'src/logger.dart';

void main() {
  SwapLogger.instance = ConsoleSwapLogger();
  runApp(const App(
    /// Create a `config.dart` file and put your configuration there.
    ///
    /// ```dart
    /// import 'src/app.dart';
    ///
    /// const Config config = (
    ///     baseUrl: 'https://swap-server-sample-qgl9u4r-aloisdeniel.globeapp.dev',
    /// );
    /// ```
    config: config,
  ));
}
