// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Intentionally not exported:
//  - Image, instantiateImageCodec, decodeImageFromList:
//      We use ui.* to make it very explicit that these are low-level image APIs.
//      Generally, higher layers provide more reasonable APIs around images.
//  - lerpDouble:
//      Hopefully this will eventually become Double.lerp.
//  - Paragraph, ParagraphBuilder, ParagraphStyle, TextBox:
//      These are low-level text primitives. Use this package's TextPainter API.
//  - Picture, PictureRecorder, Scene, SceneBuilder:
//      These are low-level primitives. Generally, the rendering layer makes these moot.
//  - Gradient:
//      Use this package's higher-level Gradient API instead.
//  - window, WindowPadding
//      These are generally wrapped by other APIs so we always refer to them directly
//      as ui.* to avoid making them seem like high-level APIs.

import 'package:meta/meta.dart';
import 'package:swap/src/utils/numbers.dart';
import 'geometry.dart';
import 'text.dart';
import 'view_padding.dart';

export 'alignment.dart';
export 'border_radius.dart';
export 'box.dart';
export 'box_fit.dart';
export 'color.dart';
export 'curves.dart';
export 'decoration.dart';
export 'flex.dart';
export 'geometry.dart';
export 'gradients.dart';
export 'icon_data.dart';
export 'image.dart';
export 'key.dart';
export 'text.dart';
export 'text_style.dart';
export 'view_padding.dart';
export 'wrap.dart';

/// The description of the difference between two objects, in the context of how
/// it will affect the rendering.
///
/// Used by [TextSpan.compareTo] and [TextStyle.compareTo].
///
/// The values in this enum are ordered such that they are in increasing order
/// of cost. A value with index N implies all the values with index less than N.
/// For example, [layout] (index 3) implies [paint] (2).
enum RenderComparison {
  /// The two objects are identical (meaning deeply equal, not necessarily
  /// [dart:core.identical]).
  identical,

  /// The two objects are identical for the purpose of layout, but may be different
  /// in other ways.
  ///
  /// For example, maybe some event handlers changed.
  metadata,

  /// The two objects are different but only in ways that affect paint, not layout.
  ///
  /// For example, only the color is changed.
  ///
  /// [RenderObject.markNeedsPaint] would be necessary to handle this kind of
  /// change in a render object.
  paint,

  /// The two objects are different in ways that affect layout (and therefore paint).
  ///
  /// For example, the size is changed.
  ///
  /// This is the most drastic level of change possible.
  ///
  /// [RenderObject.markNeedsLayout] would be necessary to handle this kind of
  /// change in a render object.
  layout,
}

/// Configuration of offset passed to [DragStartDetails].
///
/// See also:
///
///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the
///  different behaviors.
enum DragStartBehavior {
  /// Set the initial offset at the position where the first down event was
  /// detected.
  down,

  /// Set the initial position at the position where this gesture recognizer
  /// won the arena.
  start,
}

/// A representation of how a [ScrollView] should dismiss the on-screen
/// keyboard.
enum ScrollViewKeyboardDismissBehavior {
  /// `manual` means there is no automatic dismissal of the on-screen keyboard.
  /// It is up to the client to dismiss the keyboard.
  manual,

  /// `onDrag` means that the [ScrollView] will dismiss an on-screen keyboard
  /// when a drag begins.
  onDrag,
}

/// How to size the non-positioned children of a [Stack].
///
/// This enum is used with [Stack.fit] and [RenderStack.fit] to control
/// how the [BoxConstraints] passed from the stack's parent to the stack's child
/// are adjusted.
///
/// See also:
///
///  * [Stack], the widget that uses this.
///  * [RenderStack], the render object that implements the stack algorithm.
enum StackFit {
  /// The constraints passed to the stack from its parent are loosened.
  ///
  /// For example, if the stack has constraints that force it to 350x600, then
  /// this would allow the non-positioned children of the stack to have any
  /// width from zero to 350 and any height from zero to 600.
  ///
  /// See also:
  ///
  ///  * [Center], which loosens the constraints passed to its child and then
  ///    centers the child in itself.
  ///  * [BoxConstraints.loosen], which implements the loosening of box
  ///    constraints.
  loose,

  /// The constraints passed to the stack from its parent are tightened to the
  /// biggest size allowed.
  ///
  /// For example, if the stack has loose constraints with a width in the range
  /// 10 to 100 and a height in the range 0 to 600, then the non-positioned
  /// children of the stack would all be sized as 100 pixels wide and 600 high.
  expand,

  /// The constraints passed to the stack from its parent are passed unmodified
  /// to the non-positioned children.
  ///
  /// For example, if a [Stack] is an [Expanded] child of a [Row], the
  /// horizontal constraints will be tight and the vertical constraints will be
  /// loose.
  passthrough,
}

/// The two cardinal directions in two dimensions.
///
/// The axis is always relative to the current coordinate space. This means, for
/// example, that a [horizontal] axis might actually be diagonally from top
/// right to bottom left, due to some local [Transform] applied to the scene.
///
/// See also:
///
///  * [AxisDirection], which is a directional version of this enum (with values
///    like left and right, rather than just horizontal).
///  * [TextDirection], which disambiguates between left-to-right horizontal
///    content and right-to-left horizontal content.
enum Axis {
  /// Left and right.
  ///
  /// See also:
  ///
  ///  * [TextDirection], which disambiguates between left-to-right horizontal
  ///    content and right-to-left horizontal content.
  horizontal,

  /// Up and down.
  vertical,
}

/// Returns the opposite of the given [Axis].
///
/// Specifically, returns [Axis.horizontal] for [Axis.vertical], and
/// vice versa.
///
/// See also:
///
///  * [flipAxisDirection], which does the same thing for [AxisDirection] values.
Axis flipAxis(Axis direction) {
  switch (direction) {
    case Axis.horizontal:
      return Axis.vertical;
    case Axis.vertical:
      return Axis.horizontal;
  }
}

/// A direction in which boxes flow vertically.
///
/// This is used by the flex algorithm (e.g. [Column]) to decide in which
/// direction to draw boxes.
///
/// This is also used to disambiguate `start` and `end` values (e.g.
/// [MainAxisAlignment.start] or [CrossAxisAlignment.end]).
///
/// See also:
///
///  * [TextDirection], which controls the same thing but horizontally.
enum VerticalDirection {
  /// Boxes should start at the bottom and be stacked vertically towards the top.
  ///
  /// The "start" is at the bottom, the "end" is at the top.
  up,

