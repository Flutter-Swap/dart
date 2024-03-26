// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:swap/src/utils/numbers.dart';

import 'basic_types.dart';

/// Immutable layout constraints for [RenderBox] layout.
///
/// A [Size] respects a [BoxConstraints] if, and only if, all of the following
/// relations hold:
///
/// * [minWidth] <= [Size.width] <= [maxWidth]
/// * [minHeight] <= [Size.height] <= [maxHeight]
///
/// The constraints themselves must satisfy these relations:
///
/// * 0.0 <= [minWidth] <= [maxWidth] <= [double.infinity]
/// * 0.0 <= [minHeight] <= [maxHeight] <= [double.infinity]
///
/// [double.infinity] is a legal value for each constraint.
///
/// ## The box layout model
///
/// Render objects in the Flutter framework are laid out by a one-pass layout
/// model which walks down the render tree passing constraints, then walks back
/// up the render tree passing concrete geometry.
///
/// For boxes, the constraints are [BoxConstraints], which, as described herein,
/// consist of four numbers: a minimum width [minWidth], a maximum width
/// [maxWidth], a minimum height [minHeight], and a maximum height [maxHeight].
///
/// The geometry for boxes consists of a [Size], which must satisfy the
/// constraints described above.
///
/// Each [RenderBox] (the objects that provide the layout models for box
/// widgets) receives [BoxConstraints] from its parent, then lays out each of
/// its children, then picks a [Size] that satisfies the [BoxConstraints].
///
/// Render objects position their children independently of laying them out.
/// Frequently, the parent will use the children's sizes to determine their
/// position. A child does not know its position and will not necessarily be
/// laid out again, or repainted, if its position changes.
///
/// ## Terminology
///
/// When the minimum constraints and the maximum constraint in an axis are the
/// same, that axis is _tightly_ constrained. See: [
/// BoxConstraints.tightFor], [BoxConstraints.tightForFinite], [tighten],
/// [hasTightWidth], [hasTightHeight], [isTight].
///
/// An axis with a minimum constraint of 0.0 is _loose_ (regardless of the
/// maximum constraint; if it is also 0.0, then the axis is simultaneously tight
/// and loose!). See: [BoxConstraints.loose], [loosen].
///
/// An axis whose maximum constraint is not infinite is _bounded_. See:
/// [hasBoundedWidth], [hasBoundedHeight].
///
/// An axis whose maximum constraint is infinite is _unbounded_. An axis is
/// _expanding_ if it is tightly infinite (its minimum and maximum constraints
/// are both infinite). See: [BoxConstraints.expand].
///
/// An axis whose _minimum_ constraint is infinite is just said to be _infinite_
/// (since by definition the maximum constraint must also be infinite in that
/// case). See: [hasInfiniteWidth], [hasInfiniteHeight].
///
/// A size is _constrained_ when it satisfies a [BoxConstraints] description.
/// See: [constrain], [constrainWidth], [constrainHeight],
/// [constrainDimensions], [constrainSizeAndAttemptToPreserveAspectRatio],
/// [isSatisfiedBy].
class BoxConstraints extends Constraints {
  /// Creates box constraints with the given constraints.
  const BoxConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  /// Creates box constraints that is respected only by the given size.
  BoxConstraints.tight(Size size)
      : minWidth = size.width,
        maxWidth = size.width,
        minHeight = size.height,
        maxHeight = size.height;

  /// Creates box constraints that require the given width or height.
  ///
  /// See also:
  ///
  ///  * [BoxConstraints.tightForFinite], which is similar but instead of
  ///    being tight if the value is non-null, is tight if the value is not
  ///    infinite.
  const BoxConstraints.tightFor({
    double? width,
    double? height,
  })  : minWidth = width ?? 0.0,
        maxWidth = width ?? double.infinity,
        minHeight = height ?? 0.0,
        maxHeight = height ?? double.infinity;

  /// Creates box constraints that require the given width or height, except if
  /// they are infinite.
  ///
  /// See also:
  ///
  ///  * [BoxConstraints.tightFor], which is similar but instead of being
  ///    tight if the value is not infinite, is tight if the value is non-null.
  const BoxConstraints.tightForFinite({
    double width = double.infinity,
    double height = double.infinity,
  })  : minWidth = width != double.infinity ? width : 0.0,
        maxWidth = width != double.infinity ? width : double.infinity,
        minHeight = height != double.infinity ? height : 0.0,
        maxHeight = height != double.infinity ? height : double.infinity;

  /// Creates box constraints that forbid sizes larger than the given size.
  BoxConstraints.loose(Size size)
      : minWidth = 0.0,
        maxWidth = size.width,
        minHeight = 0.0,
        maxHeight = size.height;

