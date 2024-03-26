import 'package:flutter/widgets.dart';

import 'fetcher.dart';
import 'form.dart';
import 'store.dart';

class SwapScope extends StatelessWidget {
  const SwapScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SwapStore(
      child: SwapFormData(
        child: SwapFetcher(
          child: child,
        ),
      ),
    );
  }
}