  /// Boxes should start at the top and be stacked vertically towards the bottom.
  ///
  /// The "start" is at the top, the "end" is at the bottom.
  down,
}

/// A direction along either the horizontal or vertical [Axis] in which the
/// origin, or zero position, is determined.
///
/// This value relates to the direction in which the scroll offset increases
/// from the origin. This value does not represent the direction of user input
/// that may be modifying the scroll offset, such as from a drag. For the
/// active scrolling direction, see [ScrollDirection].
///
/// {@tool dartpad}
/// This sample shows a [CustomScrollView], with [Radio] buttons in the
/// [AppBar.bottom] that change the [AxisDirection] to illustrate different
/// configurations.
///
/// ** See code in examples/api/lib/painting/axis_direction/axis_direction.0.dart **
/// {@end-tool}
///
/// See also:
///
///   * [ScrollDirection], the direction of active scrolling, relative to the positive
///     scroll offset axis given by an [AxisDirection] and a [GrowthDirection].
///   * [GrowthDirection], the direction in which slivers and their content are
///     ordered, relative to the scroll offset axis as specified by
///     [AxisDirection].
///   * [CustomScrollView.anchor], the relative position of the zero scroll
///     offset in a viewport and inflection point for [AxisDirection]s of the
///     same cardinal [Axis].
///   * [axisDirectionIsReversed], which returns whether traveling along the
///     given axis direction visits coordinates along that axis in numerically
///     decreasing order.
enum AxisDirection {
  /// A direction in the [Axis.vertical] where zero is at the bottom and
  /// positive values are above it: `⇈`
  ///
  /// Alphabetical content with a [GrowthDirection.forward] would have the A at
  /// the bottom and the Z at the top.
  ///
  /// For example, the behavior of a [ListView] with [ListView.reverse] set to
  /// true would have this axis direction.
  ///
  /// See also:
  ///
  ///   * [axisDirectionIsReversed], which returns whether traveling along the
  ///     given axis direction visits coordinates along that axis in numerically
  ///     decreasing order.
  up,

  /// A direction in the [Axis.horizontal] where zero is on the left and
  /// positive values are to the right of it: `⇉`
  ///
  /// Alphabetical content with a [GrowthDirection.forward] would have the A on
  /// the left and the Z on the right. This is the ordinary reading order for a
  /// horizontal set of tabs in an English application, for example.
  ///
  /// For example, the behavior of a [ListView] with [ListView.scrollDirection]
  /// set to [Axis.horizontal] would have this axis direction.
  ///
  /// See also:
  ///
  ///   * [axisDirectionIsReversed], which returns whether traveling along the
  ///     given axis direction visits coordinates along that axis in numerically
  ///     decreasing order.
  right,

  /// A direction in the [Axis.vertical] where zero is at the top and positive
  /// values are below it: `⇊`
  ///
  /// Alphabetical content with a [GrowthDirection.forward] would have the A at
  /// the top and the Z at the bottom. This is the ordinary reading order for a
  /// vertical list.
  ///
  /// For example, the default behavior of a [ListView] would have this axis
  /// direction.
  ///
  /// See also:
  ///
  ///   * [axisDirectionIsReversed], which returns whether traveling along the
  ///     given axis direction visits coordinates along that axis in numerically
  ///     decreasing order.
  down,

  /// A direction in the [Axis.horizontal] where zero is to the right and
  /// positive values are to the left of it: `⇇`
  ///
  /// Alphabetical content with a [GrowthDirection.forward] would have the A at
  /// the right and the Z at the left. This is the ordinary reading order for a
  /// horizontal set of tabs in a Hebrew application, for example.
  ///
  /// For example, the behavior of a [ListView] with [ListView.scrollDirection]
  /// set to [Axis.horizontal] and [ListView.reverse] set to true would have
  /// this axis direction.
  ///
  /// See also:
  ///
  ///   * [axisDirectionIsReversed], which returns whether traveling along the
  ///     given axis direction visits coordinates along that axis in numerically
  ///     decreasing order.
  left,
}

/// Returns the [Axis] that contains the given [AxisDirection].
///
/// Specifically, returns [Axis.vertical] for [AxisDirection.up] and
/// [AxisDirection.down] and returns [Axis.horizontal] for [AxisDirection.left]
/// and [AxisDirection.right].
Axis axisDirectionToAxis(AxisDirection axisDirection) {
  switch (axisDirection) {
    case AxisDirection.up:
    case AxisDirection.down:
      return Axis.vertical;
    case AxisDirection.left:
    case AxisDirection.right:
      return Axis.horizontal;
  }
}

/// Returns the [AxisDirection] in which reading occurs in the given [TextDirection].
///
/// Specifically, returns [AxisDirection.left] for [TextDirection.rtl] and
/// [AxisDirection.right] for [TextDirection.ltr].
AxisDirection textDirectionToAxisDirection(TextDirection textDirection) {
  switch (textDirection) {
    case TextDirection.rtl:
      return AxisDirection.left;
    case TextDirection.ltr:
      return AxisDirection.right;
  }
}

/// Returns the opposite of the given [AxisDirection].
///
/// Specifically, returns [AxisDirection.up] for [AxisDirection.down] (and
/// vice versa), as well as [AxisDirection.left] for [AxisDirection.right] (and
/// vice versa).
///
/// See also:
///
///  * [flipAxis], which does the same thing for [Axis] values.
AxisDirection flipAxisDirection(AxisDirection axisDirection) {
  switch (axisDirection) {
    case AxisDirection.up:
      return AxisDirection.down;
    case AxisDirection.right:
      return AxisDirection.left;
    case AxisDirection.down:
      return AxisDirection.up;
    case AxisDirection.left:
      return AxisDirection.right;
  }
}