  /// Creates box constraints that expand to fill another box constraints.
  ///
  /// If width or height is given, the constraints will require exactly the
  /// given value in the given dimension.
  const BoxConstraints.expand({
    double? width,
    double? height,
  })  : minWidth = width ?? double.infinity,
        maxWidth = width ?? double.infinity,
        minHeight = height ?? double.infinity,
        maxHeight = height ?? double.infinity;

  /// The minimum width that satisfies the constraints.
  final double minWidth;

  /// The maximum width that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxWidth;

  /// The minimum height that satisfies the constraints.
  final double minHeight;

  /// The maximum height that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxHeight;

  /// Creates a copy of this box constraints but with the given fields replaced with the new values.
  BoxConstraints copyWith({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return BoxConstraints(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }

  /// Returns new box constraints that are smaller by the given edge dimensions.
  BoxConstraints deflate(EdgeInsets edges) {
    final double horizontal = edges.horizontal;
    final double vertical = edges.vertical;
    final double deflatedMinWidth = math.max(0.0, minWidth - horizontal);
    final double deflatedMinHeight = math.max(0.0, minHeight - vertical);
    return BoxConstraints(
      minWidth: deflatedMinWidth,
      maxWidth: math.max(deflatedMinWidth, maxWidth - horizontal),
      minHeight: deflatedMinHeight,
      maxHeight: math.max(deflatedMinHeight, maxHeight - vertical),
    );
  }

  /// Returns new box constraints that remove the minimum width and height requirements.
  BoxConstraints loosen() {
    return BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  /// Returns new box constraints that respect the given constraints while being
  /// as close as possible to the original constraints.
  BoxConstraints enforce(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth:
          clampDouble(minWidth, constraints.minWidth, constraints.maxWidth),
      maxWidth:
          clampDouble(maxWidth, constraints.minWidth, constraints.maxWidth),
      minHeight:
          clampDouble(minHeight, constraints.minHeight, constraints.maxHeight),
      maxHeight:
          clampDouble(maxHeight, constraints.minHeight, constraints.maxHeight),
    );
  }

  /// Returns new box constraints with a tight width and/or height as close to
  /// the given width and height as possible while still respecting the original
  /// box constraints.
  BoxConstraints tighten({double? width, double? height}) {
    return BoxConstraints(
      minWidth:
          width == null ? minWidth : clampDouble(width, minWidth, maxWidth),
      maxWidth:
          width == null ? maxWidth : clampDouble(width, minWidth, maxWidth),
      minHeight: height == null
          ? minHeight
          : clampDouble(height, minHeight, maxHeight),
      maxHeight: height == null
          ? maxHeight
          : clampDouble(height, minHeight, maxHeight),
    );
  }

  /// A box constraints with the width and height constraints flipped.
  BoxConstraints get flipped {
    return BoxConstraints(
      minWidth: minHeight,
      maxWidth: maxHeight,
      minHeight: minWidth,
      maxHeight: maxWidth,
    );
  }

  /// Returns box constraints with the same width constraints but with
  /// unconstrained height.
  BoxConstraints widthConstraints() =>
      BoxConstraints(minWidth: minWidth, maxWidth: maxWidth);

  /// Returns box constraints with the same height constraints but with
  /// unconstrained width.
  BoxConstraints heightConstraints() =>
      BoxConstraints(minHeight: minHeight, maxHeight: maxHeight);

  /// Returns the width that both satisfies the constraints and is as close as
  /// possible to the given width.
  double constrainWidth([double width = double.infinity]) {
    return clampDouble(width, minWidth, maxWidth);
  }

  /// Returns the height that both satisfies the constraints and is as close as
  /// possible to the given height.
  double constrainHeight([double height = double.infinity]) {
    return clampDouble(height, minHeight, maxHeight);
  }

  Size _debugPropagateDebugSize(Size size, Size result) {
    assert(() {
      return true;
    }());
    return result;
  }

  /// Returns the size that both satisfies the constraints and is as close as
  /// possible to the given size.
  ///
  /// See also:
  ///
  ///  * [constrainDimensions], which applies the same algorithm to
  ///    separately provided widths and heights.
  Size constrain(Size size) {
    Size result =
        Size(constrainWidth(size.width), constrainHeight(size.height));
    assert(() {
      result = _debugPropagateDebugSize(size, result);
      return true;
    }());
    return result;
  }

  /// Returns the size that both satisfies the constraints and is as close as
  /// possible to the given width and height.
  ///
  /// When you already have a [Size], prefer [constrain], which applies the same
  /// algorithm to a [Size] directly.
  Size constrainDimensions(double width, double height) {
    return Size(constrainWidth(width), constrainHeight(height));
  }

  /// Returns a size that attempts to meet the following conditions, in order:
  ///
  ///  * The size must satisfy these constraints.
  ///  * The aspect ratio of the returned size matches the aspect ratio of the
  ///    given size.
  ///  * The returned size is as big as possible while still being equal to or
  ///    smaller than the given size.
  Size constrainSizeAndAttemptToPreserveAspectRatio(Size size) {
    if (isTight) {
      Size result = smallest;
      assert(() {
        result = _debugPropagateDebugSize(size, result);
        return true;
      }());
      return result;
    }

    double width = size.width;
    double height = size.height;
    assert(width > 0.0);
    assert(height > 0.0);
    final double aspectRatio = width / height;

    if (width > maxWidth) {
      width = maxWidth;
      height = width / aspectRatio;
    }

    if (height > maxHeight) {
      height = maxHeight;
      width = height * aspectRatio;
    }

    if (width < minWidth) {
      width = minWidth;
      height = width / aspectRatio;
    }

    if (height < minHeight) {
      height = minHeight;
      width = height * aspectRatio;
    }

    Size result = Size(constrainWidth(width), constrainHeight(height));
    assert(() {
      result = _debugPropagateDebugSize(size, result);
      return true;
    }());
    return result;
  }

  /// The biggest size that satisfies the constraints.
  Size get biggest => Size(constrainWidth(), constrainHeight());

  /// The smallest size that satisfies the constraints.
  Size get smallest => Size(constrainWidth(0.0), constrainHeight(0.0));

  /// Whether there is exactly one width value that satisfies the constraints.
  bool get hasTightWidth => minWidth >= maxWidth;

  /// Whether there is exactly one height value that satisfies the constraints.
  bool get hasTightHeight => minHeight >= maxHeight;

  /// Whether there is exactly one size that satisfies the constraints.
  @override
  bool get isTight => hasTightWidth && hasTightHeight;

  /// Whether there is an upper bound on the maximum width.
  ///
  /// See also:
  ///
  ///  * [hasBoundedHeight], the equivalent for the vertical axis.
  ///  * [hasInfiniteWidth], which describes whether the minimum width
  ///    constraint is infinite.
  bool get hasBoundedWidth => maxWidth < double.infinity;

  /// Whether there is an upper bound on the maximum height.
  ///
  /// See also:
  ///
  ///  * [hasBoundedWidth], the equivalent for the horizontal axis.
  ///  * [hasInfiniteHeight], which describes whether the minimum height
  ///    constraint is infinite.
  bool get hasBoundedHeight => maxHeight < double.infinity;

  /// Whether the width constraint is infinite.
  ///
  /// Such a constraint is used to indicate that a box should grow as large as
  /// some other constraint (in this case, horizontally). If constraints are
  /// infinite, then they must have other (non-infinite) constraints [enforce]d
  /// upon them, or must be [tighten]ed, before they can be used to derive a
  /// [Size] for a [RenderBox.size].
  ///
  /// See also:
  ///
  ///  * [hasInfiniteHeight], the equivalent for the vertical axis.
  ///  * [hasBoundedWidth], which describes whether the maximum width
  ///    constraint is finite.
  bool get hasInfiniteWidth => minWidth >= double.infinity;

  /// Whether the height constraint is infinite.
  ///
  /// Such a constraint is used to indicate that a box should grow as large as
  /// some other constraint (in this case, vertically). If constraints are
  /// infinite, then they must have other (non-infinite) constraints [enforce]d
  /// upon them, or must be [tighten]ed, before they can be used to derive a
  /// [Size] for a [RenderBox.size].
  ///
  /// See also:
  ///
  ///  * [hasInfiniteWidth], the equivalent for the horizontal axis.
  ///  * [hasBoundedHeight], which describes whether the maximum height
  ///    constraint is finite.
  bool get hasInfiniteHeight => minHeight >= double.infinity;

  /// Whether the given size satisfies the constraints.
  bool isSatisfiedBy(Size size) {
    return (minWidth <= size.width) &&
        (size.width <= maxWidth) &&
        (minHeight <= size.height) &&
        (size.height <= maxHeight);
  }

  /// Scales each constraint parameter by the given factor.
  BoxConstraints operator *(double factor) {
    return BoxConstraints(
      minWidth: minWidth * factor,
      maxWidth: maxWidth * factor,
      minHeight: minHeight * factor,
      maxHeight: maxHeight * factor,
    );
  }

  /// Scales each constraint parameter by the inverse of the given factor.
  BoxConstraints operator /(double factor) {
    return BoxConstraints(
      minWidth: minWidth / factor,
      maxWidth: maxWidth / factor,
      minHeight: minHeight / factor,
      maxHeight: maxHeight / factor,
    );
  }

  /// Scales each constraint parameter by the inverse of the given factor, rounded to the nearest integer.
  BoxConstraints operator ~/(double factor) {
    return BoxConstraints(
      minWidth: (minWidth ~/ factor).toDouble(),
      maxWidth: (maxWidth ~/ factor).toDouble(),
      minHeight: (minHeight ~/ factor).toDouble(),
      maxHeight: (maxHeight ~/ factor).toDouble(),
    );
  }

  /// Computes the remainder of each constraint parameter by the given value.
  BoxConstraints operator %(double value) {
    return BoxConstraints(
      minWidth: minWidth % value,
      maxWidth: maxWidth % value,
      minHeight: minHeight % value,
      maxHeight: maxHeight % value,
    );
  }

  /// Linearly interpolate between two BoxConstraints.
  ///
  /// If either is null, this function interpolates from a [BoxConstraints]
  /// object whose fields are all set to 0.0.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static BoxConstraints? lerp(BoxConstraints? a, BoxConstraints? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b! * t;
    }
    if (b == null) {
      return a * (1.0 - t);
    }
    assert(
        (a.minWidth.isFinite && b.minWidth.isFinite) ||
            (a.minWidth == double.infinity && b.minWidth == double.infinity),
        'Cannot interpolate between finite constraints and unbounded constraints.');
    assert(
        (a.maxWidth.isFinite && b.maxWidth.isFinite) ||
            (a.maxWidth == double.infinity && b.maxWidth == double.infinity),
        'Cannot interpolate between finite constraints and unbounded constraints.');
    assert(
        (a.minHeight.isFinite && b.minHeight.isFinite) ||
            (a.minHeight == double.infinity && b.minHeight == double.infinity),
        'Cannot interpolate between finite constraints and unbounded constraints.');
    assert(
        (a.maxHeight.isFinite && b.maxHeight.isFinite) ||
            (a.maxHeight == double.infinity && b.maxHeight == double.infinity),
        'Cannot interpolate between finite constraints and unbounded constraints.');
    return BoxConstraints(
      minWidth: a.minWidth.isFinite
          ? lerpDouble(a.minWidth, b.minWidth, t)
          : double.infinity,
      maxWidth: a.maxWidth.isFinite
          ? lerpDouble(a.maxWidth, b.maxWidth, t)
          : double.infinity,
      minHeight: a.minHeight.isFinite
          ? lerpDouble(a.minHeight, b.minHeight, t)
          : double.infinity,
      maxHeight: a.maxHeight.isFinite
          ? lerpDouble(a.maxHeight, b.maxHeight, t)
          : double.infinity,
    );
  }

