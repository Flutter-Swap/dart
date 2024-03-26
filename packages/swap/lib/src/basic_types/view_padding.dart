class ViewPadding {
  const ViewPadding._(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  /// The distance from the left edge to the first unpadded pixel, in physical pixels.
  final double left;

  /// The distance from the top edge to the first unpadded pixel, in physical pixels.
  final double top;

  /// The distance from the right edge to the first unpadded pixel, in physical pixels.
  final double right;

  /// The distance from the bottom edge to the first unpadded pixel, in physical pixels.
  final double bottom;

  /// A view padding that has zeros for each edge.
  static const ViewPadding zero =
      ViewPadding._(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0);

  @override
  String toString() {
    return 'ViewPadding(left: $left, top: $top, right: $right, bottom: $bottom)';
  }
}