/// Returns whether traveling along the given axis direction visits coordinates
/// along that axis in numerically decreasing order.
///
/// Specifically, returns true for [AxisDirection.up] and [AxisDirection.left]
/// and false for [AxisDirection.down] and [AxisDirection.right].
bool axisDirectionIsReversed(AxisDirection axisDirection) {
  switch (axisDirection) {
    case AxisDirection.up:
    case AxisDirection.left:
      return true;
    case AxisDirection.down:
    case AxisDirection.right:
      return false;
  }
}

/// Base class for [EdgeInsets] that allows for text-direction aware
/// resolution.
///
/// A property or argument of this type accepts classes created either with [
/// EdgeInsets.fromLTRB] and its variants, or [
/// EdgeInsetsDirectional.fromSTEB] and its variants.
///
/// To convert an [EdgeInsetsGeometry] object of indeterminate type into a
/// [EdgeInsets] object, call the [resolve] method.
///
/// See also:
///
///  * [Padding], a widget that describes margins using [EdgeInsetsGeometry].
@immutable
abstract class EdgeInsetsGeometry {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const EdgeInsetsGeometry();

  double get _bottom;
  double get _end;
  double get _left;
  double get _right;
  double get _start;
  double get _top;

  /// An [EdgeInsetsGeometry] with infinite offsets in each direction.
  ///
  /// Can be used as an infinite upper bound for [clamp].
  static const EdgeInsetsGeometry infinity = _MixedEdgeInsets.fromLRSETB(
    double.infinity,
    double.infinity,
    double.infinity,
    double.infinity,
    double.infinity,
    double.infinity,
  );

  /// Whether every dimension is non-negative.
  bool get isNonNegative {
    return _left >= 0.0 &&
        _right >= 0.0 &&
        _start >= 0.0 &&
        _end >= 0.0 &&
        _top >= 0.0 &&
        _bottom >= 0.0;
  }

  /// The total offset in the horizontal direction.
  double get horizontal => _left + _right + _start + _end;

  /// The total offset in the vertical direction.
  double get vertical => _top + _bottom;

  /// The total offset in the given direction.
  double along(Axis axis) {
    switch (axis) {
      case Axis.horizontal:
        return horizontal;
      case Axis.vertical:
        return vertical;
    }
  }

  /// The size that this [EdgeInsets] would occupy with an empty interior.
  Size get collapsedSize => Size(horizontal, vertical);

  /// An [EdgeInsetsGeometry] with top and bottom, left and right, and start and end flipped.
  EdgeInsetsGeometry get flipped =>
      _MixedEdgeInsets.fromLRSETB(_right, _left, _end, _start, _bottom, _top);

  /// Returns a new size that is bigger than the given size by the amount of
  /// inset in the horizontal and vertical directions.
  ///
  /// See also:
  ///
  ///  * [EdgeInsets.inflateRect], to inflate a [Rect] rather than a [Size] (for
  ///    [EdgeInsetsDirectional], requires first calling [resolve] to establish
  ///    how the start and end map to the left or right).
  ///  * [deflateSize], to deflate a [Size] rather than inflating it.
  Size inflateSize(Size size) {
    return Size(size.width + horizontal, size.height + vertical);
  }

  /// Returns a new size that is smaller than the given size by the amount of
  /// inset in the horizontal and vertical directions.
  ///
  /// If the argument is smaller than [collapsedSize], then the resulting size
  /// will have negative dimensions.
  ///
  /// See also:
  ///
  ///  * [EdgeInsets.deflateRect], to deflate a [Rect] rather than a [Size]. (for
  ///    [EdgeInsetsDirectional], requires first calling [resolve] to establish
  ///    how the start and end map to the left or right).
  ///  * [inflateSize], to inflate a [Size] rather than deflating it.
  Size deflateSize(Size size) {
    return Size(size.width - horizontal, size.height - vertical);
  }

  /// Returns the difference between two [EdgeInsetsGeometry] objects.
  ///
  /// If you know you are applying this to two [EdgeInsets] or two
  /// [EdgeInsetsDirectional] objects, consider using the binary infix `-`
  /// operator instead, which always returns an object of the same type as the
  /// operands, and is typed accordingly.
  ///
  /// If [subtract] is applied to two objects of the same type ([EdgeInsets] or
  /// [EdgeInsetsDirectional]), an object of that type will be returned (though
  /// this is not reflected in the type system). Otherwise, an object
  /// representing a combination of both is returned. That object can be turned
  /// into a concrete [EdgeInsets] using [resolve].
  ///
  /// This method returns the same result as [add] applied to the result of
  /// negating the argument (using the prefix unary `-` operator or multiplying
  /// the argument by -1.0 using the `*` operator).
  EdgeInsetsGeometry subtract(EdgeInsetsGeometry other) {
    return _MixedEdgeInsets.fromLRSETB(
      _left - other._left,
      _right - other._right,
      _start - other._start,
      _end - other._end,
      _top - other._top,
      _bottom - other._bottom,
    );
  }

  /// Returns the sum of two [EdgeInsetsGeometry] objects.
  ///
  /// If you know you are adding two [EdgeInsets] or two [EdgeInsetsDirectional]
  /// objects, consider using the `+` operator instead, which always returns an
  /// object of the same type as the operands, and is typed accordingly.
  ///
  /// If [add] is applied to two objects of the same type ([EdgeInsets] or
  /// [EdgeInsetsDirectional]), an object of that type will be returned (though
  /// this is not reflected in the type system). Otherwise, an object
  /// representing a combination of both is returned. That object can be turned
  /// into a concrete [EdgeInsets] using [resolve].
  EdgeInsetsGeometry add(EdgeInsetsGeometry other) {
    return _MixedEdgeInsets.fromLRSETB(
      _left + other._left,
      _right + other._right,
      _start + other._start,
      _end + other._end,
      _top + other._top,
      _bottom + other._bottom,
    );
  }

  /// Returns a new [EdgeInsetsGeometry] object with all values greater than
  /// or equal to `min`, and less than or equal to `max`.
  EdgeInsetsGeometry clamp(EdgeInsetsGeometry min, EdgeInsetsGeometry max) {
    return _MixedEdgeInsets.fromLRSETB(
      clampDouble(_left, min._left, max._left),
      clampDouble(_right, min._right, max._right),
      clampDouble(_start, min._start, max._start),
      clampDouble(_end, min._end, max._end),
      clampDouble(_top, min._top, max._top),
      clampDouble(_bottom, min._bottom, max._bottom),
    );
  }