  /// Returns whether the object's constraints are normalized.
  /// Constraints are normalized if the minimums are less than or
  /// equal to the corresponding maximums.
  ///
  /// For example, a BoxConstraints object with a minWidth of 100.0
  /// and a maxWidth of 90.0 is not normalized.
  ///
  /// Most of the APIs on BoxConstraints expect the constraints to be
  /// normalized and have undefined behavior when they are not. In
  /// debug mode, many of these APIs will assert if the constraints
  /// are not normalized.
  @override
  bool get isNormalized {
    return minWidth >= 0.0 &&
        minWidth <= maxWidth &&
        minHeight >= 0.0 &&
        minHeight <= maxHeight;
  }

  /// Returns a box constraints that [isNormalized].
  ///
  /// The returned [maxWidth] is at least as large as the [minWidth]. Similarly,
  /// the returned [maxHeight] is at least as large as the [minHeight].
  BoxConstraints normalize() {
    if (isNormalized) {
      return this;
    }
    final double minWidth = this.minWidth >= 0.0 ? this.minWidth : 0.0;
    final double minHeight = this.minHeight >= 0.0 ? this.minHeight : 0.0;
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: minWidth > maxWidth ? minWidth : maxWidth,
      minHeight: minHeight,
      maxHeight: minHeight > maxHeight ? minHeight : maxHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BoxConstraints &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight;
  }

  @override
  int get hashCode {
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight);
  }

  @override
  String toString() {
    final String annotation = isNormalized ? '' : '; NOT NORMALIZED';
    if (minWidth == double.infinity && minHeight == double.infinity) {
      return 'BoxConstraints(biggest$annotation)';
    }
    if (minWidth == 0 &&
        maxWidth == double.infinity &&
        minHeight == 0 &&
        maxHeight == double.infinity) {
      return 'BoxConstraints(unconstrained$annotation)';
    }
    String describe(double min, double max, String dim) {
      if (min == max) {
        return '$dim=${min.toStringAsFixed(1)}';
      }
      return '${min.toStringAsFixed(1)}<=$dim<=${max.toStringAsFixed(1)}';
    }

    final String width = describe(minWidth, maxWidth, 'w');
    final String height = describe(minHeight, maxHeight, 'h');
    return 'BoxConstraints($width, $height$annotation)';
  }
}
