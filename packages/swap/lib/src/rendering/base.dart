import 'dart:async';

import 'package:meta/meta.dart';
import 'package:swap/src/rfw/rfw.dart';
import 'package:swap/src/widgets/widgets.dart';

abstract class BuildContext {
  BuildContext({
    this.parent,
  });

  @protected
  BuildContext? parent;

  T? findAncestorWidgetOfExactType<T extends Widget>();

  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();
}

abstract class RenderObject<T extends Widget> extends BuildContext {
  RenderObject({
    required this.widget,
    super.parent,
  });
  final T widget;

  FutureOr<BlobNode> encode();

  @override
  TS? findAncestorWidgetOfExactType<TS extends Widget>() {
    if (widget case TS widget) {
      return widget;
    }

    if (parent == null) {
      return null;
    }

    return parent!.findAncestorWidgetOfExactType<TS>();
  }

  @override
  TS? dependOnInheritedWidgetOfExactType<TS extends InheritedWidget>() {
    return findAncestorWidgetOfExactType<TS>();
  }
}

abstract class ParentRenderObject<T extends Widget> extends RenderObject<T> {
  ParentRenderObject({
    required super.widget,
    required Widget? child,
    super.parent,
  }) {
    this.child = child?.createRenderObject();
    this.child?.parent = this;
  }
  late final RenderObject? child;
}

abstract class MultiParentRenderObject<T extends Widget>
    extends RenderObject<T> {
  MultiParentRenderObject({
    required super.widget,
    required List<Widget> children,
    super.parent,
  }) {
    this.children = children.map((w) {
      final child = w.createRenderObject();
      child.parent = this;
      return child;
    }).toList();
  }

  late final List<RenderObject> children;
}

class RenderStatelessWidget extends RenderObject<StatelessWidget> {
  RenderStatelessWidget({
    required super.widget,
  });

  @override
  Future<BlobNode> encode() async {
    final result = widget.build(this);
    final resultRender = result.createRenderObject();
    resultRender.parent = this;
    return await resultRender.encode();
  }
}

class RenderInheritedWidget extends ParentRenderObject<InheritedWidget> {
  RenderInheritedWidget({
    required super.widget,
  }) : super(child: widget.child);

  @override
  Future<BlobNode> encode() async {
    return child!.encode();
  }
}

class RenderFutureBuilder<T> extends RenderObject<FutureBuilder<T>> {
  RenderFutureBuilder({
    required super.widget,
  });

  @override
  Future<BlobNode> encode() async {
    late AsyncSnapshot<T> snapshot;
    try {
      snapshot = AsyncSnapshot.withData(
        ConnectionState.done,
        await widget.future,
      );
    } catch (e, st) {
      snapshot = AsyncSnapshot.withError(ConnectionState.done, e, st);
    }
    final result = widget.builder(this, snapshot);
    final resultRender = result.createRenderObject();
    resultRender.parent = this;
    return await resultRender.encode();
  }
}