  /// Returns the [EdgeInsetsGeometry] object with each dimension negated.
  ///
  /// This is the same as multiplying the object by -1.0.
  ///
  /// This operator returns an object of the same type as the operand.
  EdgeInsetsGeometry operator -();

  /// Scales the [EdgeInsetsGeometry] object in each dimension by the given factor.
  ///
  /// This operator returns an object of the same type as the operand.
  EdgeInsetsGeometry operator *(double other);

  /// Divides the [EdgeInsetsGeometry] object in each dimension by the given factor.
  ///
  /// This operator returns an object of the same type as the operand.
  EdgeInsetsGeometry operator /(double other);

  /// Integer divides the [EdgeInsetsGeometry] object in each dimension by the given factor.
  ///
  /// This operator returns an object of the same type as the operand.
  ///
  /// This operator may have unexpected results when applied to a mixture of
  /// [EdgeInsets] and [EdgeInsetsDirectional] objects.
  EdgeInsetsGeometry operator ~/(double other);

  /// Computes the remainder in each dimension by the given factor.
  ///
  /// This operator returns an object of the same type as the operand.
  ///
  /// This operator may have unexpected results when applied to a mixture of
  /// [EdgeInsets] and [EdgeInsetsDirectional] objects.
  EdgeInsetsGeometry operator %(double other);

  /// Linearly interpolate between two [EdgeInsetsGeometry] objects.
  ///
  /// If either is null, this function interpolates from [EdgeInsets.zero], and
  /// the result is an object of the same type as the non-null argument.
  ///
  /// If [lerp] is applied to two objects of the same type ([EdgeInsets] or
  /// [EdgeInsetsDirectional]), an object of that type will be returned (though
  /// this is not reflected in the type system). Otherwise, an object
  /// representing a combination of both is returned. That object can be turned
  /// into a concrete [EdgeInsets] using [resolve].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static EdgeInsetsGeometry? lerp(
      EdgeInsetsGeometry? a, EdgeInsetsGeometry? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b! * t;
    }
    if (b == null) {
      return a * (1.0 - t);
    }
    if (a is EdgeInsets && b is EdgeInsets) {
      return EdgeInsets.lerp(a, b, t);
    }
    if (a is EdgeInsetsDirectional && b is EdgeInsetsDirectional) {
      return EdgeInsetsDirectional.lerp(a, b, t);
    }
    return _MixedEdgeInsets.fromLRSETB(
      lerpDouble(a._left, b._left, t),
      lerpDouble(a._right, b._right, t),
      lerpDouble(a._start, b._start, t),
      lerpDouble(a._end, b._end, t),
      lerpDouble(a._top, b._top, t),
      lerpDouble(a._bottom, b._bottom, t),
    );
  }

  /// Convert this instance into an [EdgeInsets], which uses literal coordinates
  /// (i.e. the `left` coordinate being explicitly a distance from the left, and
  /// the `right` coordinate being explicitly a distance from the right).
  ///
  /// See also:
  ///
  ///  * [EdgeInsets], for which this is a no-op (returns itself).
  ///  * [EdgeInsetsDirectional], which flips the horizontal direction
  ///    based on the `direction` argument.
  EdgeInsets resolve(TextDirection? direction);

  @override
  String toString() {
    if (_start == 0.0 && _end == 0.0) {
      if (_left == 0.0 && _right == 0.0 && _top == 0.0 && _bottom == 0.0) {
        return 'EdgeInsets.zero';
      }
      if (_left == _right && _right == _top && _top == _bottom) {
        return 'EdgeInsets.all(${_left.toStringAsFixed(1)})';
      }
      return 'EdgeInsets(${_left.toStringAsFixed(1)}, '
          '${_top.toStringAsFixed(1)}, '
          '${_right.toStringAsFixed(1)}, '
          '${_bottom.toStringAsFixed(1)})';
    }
    if (_left == 0.0 && _right == 0.0) {
      return 'EdgeInsetsDirectional(${_start.toStringAsFixed(1)}, '
          '${_top.toStringAsFixed(1)}, '
          '${_end.toStringAsFixed(1)}, '
          '${_bottom.toStringAsFixed(1)})';
    }
    return 'EdgeInsets(${_left.toStringAsFixed(1)}, '
        '${_top.toStringAsFixed(1)}, '
        '${_right.toStringAsFixed(1)}, '
        '${_bottom.toStringAsFixed(1)})'
        ' + '
        'EdgeInsetsDirectional(${_start.toStringAsFixed(1)}, '
        '0.0, '
        '${_end.toStringAsFixed(1)}, '
        '0.0)';
  }

  @override
  bool operator ==(Object other) {
    return other is EdgeInsetsGeometry &&
        other._left == _left &&
        other._right == _right &&
        other._start == _start &&
        other._end == _end &&
        other._top == _top &&
        other._bottom == _bottom;
  }

  @override
  int get hashCode => Object.hash(_left, _right, _start, _end, _top, _bottom);
}

/// An immutable set of offsets in each of the four cardinal directions.
///
/// Typically used for an offset from each of the four sides of a box. For
/// example, the padding inside a box can be represented using this class.
///
/// The [EdgeInsets] class specifies offsets in terms of visual edges, left,
/// top, right, and bottom. These values are not affected by the
/// [TextDirection]. To support both left-to-right and right-to-left layouts,
/// consider using [EdgeInsetsDirectional], which is expressed in terms of
/// _start_, top, _end_, and bottom, where start and end are resolved in terms
/// of a [TextDirection] (typically obtained from the ambient [Directionality]).
///
/// {@tool snippet}
///
/// Here are some examples of how to create [EdgeInsets] instances:
///
/// Typical eight-pixel margin on all sides:
///
/// ```dart
/// const EdgeInsets.all(8.0)
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Eight pixel margin above and below, no horizontal margins:
///
/// ```dart
/// const EdgeInsets.symmetric(vertical: 8.0)
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Left margin indent of 40 pixels:
///
/// ```dart
/// const EdgeInsets.only(left: 40.0)
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Padding], a widget that accepts [EdgeInsets] to describe its margins.
///  * [EdgeInsetsDirectional], which (for properties and arguments that accept
///    the type [EdgeInsetsGeometry]) allows the horizontal insets to be
///    specified in a [TextDirection]-aware manner.
class EdgeInsets extends EdgeInsetsGeometry {
  /// Creates insets from offsets from the left, top, right, and bottom.
  const EdgeInsets.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// Creates insets where all the offsets are `value`.
  ///
  /// {@tool snippet}
  ///
  /// Typical eight-pixel margin on all sides:
  ///
  /// ```dart
  /// const EdgeInsets.all(8.0)
  /// ```
  /// {@end-tool}
  const EdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  /// Creates insets with only the given values non-zero.
  ///
  /// {@tool snippet}
  ///
  /// Left margin indent of 40 pixels:
  ///
  /// ```dart
  /// const EdgeInsets.only(left: 40.0)
  /// ```
  /// {@end-tool}
  const EdgeInsets.only({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  });

