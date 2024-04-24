import 'package:shelf_swap/shelf_swap.dart';

class PaginatedSample extends StatelessWidget {
  const PaginatedSample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shelf = InheritedShelf.of(context);
    final page = int.tryParse(shelf.request.url.queryParameters['page'] ?? '1');
    return switch (page) {
      1 => const _Page1(),
      2 => const _Page2(),
      _ => const _Page3(),
    };
  }
}

class _Page1 extends StatelessWidget {
  const _Page1();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mocha.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text('👋'),
            ),
          ),
          Button(
            path: '/basic/pagination?page=2',
            title: 'Next',
          ),
        ],
      ),
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mocha.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text('🥖'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Button(
                  path: '/basic/pagination?page=1',
                  title: 'Previous',
                ),
              ),
              Expanded(
                child: Button(
                  path: '/basic/pagination?page=2',
                  title: 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Page3 extends StatelessWidget {
  const _Page3();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mocha.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text('🚀'),
            ),
          ),
          Button(
            path: '/basic/pagination?page=2',
            title: 'Previous',
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.path,
    required this.title,
  });

  final String path;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Swap(
      path: path,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: mocha.lavender,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: mocha.base,
          ),
        ),
      ),
    );
  }
}

final mocha = (
  rosewater: Color(0xFFF5E0DC),
  base: Color(0xFF1E1E2E),
  blue: Color(0xFF89B4FA),
  crust: Color(0xFF11111B),
  flamingo: Color(0xFFF2CDCD),
  green: Color(0xFFA6E3A1),
  lavender: Color(0xFFB4BEFE),
  mantle: Color(0xFF181825),
  maroon: Color(0xFFEBA0AC),
  mauve: Color(0xFFCBA6F7),
  overlay0: Color(0xFF6C7086),
  overlay1: Color(0xFF7F849C),
  overlay2: Color(0xFF9399B2),
  peach: Color(0xFFFAB387),
  pink: Color(0xFFF5C2E7),
  red: Color(0xFFF38BA8),
  sapphire: Color(0xFF74C7EC),
  sky: Color(0xFF89DCEB),
  subtext0: Color(0xFFA6ADC8),
  subtext1: Color(0xFFBAC2DE),
  surface0: Color(0xFF313244),
  surface1: Color(0xFF45475A),
  surface2: Color(0xFF585B70),
  teal: Color(0xFF94E2D5),
  text: Color(0xFFCDD6F4),
  yellow: Color(0xFFF9E2AF),
);
