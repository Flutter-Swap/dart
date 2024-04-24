// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';
import 'package:http/http.dart';

typedef Config = ({
  String baseUrl,
});

class App extends StatefulWidget {
  const App({
    super.key,
    required this.config,
  });

  final Config config;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _runtime = load();

  static const LibraryName coreName = LibraryName(<String>['core', 'widgets']);
  static const LibraryName mainName = LibraryName(<String>['main']);

  @override
  void initState() {
    super.initState();
  }

  Future<Runtime> load() async {
    final response = await get(Uri.parse('${widget.config.baseUrl}/rfwtxt'));
    final remoteWidget = decodeLibraryBlob(response.bodyBytes);

    final result = Runtime();
    result.update(coreName, createCoreWidgets());
    result.update(mainName, remoteWidget);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _runtime,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RemoteWidget(
              runtime: snapshot.data!,
              data: DynamicContent(),
              widget: const FullyQualifiedWidgetName(mainName, 'root'),
            );
          },
        ),
      ),
    );
  }
}