  /// Creates insets with symmetrical vertical and horizontal offsets.
  ///
  /// {@tool snippet}
  ///
  /// Eight pixel margin above and below, no horizontal margins:
  ///
  /// ```dart
  /// const EdgeInsets.symmetric(vertical: 8.0)
  /// ```
  /// {@end-tool}
  const EdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  /// Creates insets that match the given view padding.
  ///
  /// If you need the current system padding or view insets in the context of a
  /// widget, consider using [MediaQuery.of] to obtain these values rather than
  /// using the value from a [FlutterView] directly, so that you get notified of
  /// changes.
  EdgeInsets.fromViewPadding(ViewPadding padding, double devicePixelRatio)
      : left = padding.left / devicePixelRatio,
        top = padding.top / devicePixelRatio,
        right = padding.right / devicePixelRatio,
        bottom = padding.bottom / devicePixelRatio;

  /// Deprecated. Will be removed in a future version of Flutter.
  ///
  /// Use [EdgeInsets.fromViewPadding] instead.
  @Deprecated(
    'Use EdgeInsets.fromViewPadding instead. '
    'This feature was deprecated after v3.8.0-14.0.pre.',
  )
  factory EdgeInsets.fromWindowPadding(
          ViewPadding padding, double devicePixelRatio) =
      EdgeInsets.fromViewPadding;

  /// An [EdgeInsets] with zero offsets in each direction.
  static const EdgeInsets zero = EdgeInsets.only();

  /// The offset from the left.
  final double left;

  @override
  double get _left => left;

  /// The offset from the top.
  final double top;

  @override
  double get _top => top;

  /// The offset from the right.
  final double right;

  @override
  double get _right => right;

  /// The offset from the bottom.
  final double bottom;

  @override
  double get _bottom => bottom;

  @override
  double get _start => 0.0;

  @override
  double get _end => 0.0;

  /// An Offset describing the vector from the top left of a rectangle to the
  /// top left of that rectangle inset by this object.
  Offset get topLeft => Offset(left, top);

  /// An Offset describing the vector from the top right of a rectangle to the
  /// top right of that rectangle inset by this object.
  Offset get topRight => Offset(-right, top);

  /// An Offset describing the vector from the bottom left of a rectangle to the
  /// bottom left of that rectangle inset by this object.
  Offset get bottomLeft => Offset(left, -bottom);

  /// An Offset describing the vector from the bottom right of a rectangle to the
  /// bottom right of that rectangle inset by this object.
  Offset get bottomRight => Offset(-right, -bottom);

  /// An [EdgeInsets] with top and bottom as well as left and right flipped.
  @override
  EdgeInsets get flipped => EdgeInsets.fromLTRB(right, bottom, left, top);

  /// Returns a new rect that is bigger than the given rect in each direction by
  /// the amount of inset in each direction. Specifically, the left edge of the
  /// rect is moved left by [left], the top edge of the rect is moved up by
  /// [top], the right edge of the rect is moved right by [right], and the
  /// bottom edge of the rect is moved down by [bottom].
  ///
  /// See also:
  ///
  ///  * [inflateSize], to inflate a [Size] rather than a [Rect].
  ///  * [deflateRect], to deflate a [Rect] rather than inflating it.
  Rect inflateRect(Rect rect) {
    return Rect.fromLTRB(rect.left - left, rect.top - top, rect.right + right,
        rect.bottom + bottom);
  }

  /// Returns a new rect that is smaller than the given rect in each direction by
  /// the amount of inset in each direction. Specifically, the left edge of the
  /// rect is moved right by [left], the top edge of the rect is moved down by
  /// [top], the right edge of the rect is moved left by [right], and the
  /// bottom edge of the rect is moved up by [bottom].
  ///
  /// If the argument's [Rect.size] is smaller than [collapsedSize], then the
  /// resulting rectangle will have negative dimensions.
  ///
  /// See also:
  ///
  ///  * [deflateSize], to deflate a [Size] rather than a [Rect].
  ///  * [inflateRect], to inflate a [Rect] rather than deflating it.
  Rect deflateRect(Rect rect) {
    return Rect.fromLTRB(rect.left + left, rect.top + top, rect.right - right,
        rect.bottom - bottom);
  }

  @override
  EdgeInsetsGeometry subtract(EdgeInsetsGeometry other) {
    if (other is EdgeInsets) {
      return this - other;
    }
    return super.subtract(other);
  }

  @override
  EdgeInsetsGeometry add(EdgeInsetsGeometry other) {
    if (other is EdgeInsets) {
      return this + other;
    }
    return super.add(other);
  }

  @override
  EdgeInsetsGeometry clamp(EdgeInsetsGeometry min, EdgeInsetsGeometry max) {
    return EdgeInsets.fromLTRB(
      clampDouble(_left, min._left, max._left),
      clampDouble(_top, min._top, max._top),
      clampDouble(_right, min._right, max._right),
      clampDouble(_bottom, min._bottom, max._bottom),
    );
  }

  /// Returns the difference between two [EdgeInsets].
  EdgeInsets operator -(EdgeInsets other) {
    return EdgeInsets.fromLTRB(
      left - other.left,
      top - other.top,
      right - other.right,
      bottom - other.bottom,
    );
  }

