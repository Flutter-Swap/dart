import 'dart:async';

import 'package:swap/src/basic_types/basic_types.dart';
import 'package:swap/src/rfw/model.dart';
import 'package:swap/src/widgets/widgets.dart';

import 'arguments.dart';
import 'base.dart';

class RenderAlign extends ParentRenderObject<Align> {
  RenderAlign({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Align',
      {
        'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.widthFactor case final v?)
          'widthFactor': ArgumentEncoders.v(v),
        if (widget.heightFactor case final v?)
          'heightFactor': ArgumentEncoders.v(v),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderAnimatedAlign extends ParentRenderObject<AnimatedAlign> {
  RenderAnimatedAlign({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Align',
      {
        'duration': ArgumentEncoders.duration(widget.duration),
        'curve': ArgumentEncoders.curve(widget.curve),
        'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.widthFactor case final v)
          'widthFactor': ArgumentEncoders.v(v),
        if (widget.heightFactor case final v)
          'heightFactor': ArgumentEncoders.v(v),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderFlex extends MultiParentRenderObject<Flex> {
  RenderFlex({
    required super.widget,
  }) : super(children: widget.children);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      widget.direction == Axis.vertical ? 'Column' : 'Row',
      {
        if (widget.mainAxisAlignment != MainAxisAlignment.start)
          'mainAxisAlignment':
              ArgumentEncoders.enumValue(widget.mainAxisAlignment),
        if (widget.mainAxisSize != MainAxisSize.max)
          'mainAxisSize': ArgumentEncoders.enumValue(widget.mainAxisSize),
        if (widget.crossAxisAlignment != CrossAxisAlignment.center)
          'crossAxisAlignment':
              ArgumentEncoders.enumValue(widget.crossAxisAlignment),
        if (widget.textDirection != null)
          'textDirection': ArgumentEncoders.enumValue(widget.textDirection!),
        if (widget.verticalDirection != VerticalDirection.down)
          'verticalDirection':
              ArgumentEncoders.enumValue(widget.verticalDirection),
        if (widget.textBaseline != null)
          'textBaseline': ArgumentEncoders.enumValue(widget.textBaseline!),
        'children': [
          for (final child in children) await child.encode(),
        ],
      },
    );
  }
}

class RenderColoredBox extends ParentRenderObject<ColoredBox> {
  RenderColoredBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'ColoredBox',
      {
        'color': ArgumentEncoders.color(widget.color),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderContainer extends ParentRenderObject<Container> {
  RenderContainer({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Container',
      {
        if (widget.clipBehavior != Clip.none)
          'clipBehavior': ArgumentEncoders.enumValue(widget.clipBehavior),
        if (widget.margin case final v?)
          'margin': ArgumentEncoders.edgeInsets(v),
        if (widget.transform case final v?)
          'transform': ArgumentEncoders.matrix(v),
        if (widget.padding case final v?)
          'padding': ArgumentEncoders.edgeInsets(v),
        if (widget.decoration case final v?)
          'decoration': ArgumentEncoders.decoration(v),
        if (widget.width case final v?) 'width': ArgumentEncoders.v(v),
        if (widget.height case final v?) 'height': ArgumentEncoders.v(v),
        if (widget.alignment case final v?)
          'alignment': ArgumentEncoders.alignment(v),
        if (widget.color case final v?) 'color': ArgumentEncoders.color(v),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderDefaultTextStyle extends ParentRenderObject<DefaultTextStyle> {
  RenderDefaultTextStyle({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() {
    return ConstructorCall(
      'DefaultTextStyle',
      {
        'style': ArgumentEncoders.textStyle(widget.style),
        'softWrap': ArgumentEncoders.v(widget.softWrap),
        'overflow': ArgumentEncoders.enumValue(widget.overflow),
        'textWidthBasis': ArgumentEncoders.enumValue(widget.textWidthBasis),
        if (widget.textAlign case final v?)
          'textAlign': ArgumentEncoders.enumValue(v),
        if (widget.textHeightBehavior case final v?)
          'textHeightBehavior': ArgumentEncoders.textHeightBehavior(v),
        if (widget.maxLines case final v?) 'maxLines': v,
        // TODO
      },
    );
  }
}

class RenderDirectionality extends ParentRenderObject<Directionality> {
  RenderDirectionality({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Directionality',
      {
        'textDirection': ArgumentEncoders.enumValue(widget.textDirection),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderFlexible extends ParentRenderObject<Flexible> {
  RenderFlexible({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Flexible',
      {
        if (widget.flex != 1) 'flex': ArgumentEncoders.v(widget.flex),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderFittedBox extends ParentRenderObject<FittedBox> {
  RenderFittedBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'FittedBox',
      {
        if (widget.fit != BoxFit.contain)
          'fit': ArgumentEncoders.enumValue(widget.fit),
        if (widget.alignment != Alignment.center)
          'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.clipBehavior != Clip.hardEdge)
          'clipBehavior': ArgumentEncoders.enumValue(widget.clipBehavior),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderFractionallySizedBox
    extends ParentRenderObject<FractionallySizedBox> {
  RenderFractionallySizedBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'FractionallySizedBox',
      {
        if (widget.widthFactor != null)
          'widthFactor': ArgumentEncoders.v(widget.widthFactor!),
        if (widget.heightFactor != null)
          'heightFactor': ArgumentEncoders.v(widget.heightFactor!),
        if (widget.alignment != Alignment.center)
          'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderIcon extends RenderObject<Icon> {
  RenderIcon({
    required super.widget,
  });

  @override
  FutureOr<BlobNode> encode() {
    return ConstructorCall(
      'Icon',
      {
        if (widget.icon != null)
          'icon': ArgumentEncoders.iconData(widget.icon!),
        if (widget.size != 24.0) 'size': widget.size,
        if (widget.color != null)
          'color': ArgumentEncoders.color(widget.color!),
        if (widget.semanticLabel != null)
          'semanticLabel': ArgumentEncoders.v(widget.semanticLabel),
        if (widget.textDirection != null)
          'textDirection': ArgumentEncoders.enumValue(widget.textDirection!),
      },
    );
  }
}

class RenderImage extends RenderObject<Image> {
  RenderImage({
    required super.widget,
  });

  @override
  FutureOr<BlobNode> encode() {
    return ConstructorCall(
      'Image',
      {
        'image': ArgumentEncoders.imageProvider(widget.image),
        if (widget.width != null) 'width': ArgumentEncoders.v(widget.width!),
        if (widget.height != null) 'height': ArgumentEncoders.v(widget.height!),
        if (widget.color != null)
          'color': ArgumentEncoders.color(widget.color!),
        if (widget.colorBlendMode != null)
          'colorBlendMode': ArgumentEncoders.enumValue(widget.colorBlendMode!),
        if (widget.fit != null) 'fit': ArgumentEncoders.enumValue(widget.fit!),
        if (widget.alignment != Alignment.center)
          'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.repeat != ImageRepeat.noRepeat)
          'repeat': ArgumentEncoders.enumValue(widget.repeat),
        if (widget.centerSlice != null)
          'centerSlice': ArgumentEncoders.rect(widget.centerSlice!),
        if (widget.matchTextDirection != false)
          'matchTextDirection': ArgumentEncoders.v(widget.matchTextDirection),
        if (widget.gaplessPlayback != false)
          'gaplessPlayback': ArgumentEncoders.v(widget.gaplessPlayback),
        if (widget.isAntiAlias != false) 'isAntiAlias': widget.isAntiAlias,
        if (widget.filterQuality != FilterQuality.low)
          'filterQuality': ArgumentEncoders.enumValue(widget.filterQuality),
      },
    );
  }
}

class RenderOpacity extends ParentRenderObject<Opacity> {
  RenderOpacity({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Opacity',
      {
        if (widget.opacity != 1.0)
          'opacity': ArgumentEncoders.v(widget.opacity),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderPadding extends ParentRenderObject<Padding> {
  RenderPadding({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Padding',
      {
        if (widget.padding != EdgeInsets.zero)
          'padding': ArgumentEncoders.edgeInsets(widget.padding),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSingleChildScrollView
    extends ParentRenderObject<SingleChildScrollView> {
  RenderSingleChildScrollView({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'SingleChildScrollView',
      {
        if (widget.scrollDirection != Axis.vertical)
          'scrollDirection': ArgumentEncoders.enumValue(widget.scrollDirection),
        if (widget.reverse != false)
          'reverse': ArgumentEncoders.v(widget.reverse),
        if (widget.padding case final v?)
          'padding': ArgumentEncoders.edgeInsets(v),
        if (widget.primary != true)
          'primary': ArgumentEncoders.v(widget.primary),
        if (widget.restorationId != null)
          'restorationId': ArgumentEncoders.v(widget.restorationId),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSizedBox extends ParentRenderObject<SizedBox> {
  RenderSizedBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'SizedBox',
      {
        if (widget.width != null) 'width': ArgumentEncoders.v(widget.width),
        if (widget.height != null) 'height': ArgumentEncoders.v(widget.height),
        if (child case final RenderObject v?) 'child': await v.encode(),
      },
    );
  }
}

class RenderSpacer extends RenderObject<Spacer> {
  RenderSpacer({
    required super.widget,
  });

  @override
  FutureOr<BlobNode> encode() {
    return ConstructorCall(
      'Spacer',
      {
        if (widget.flex != 1) 'flex': ArgumentEncoders.v(widget.flex),
      },
    );
  }
}

class RenderStack extends MultiParentRenderObject<Stack> {
  RenderStack({
    required super.widget,
  }) : super(children: widget.children);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Stack',
      {
        if (widget.alignment != AlignmentDirectional.topStart)
          'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.textDirection != null)
          'textDirection': ArgumentEncoders.enumValue(widget.textDirection!),
        if (widget.fit != StackFit.loose)
          'fit': ArgumentEncoders.enumValue(widget.fit),
        if (widget.clipBehavior != Clip.hardEdge)
          'clipBehavior': ArgumentEncoders.enumValue(widget.clipBehavior),
        'children': [
          for (final child in children) await child.encode(),
        ],
      },
    );
  }
}

class RenderText extends RenderObject<Text> {
  RenderText({
    required super.widget,
  });

  @override
  FutureOr<BlobNode> encode() {
    return ConstructorCall(
      'Text',
      {
        if (widget.data case final text?) 'text': ArgumentEncoders.v(text),
        if (widget.textDirection case final v?)
          'textDirection': ArgumentEncoders.enumValue(v),
        if (widget.style case final v?) 'style': ArgumentEncoders.textStyle(v),
        if (widget.softWrap != null)
          'softWrap': ArgumentEncoders.v(widget.softWrap),
        if (widget.overflow != null)
          'overflow': ArgumentEncoders.enumValue(widget.overflow),
        if (widget.textWidthBasis != null)
          'textWidthBasis': ArgumentEncoders.enumValue(widget.textWidthBasis),
        if (widget.textAlign case final v?)
          'textAlign': ArgumentEncoders.enumValue(v),
        if (widget.textHeightBehavior case final v?)
          'textHeightBehavior': ArgumentEncoders.textHeightBehavior(v),
        if (widget.maxLines case final v?) 'maxLines': ArgumentEncoders.v(v),
      },
    );
  }
}

class RenderWrap extends MultiParentRenderObject<Wrap> {
  RenderWrap({
    required super.widget,
  }) : super(children: widget.children);

  @override
  FutureOr<BlobNode> encode() async {
    return ConstructorCall(
      'Wrap',
      {
        if (widget.direction != Axis.horizontal)
          'direction': ArgumentEncoders.enumValue(widget.direction),
        if (widget.alignment != WrapAlignment.start)
          'alignment': ArgumentEncoders.enumValue(widget.alignment),
        if (widget.spacing != 0.0)
          'spacing': ArgumentEncoders.v(widget.spacing),
        if (widget.runAlignment != WrapAlignment.start)
          'runAlignment': ArgumentEncoders.enumValue(widget.runAlignment),
        if (widget.runSpacing != 0.0) 'runSpacing': widget.runSpacing,
        if (widget.crossAxisAlignment != WrapCrossAlignment.start)
          'crossAxisAlignment':
              ArgumentEncoders.enumValue(widget.crossAxisAlignment),
        if (widget.textDirection != null)
          'textDirection': ArgumentEncoders.enumValue(widget.textDirection!),
        if (widget.verticalDirection != VerticalDirection.down)
          'verticalDirection':
              ArgumentEncoders.enumValue(widget.verticalDirection),
        if (widget.clipBehavior != Clip.none)
          'clipBehavior': ArgumentEncoders.enumValue(widget.clipBehavior),
        'children': [
          for (final child in children) await child.encode(),
        ],
      },
    );
  }
}
