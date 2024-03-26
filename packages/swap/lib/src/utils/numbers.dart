/// Same as [num.clamp] but optimized for a non-null [double].
///
/// This is faster because it avoids polymorphism, boxing, and special cases for
/// floating point numbers.
//
// See also: //dev/benchmarks/microbenchmarks/lib/foundation/clamp.dart
double clampDouble(double x, double min, double max) {
  assert(min <= max && !max.isNaN && !min.isNaN);
  if (x < min) {
    return min;
  }
  if (x > max) {
    return max;
  }
  if (x.isNaN) {
    return max;
  }
  return x;
}

/// Linearly interpolate between two doubles.
///
/// Same as [lerpDouble] but specialized for non-null `double` type.
double lerpDouble(double a, double b, double t) {
  return a * (1.0 - t) + b * t;
}

/// Linearly interpolate between two integers.
///
/// Same as [lerpDouble] but specialized for non-null `int` type.
double lerpInt(int a, int b, double t) {
  return a + (b - a) * t;
}

/// Same as [num.clamp] but specialized for non-null [int].
int clampInt(int value, int min, int max) {
  assert(min <= max);
  if (value < min) {
    return min;
  } else if (value > max) {
    return max;
  } else {
    return value;
  }
}