  /// Returns the sum of two [EdgeInsets].
  EdgeInsets operator +(EdgeInsets other) {
    return EdgeInsets.fromLTRB(
      left + other.left,
      top + other.top,
      right + other.right,
      bottom + other.bottom,
    );
  }

  /// Returns the [EdgeInsets] object with each dimension negated.
  ///
  /// This is the same as multiplying the object by -1.0.
  @override
  EdgeInsets operator -() {
    return EdgeInsets.fromLTRB(
      -left,
      -top,
      -right,
      -bottom,
    );
  }

  /// Scales the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator *(double other) {
    return EdgeInsets.fromLTRB(
      left * other,
      top * other,
      right * other,
      bottom * other,
    );
  }

  /// Divides the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator /(double other) {
    return EdgeInsets.fromLTRB(
      left / other,
      top / other,
      right / other,
      bottom / other,
    );
  }

  /// Integer divides the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator ~/(double other) {
    return EdgeInsets.fromLTRB(
      (left ~/ other).toDouble(),
      (top ~/ other).toDouble(),
      (right ~/ other).toDouble(),
      (bottom ~/ other).toDouble(),
    );
  }

  /// Computes the remainder in each dimension by the given factor.
  @override
  EdgeInsets operator %(double other) {
    return EdgeInsets.fromLTRB(
      left % other,
      top % other,
      right % other,
      bottom % other,
    );
  }

  /// Linearly interpolate between two [EdgeInsets].
  ///
  /// If either is null, this function interpolates from [EdgeInsets.zero].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static EdgeInsets? lerp(EdgeInsets? a, EdgeInsets? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b! * t;
    }
    if (b == null) {
      return a * (1.0 - t);
    }
    return EdgeInsets.fromLTRB(
      lerpDouble(a.left, b.left, t),
      lerpDouble(a.top, b.top, t),
      lerpDouble(a.right, b.right, t),
      lerpDouble(a.bottom, b.bottom, t),
    );
  }

  @override
  EdgeInsets resolve(TextDirection? direction) => this;

  /// Creates a copy of this EdgeInsets but with the given fields replaced
  /// with the new values.
  EdgeInsets copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }
}

/// An immutable set of offsets in each of the four cardinal directions, but
/// whose horizontal components are dependent on the writing direction.
///
/// This can be used to indicate padding from the left in [TextDirection.ltr]
/// text and padding from the right in [TextDirection.rtl] text without having
/// to be aware of the current text direction.
///
/// See also:
///
///  * [EdgeInsets], a variant that uses physical labels (left and right instead
///    of start and end).
class EdgeInsetsDirectional extends EdgeInsetsGeometry {
  /// Creates insets from offsets from the start, top, end, and bottom.
  const EdgeInsetsDirectional.fromSTEB(
      this.start, this.top, this.end, this.bottom);

  /// Creates insets with only the given values non-zero.
  ///
  /// {@tool snippet}
  ///
  /// A margin indent of 40 pixels on the leading side:
  ///
  /// ```dart
  /// const EdgeInsetsDirectional.only(start: 40.0)
  /// ```
  /// {@end-tool}
  const EdgeInsetsDirectional.only({
    this.start = 0.0,
    this.top = 0.0,
    this.end = 0.0,
    this.bottom = 0.0,
  });

