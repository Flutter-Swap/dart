// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:swap/src/utils/collections.dart';

/// A description of an icon fulfilled by a font glyph.
///
/// See [Icons] for a number of predefined icons available for material
/// design applications.
///
/// In release builds, the Flutter tool will tree shake out of bundled fonts
/// the code points (or instances of [IconData]) which are not referenced from
/// Dart app code. See the [staticIconProvider] annotation for more details.
@immutable
class IconData {
  /// Creates icon data.
  ///
  /// Rarely used directly. Instead, consider using one of the predefined icons
  /// like the [Icons] collection.
  ///
  /// The [fontPackage] argument must be non-null when using a font family that
  /// is included in a package. This is used when selecting the font.
  ///
  /// Instantiating non-const instances of this class in your app will
  /// mean the app cannot be built in release mode with icon tree-shaking (it
  /// need to be explicitly opted out at build time). See [staticIconProvider]
  /// for more context.
  const IconData(
    this.codePoint, {
    this.fontFamily,
    this.fontPackage,
    this.matchTextDirection = false,
    this.fontFamilyFallback,
  });

  /// The Unicode code point at which this icon is stored in the icon font.
  final int codePoint;

  /// The font family from which the glyph for the [codePoint] will be selected.
  final String? fontFamily;

  /// The name of the package from which the font family is included.
  ///
  /// The name is used by the [Icon] widget when configuring the [TextStyle] so
  /// that the given [fontFamily] is obtained from the appropriate asset.
  ///
  /// See also:
  ///
  ///  * [TextStyle], which describes how to use fonts from other packages.
  final String? fontPackage;

  /// Whether this icon should be automatically mirrored in right-to-left
  /// environments.
  ///
  /// The [Icon] widget respects this value by mirroring the icon when the
  /// [Directionality] is [TextDirection.rtl].
  final bool matchTextDirection;

  /// The ordered list of font families to fall back on when a glyph cannot be found in a higher priority font family.
  ///
  /// For more details, refer to the documentation of [TextStyle]
  final List<String>? fontFamilyFallback;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is IconData &&
        other.codePoint == codePoint &&
        other.fontFamily == fontFamily &&
        other.fontPackage == fontPackage &&
        other.matchTextDirection == matchTextDirection &&
        listEquals(other.fontFamilyFallback, fontFamilyFallback);
  }

  @override
  int get hashCode {
    return Object.hash(
      codePoint,
      fontFamily,
      fontPackage,
      matchTextDirection,
      Object.hashAll(fontFamilyFallback ?? const <String?>[]),
    );
  }

  @override
  String toString() =>
      'IconData(U+${codePoint.toRadixString(16).toUpperCase().padLeft(5, '0')})';
}
