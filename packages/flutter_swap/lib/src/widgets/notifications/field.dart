import 'package:flutter/material.dart';
import 'package:flutter_swap/flutter_swap.dart';

/// A text field which value is updated in [SwapFormData] when changed.
class SwapField extends StatefulWidget {
  const SwapField({
    super.key,
    required this.name,
  });

  final String name;

  @override
  State<SwapField> createState() => _SwapFieldState();
}

class _SwapFieldState extends State<SwapField> {
  late final controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newValue = SwapFormData.of(context)?[widget.name];
    if (newValue != controller.value) {
      controller.value = newValue;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        SwapFormData.setFormData(
          context,
          widget.name,
          value,
        );
      },
    );
  }
}
