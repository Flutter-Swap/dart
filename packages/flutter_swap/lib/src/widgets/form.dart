import 'package:flutter/widgets.dart';
import 'notifications/notification.dart';

/// Stores a set of form data that can be accessed or updated by any
/// child widget.
class SwapFormData extends StatefulWidget {
  const SwapFormData({
    super.key,
    required this.child,
  });

  final Widget child;

  /// Get all the form data stored in the nearest [SwapFormData] ancestor.
  static Map<String, dynamic>? of(BuildContext context) {
    return context.findAncestorStateOfType<_SwapFormDataState>()?.formData;
  }

  /// Set the [value] associated to [name] in the nearest [SwapFormData]
  /// ancestor.
  static void setFormData(BuildContext context, String name, dynamic value) {
    return context
        .findAncestorStateOfType<_SwapFormDataState>()
        ?.setFormData(name, value);
  }

  @override
  State<SwapFormData> createState() => _SwapFormDataState();
}

class _SwapFormDataState extends State<SwapFormData> {
  final _form = <String, dynamic>{};

  Map<String, dynamic> get formData => _form;

  /// All the added data will be sent as the body of post requests.
  void setFormData(
    String key,
    dynamic value,
  ) {
    _form[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SetFormDataSwapNotification>(
      onNotification: (notification) {
        setFormData(notification.key, notification.value);
        return true;
      },
      child: widget.child,
    );
  }
}
