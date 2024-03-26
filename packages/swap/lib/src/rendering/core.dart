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
  BlobNode encode() {
    return ConstructorCall(
      'Align',
      {
        'alignment': ArgumentEncoders.alignment(widget.alignment),
        if (widget.widthFactor case final v)
          'widthFactor': ArgumentEncoders.v(v),
        if (widget.heightFactor case final v)
          'heightFactor': ArgumentEncoders.v(v),
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderAnimatedAlign extends ParentRenderObject<AnimatedAlign> {
  RenderAnimatedAlign({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
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
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderFlex extends MultiParentRenderObject<Flex> {
  RenderFlex({
    required super.widget,
  }) : super(children: widget.children);

  @override
  BlobNode encode() {
    return ConstructorCall(
      widget.direction == Axis.vertical ? 'Column' : 'Row',
      {
        'children': [
          for (final child in children) child.encode(),
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
  BlobNode encode() {
    return ConstructorCall(
      'ColoredBox',
      {
        'color': ArgumentEncoders.color(widget.color),
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderContainer extends ParentRenderObject<Container> {
  RenderContainer({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
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
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderDefaultTextStyle extends ParentRenderObject<DefaultTextStyle> {
  RenderDefaultTextStyle({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'DefaultTextStyle',
      {
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
  BlobNode encode() {
    return ConstructorCall(
      'Directionality',
      {
        'textDirection': ArgumentEncoders.enumValue(widget.textDirection),
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderFlexible extends ParentRenderObject<Flexible> {
  RenderFlexible({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Flexible',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderFittedBox extends ParentRenderObject<FittedBox> {
  RenderFittedBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'FittedBox',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
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
  BlobNode encode() {
    return ConstructorCall(
      'FractionallySizedBox',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderIcon extends RenderObject<Icon> {
  RenderIcon({
    required super.widget,
  });

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Icon',
      {
        // TODO
      },
    );
  }
}

class RenderText extends RenderObject<Text> {
  RenderText({
    required super.widget,
  });

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Text',
      {
        if (widget.data case final text?) 'text': text,
        if (widget.textDirection case final v?)
          'textDirection': ArgumentEncoders.enumValue(v),
        if (widget.style case final v?) 'style': ArgumentEncoders.textStyle(v),
        // TODO
      },
    );
  }
}

class RenderImage extends RenderObject<Image> {
  RenderImage({
    required super.widget,
  });

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Image',
      {
        // TODO
      },
    );
  }
}

class RenderOpacity extends ParentRenderObject<Opacity> {
  RenderOpacity({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Opacity',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderPadding extends ParentRenderObject<Padding> {
  RenderPadding({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Padding',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
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
  BlobNode encode() {
    return ConstructorCall(
      'SingleChildScrollView',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderSizedBox extends ParentRenderObject<SizedBox> {
  RenderSizedBox({
    required super.widget,
  }) : super(child: widget.child);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'SizedBox',
      {
        // TODO
        if (child case final RenderObject v?) 'child': v.encode(),
      },
    );
  }
}

class RenderSpacer extends RenderObject<Spacer> {
  RenderSpacer({
    required super.widget,
  });

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Spacer',
      {
        // TODO
      },
    );
  }
}

class RenderStack extends MultiParentRenderObject<Stack> {
  RenderStack({
    required super.widget,
  }) : super(children: widget.children);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Stack',
      {
        // TODO
        'children': [
          for (final child in children) child.encode(),
        ],
      },
    );
  }
}

class RenderWrap extends MultiParentRenderObject<Wrap> {
  RenderWrap({
    required super.widget,
  }) : super(children: widget.children);

  @override
  BlobNode encode() {
    return ConstructorCall(
      'Wrap',
      {
        // TODO
        'children': [
          for (final child in children) child.encode(),
        ],
      },
    );
  }
}