  /// Creates insets with symmetric vertical and horizontal offsets.
  ///
  /// This is equivalent to [EdgeInsets.symmetric], since the inset is the same
  /// with either [TextDirection]. This constructor is just a convenience for
  /// type compatibility.
  ///
  /// {@tool snippet}
  /// Eight pixel margin above and below, no horizontal margins:
  ///
  /// ```dart
  /// const EdgeInsetsDirectional.symmetric(vertical: 8.0)
  /// ```
  /// {@end-tool}
  const EdgeInsetsDirectional.symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  })  : start = horizontal,
        end = horizontal,
        top = vertical,
        bottom = vertical;

  /// Creates insets where all the offsets are `value`.
  ///
  /// {@tool snippet}
  ///
  /// Typical eight-pixel margin on all sides:
  ///
  /// ```dart
  /// const EdgeInsetsDirectional.all(8.0)
  /// ```
  /// {@end-tool}
  const EdgeInsetsDirectional.all(double value)
      : start = value,
        top = value,
        end = value,
        bottom = value;

  /// An [EdgeInsetsDirectional] with zero offsets in each direction.
  ///
  /// Consider using [EdgeInsets.zero] instead, since that object has the same
  /// effect, but will be cheaper to [resolve].
  static const EdgeInsetsDirectional zero = EdgeInsetsDirectional.only();

  /// The offset from the start side, the side from which the user will start
  /// reading text.
  ///
  /// This value is normalized into an [EdgeInsets.left] or [EdgeInsets.right]
  /// value by the [resolve] method.
  final double start;

  @override
  double get _start => start;

  /// The offset from the top.
  ///
  /// This value is passed through to [EdgeInsets.top] unmodified by the
  /// [resolve] method.
  final double top;

  @override
  double get _top => top;

  /// The offset from the end side, the side on which the user ends reading
  /// text.
  ///
  /// This value is normalized into an [EdgeInsets.left] or [EdgeInsets.right]
  /// value by the [resolve] method.
  final double end;

  @override
  double get _end => end;

  /// The offset from the bottom.
  ///
  /// This value is passed through to [EdgeInsets.bottom] unmodified by the
  /// [resolve] method.
  final double bottom;

  @override
  double get _bottom => bottom;

  @override
  double get _left => 0.0;

  @override
  double get _right => 0.0;

  @override
  bool get isNonNegative =>
      start >= 0.0 && top >= 0.0 && end >= 0.0 && bottom >= 0.0;

  /// An [EdgeInsetsDirectional] with [top] and [bottom] as well as [start] and [end] flipped.
  @override
  EdgeInsetsDirectional get flipped =>
      EdgeInsetsDirectional.fromSTEB(end, bottom, start, top);

  @override
  EdgeInsetsGeometry subtract(EdgeInsetsGeometry other) {
    if (other is EdgeInsetsDirectional) {
      return this - other;
    }
    return super.subtract(other);
  }

  @override
  EdgeInsetsGeometry add(EdgeInsetsGeometry other) {
    if (other is EdgeInsetsDirectional) {
      return this + other;
    }
    return super.add(other);
  }

  /// Returns the difference between two [EdgeInsetsDirectional] objects.
  EdgeInsetsDirectional operator -(EdgeInsetsDirectional other) {
    return EdgeInsetsDirectional.fromSTEB(
      start - other.start,
      top - other.top,
      end - other.end,
      bottom - other.bottom,
    );
  }

  /// Returns the sum of two [EdgeInsetsDirectional] objects.
  EdgeInsetsDirectional operator +(EdgeInsetsDirectional other) {
    return EdgeInsetsDirectional.fromSTEB(
      start + other.start,
      top + other.top,
      end + other.end,
      bottom + other.bottom,
    );
  }

  /// Returns the [EdgeInsetsDirectional] object with each dimension negated.
  ///
  /// This is the same as multiplying the object by -1.0.
  @override
  EdgeInsetsDirectional operator -() {
    return EdgeInsetsDirectional.fromSTEB(
      -start,
      -top,
      -end,
      -bottom,
    );
  }

  /// Scales the [EdgeInsetsDirectional] object in each dimension by the given factor.
  @override
  EdgeInsetsDirectional operator *(double other) {
    return EdgeInsetsDirectional.fromSTEB(
      start * other,
      top * other,
      end * other,
      bottom * other,
    );
  }

  /// Divides the [EdgeInsetsDirectional] object in each dimension by the given factor.
  @override
  EdgeInsetsDirectional operator /(double other) {
    return EdgeInsetsDirectional.fromSTEB(
      start / other,
      top / other,
      end / other,
      bottom / other,
    );
  }

  /// Integer divides the [EdgeInsetsDirectional] object in each dimension by the given factor.
  @override
  EdgeInsetsDirectional operator ~/(double other) {
    return EdgeInsetsDirectional.fromSTEB(
      (start ~/ other).toDouble(),
      (top ~/ other).toDouble(),
      (end ~/ other).toDouble(),
      (bottom ~/ other).toDouble(),
    );
  }

  /// Computes the remainder in each dimension by the given factor.
  @override
  EdgeInsetsDirectional operator %(double other) {
    return EdgeInsetsDirectional.fromSTEB(
      start % other,
      top % other,
      end % other,
      bottom % other,
    );
  }

  /// Linearly interpolate between two [EdgeInsetsDirectional].
  ///
  /// If either is null, this function interpolates from [EdgeInsetsDirectional.zero].
  ///
  /// To interpolate between two [EdgeInsetsGeometry] objects of arbitrary type
  /// (either [EdgeInsets] or [EdgeInsetsDirectional]), consider the
  /// [EdgeInsetsGeometry.lerp] static method.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static EdgeInsetsDirectional? lerp(
      EdgeInsetsDirectional? a, EdgeInsetsDirectional? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b! * t;
    }
    if (b == null) {
      return a * (1.0 - t);
    }
    return EdgeInsetsDirectional.fromSTEB(
      lerpDouble(a.start, b.start, t),
      lerpDouble(a.top, b.top, t),
      lerpDouble(a.end, b.end, t),
      lerpDouble(a.bottom, b.bottom, t),
    );
  }

  @override
  EdgeInsets resolve(TextDirection? direction) {
    assert(direction != null);
    switch (direction!) {
      case TextDirection.rtl:
        return EdgeInsets.fromLTRB(end, top, start, bottom);
      case TextDirection.ltr:
        return EdgeInsets.fromLTRB(start, top, end, bottom);
    }
  }
}

class _MixedEdgeInsets extends EdgeInsetsGeometry {
  const _MixedEdgeInsets.fromLRSETB(
      this._left, this._right, this._start, this._end, this._top, this._bottom);

  @override
  final double _left;

  @override
  final double _right;

  @override
  final double _start;

  @override
  final double _end;

  @override
  final double _top;

  @override
  final double _bottom;

  @override
  bool get isNonNegative {
    return _left >= 0.0 &&
        _right >= 0.0 &&
        _start >= 0.0 &&
        _end >= 0.0 &&
        _top >= 0.0 &&
        _bottom >= 0.0;
  }

  @override
  _MixedEdgeInsets operator -() {
    return _MixedEdgeInsets.fromLRSETB(
      -_left,
      -_right,
      -_start,
      -_end,
      -_top,
      -_bottom,
    );
  }

  @override
  _MixedEdgeInsets operator *(double other) {
    return _MixedEdgeInsets.fromLRSETB(
      _left * other,
      _right * other,
      _start * other,
      _end * other,
      _top * other,
      _bottom * other,
    );
  }

  @override
  _MixedEdgeInsets operator /(double other) {
    return _MixedEdgeInsets.fromLRSETB(
      _left / other,
      _right / other,
      _start / other,
      _end / other,
      _top / other,
      _bottom / other,
    );
  }

  @override
  _MixedEdgeInsets operator ~/(double other) {
    return _MixedEdgeInsets.fromLRSETB(
      (_left ~/ other).toDouble(),
      (_right ~/ other).toDouble(),
      (_start ~/ other).toDouble(),
      (_end ~/ other).toDouble(),
      (_top ~/ other).toDouble(),
      (_bottom ~/ other).toDouble(),
    );
  }

  @override
  _MixedEdgeInsets operator %(double other) {
    return _MixedEdgeInsets.fromLRSETB(
      _left % other,
      _right % other,
      _start % other,
      _end % other,
      _top % other,
      _bottom % other,
    );
  }

  @override
  EdgeInsets resolve(TextDirection? direction) {
    assert(direction != null);
    switch (direction!) {
      case TextDirection.rtl:
        return EdgeInsets.fromLTRB(
            _end + _left, _top, _start + _right, _bottom);
      case TextDirection.ltr:
        return EdgeInsets.fromLTRB(
            _start + _left, _top, _end + _right, _bottom);
    }
  }
}

/// Different ways to clip a widget's content.
enum Clip {
  /// No clip at all.
  ///
  /// This is the default option for most widgets: if the content does not
  /// overflow the widget boundary, don't pay any performance cost for clipping.
  ///
  /// If the content does overflow, please explicitly specify the following
  /// [Clip] options:
  ///  * [hardEdge], which is the fastest clipping, but with lower fidelity.
  ///  * [antiAlias], which is a little slower than [hardEdge], but with smoothed edges.
  ///  * [antiAliasWithSaveLayer], which is much slower than [antiAlias], and should
  ///    rarely be used.
  none,

