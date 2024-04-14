import 'package:flutter/material.dart';
import 'package:flutter_swap/flutter_swap.dart';

typedef Config = ({
  String baseUrl,
});

class App extends StatelessWidget {
  const App({
    super.key,
    required this.config,
  });

  final Config config;

  @override
  Widget build(BuildContext context) {
    return SwapConfiguration(
      client: IOHttpSwapClient(
        baseUrl: config.baseUrl,
      ),
      child: const MaterialApp(
        title: 'Server Driven UI Demo',
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SwapScope(
        child: Builder(builder: (context) {
          return Container(
            color: Colors.blue.shade100,
            child: Column(
              children: [
                const Text('Choose an example'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: Slot(
                        identifier: 'slot1',
                        notSwappedBuilder: (context) => const Text('Slot 1'),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // This will update the slot1 with the HelloWorld widget from
                    // the server.
                    context.swap.get(
                      'slot1',
                      '/rfwtxt?name=World',
                    );
                  },
                  child: const Text('Load /rfwtxt'),
                ),
                GestureDetector(
                  onTap: () {
                    // This will update the slot1 with the HelloWorld widget from
                    // the server.
                    context.swap.get(
                      'slot1',
                      '/hello',
                    );
                  },
                  child: const Text('Load /hello'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
