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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap samples'),
      ),
      body: ListView(
        children: const [
          SampleTile(
            name: 'hello',
            initialUrl: '/hello',
          ),
        ],
      ),
    );
  }
}

class SampleTile extends StatelessWidget {
  const SampleTile({
    super.key,
    required this.name,
    required this.initialUrl,
  });

  final String name;
  final String initialUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Sample(
                name: name,
                initialUrl: initialUrl,
              );
            },
          ),
        );
      },
    );
  }
}

class Sample extends StatelessWidget {
  const Sample({
    super.key,
    required this.name,
    required this.initialUrl,
  });

  final String name;
  final String initialUrl;

  @override
  Widget build(BuildContext context) {
    return SwapScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.swap.get(
                      'slot',
                      initialUrl,
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Slot(
            identifier: 'slot',
            notSwappedBuilder: (context) => const Text('Slot 1'),
          ),
        ),
      ),
    );
  }
}