  /// Clip, but do not apply anti-aliasing.
  ///
  /// This mode enables clipping, but curves and non-axis-aligned straight lines will be
  /// jagged as no effort is made to anti-alias.
  ///
  /// Faster than other clipping modes, but slower than [none].
  ///
  /// This is a reasonable choice when clipping is needed, if the container is an axis-
  /// aligned rectangle or an axis-aligned rounded rectangle with very small corner radii.
  ///
  /// See also:
  ///
  ///  * [antiAlias], which is more reasonable when clipping is needed and the shape is not
  ///    an axis-aligned rectangle.
  hardEdge,

  /// Clip with anti-aliasing.
  ///
  /// This mode has anti-aliased clipping edges to achieve a smoother look.
  ///
  /// It' s much faster than [antiAliasWithSaveLayer], but slower than [hardEdge].
  ///
  /// This will be the common case when dealing with circles and arcs.
  ///
  /// Different from [hardEdge] and [antiAliasWithSaveLayer], this clipping may have
  /// bleeding edge artifacts.
  /// (See https://fiddle.skia.org/c/21cb4c2b2515996b537f36e7819288ae for an example.)
  ///
  /// See also:
  ///
  ///  * [hardEdge], which is a little faster, but with lower fidelity.
  ///  * [antiAliasWithSaveLayer], which is much slower, but can avoid the
  ///    bleeding edges if there's no other way.
  ///  * [Paint.isAntiAlias], which is the anti-aliasing switch for general draw operations.
  antiAlias,

  /// Clip with anti-aliasing and saveLayer immediately following the clip.
  ///
  /// This mode not only clips with anti-aliasing, but also allocates an offscreen
  /// buffer. All subsequent paints are carried out on that buffer before finally
  /// being clipped and composited back.
  ///
  /// This is very slow. It has no bleeding edge artifacts (that [antiAlias] has)
  /// but it changes the semantics as an offscreen buffer is now introduced.
  /// (See https://github.com/flutter/flutter/issues/18057#issuecomment-394197336
  /// for a difference between paint without saveLayer and paint with saveLayer.)
  ///
  /// This will be only rarely needed. One case where you might need this is if
  /// you have an image overlaid on a very different background color. In these
  /// cases, consider whether you can avoid overlaying multiple colors in one
  /// spot (e.g. by having the background color only present where the image is
  /// absent). If you can, [antiAlias] would be fine and much faster.
  ///
  /// See also:
  ///
  ///  * [antiAlias], which is much faster, and has similar clipping results.
  antiAliasWithSaveLayer,
}

@immutable
abstract class Constraints {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const Constraints();

  /// Whether there is exactly one size possible given these constraints.
  bool get isTight;

  /// Whether the constraint is expressed in a consistent manner.
  bool get isNormalized;
}

/// Defines what happens at the edge of a gradient or the sampling of a source image
/// in an [ImageFilter].
///
/// A gradient is defined along a finite inner area. In the case of a linear
/// gradient, it's between the parallel lines that are orthogonal to the line
/// drawn between two points. In the case of radial gradients, it's the disc
/// that covers the circle centered on a particular point up to a given radius.
///
/// An image filter reads source samples from a source image and performs operations
/// on those samples to produce a result image. An image defines color samples only
/// for pixels within the bounds of the image but some filter operations, such as a blur
/// filter, read samples over a wide area to compute the output for a given pixel. Such
/// a filter would need to combine samples from inside the image with hypothetical
/// color values from outside the image.
///
/// This enum is used to define how the gradient or image filter should treat the regions
/// outside that defined inner area.
///
/// See also:
///
///  * [painting.Gradient], the superclass for [LinearGradient] and
///    [RadialGradient], as used by [BoxDecoration] et al, which works in
///    relative coordinates and can create a [Shader] representing the gradient
///    for a particular [Rect] on demand.
///  * [dart:ui.Gradient], the low-level class used when dealing with the
///    [Paint.shader] property directly, with its [Gradient.linear] and
///    [Gradient.radial] constructors.
///  * [dart:ui.ImageFilter.blur], an ImageFilter that may sometimes need to
///    read samples from outside an image to combine with the pixels near the
///    edge of the image.
// These enum values must be kept in sync with DlTileMode.
enum TileMode {
  /// Samples beyond the edge are clamped to the nearest color in the defined inner area.
  ///
  /// A gradient will paint all the regions outside the inner area with the
  /// color at the end of the color stop list closest to that region.
  ///
  /// An image filter will substitute the nearest edge pixel for any samples taken from
  /// outside its source image.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_sweep.png)
  clamp,

  /// Samples beyond the edge are repeated from the far end of the defined area.
  ///
  /// For a gradient, this technique is as if the stop points from 0.0 to 1.0 were then
  /// repeated from 1.0 to 2.0, 2.0 to 3.0, and so forth (and for linear gradients, similarly
  /// from -1.0 to 0.0, -2.0 to -1.0, etc).
  ///
  /// An image filter will treat its source image as if it were tiled across the enlarged
  /// sample space from which it reads, each tile in the same orientation as the base image.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_sweep.png)
  repeated,

  /// Samples beyond the edge are mirrored back and forth across the defined area.
  ///
  /// For a gradient, this technique is as if the stop points from 0.0 to 1.0 were then
  /// repeated backwards from 2.0 to 1.0, then forwards from 2.0 to 3.0, then backwards
  /// again from 4.0 to 3.0, and so forth (and for linear gradients, similarly in the
  /// negative direction).
  ///
  /// An image filter will treat its source image as tiled in an alternating forwards and
  /// backwards or upwards and downwards direction across the sample space from which
  /// it is reading.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_sweep.png)
  mirror,

  /// Samples beyond the edge are treated as transparent black.
  ///
  /// A gradient will render transparency over any region that is outside the circle of a
  /// radial gradient or outside the parallel lines that define the inner area of a linear
  /// gradient.
  ///
  /// An image filter will substitute transparent black for any sample it must read from
  /// outside its source image.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_decal_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_decal_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_decal_sweep.png)
  decal,
}
