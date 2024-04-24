import 'dart:async';

import 'package:swap/src/rendering/arguments.dart';
import 'package:swap/src/rendering/base.dart';
import 'package:swap/src/rfw/rfw.dart';
import 'package:swap/src/widgets/swap.dart';

class RenderSwap extends ParentRenderObject<Swap> {
  RenderSwap({
    required super.widget,
  })  : loading = widget.loading?.createRenderObject(),
        super(child: widget.child) {
    loading?.parent = this;
  }
  late final RenderObject? loading;

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Swap',
      {
        'method': widget.method,
        'path': widget.path,
        'trigger': switch (widget.trigger) {
          InitSwapTrigger() => {'type': 'init'},
          TapSwapTrigger() => {'type': 'tap'},
        },
        if (widget.target case final v?) 'target': v,
        if (child case final RenderObject v?) 'child': await v.encode(),
        if (loading case final RenderObject v?) 'loading': await v.encode(),
      },
    );
  }
}

class RenderSwapScope extends ParentRenderObject<SwapScope> {
  RenderSwapScope({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'SwapScope',
      {
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSlot extends ParentRenderObject<Slot> {
  RenderSlot({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Slot',
      {
        'identifier': widget.identifier,
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSwapInit extends ParentRenderObject<SwapInit> {
  RenderSwapInit({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'SwapInit',
      {
        'notification': ArgumentEncoders.swapNotification(widget.notification),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSwapLink extends ParentRenderObject<SwapLink> {
  RenderSwapLink({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'SwapLink',
      {
        'notification': ArgumentEncoders.swapNotification(widget.notification),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}
