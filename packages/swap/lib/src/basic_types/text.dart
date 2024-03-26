import 'dart:typed_data';

import 'package:swap/src/utils/numbers.dart';
import 'package:swap/src/basic_types/basic_types.dart';

// If we actually run on big endian machines, we'll need to do something smarter
// here. We don't use [Endian.Host] because it's not a compile-time
// constant and can't propagate into the set/get calls.
const Endian _kFakeHostEndian = Endian.little;

/// How overflowing text should be handled.
///
/// A [TextOverflow] can be passed to [Text] and [RichText] via their
/// [Text.overflow] and [RichText.overflow] properties respectively.
enum TextOverflow {
  /// Clip the overflowing text to fix its container.
  clip,

  /// Fade the overflowing text to transparent.
  fade,

  /// Use an ellipsis to indicate that the text has overflowed.
  ellipsis,

  /// Render overflowing text outside of its container.
  visible,
}

/// The different ways of measuring the width of one or more lines of text.
///
/// See [Text.textWidthBasis], for example.
enum TextWidthBasis {
  /// multiline text will take up the full width given by the parent. For single
  /// line text, only the minimum amount of width needed to contain the text
  /// will be used. A common use case for this is a standard series of
  /// paragraphs.
  parent,

  /// The width will be exactly enough to contain the longest line and no
  /// longer. A common use case for this is chat bubbles.
  longestLine,
}

enum TextDirection {
  /// The text flows from right to left (e.g. Arabic, Hebrew).
  rtl,

  /// The text flows from left to right (e.g., English, French).
  ltr,
}

/// A horizontal line used for aligning text.
enum TextBaseline {
  /// The horizontal line used to align the bottom of glyphs for alphabetic characters.
  alphabetic,

  /// The horizontal line used to align ideographic characters.
  ideographic,
}

/// Whether and how to align text horizontally.
// The order of this enum must match the order of the values in RenderStyleConstants.h's ETextAlign.
enum TextAlign {
  /// Align the text on the left edge of the container.
  left,

  /// Align the text on the right edge of the container.
  right,

  /// Align the text in the center of the container.
  center,

  /// Stretch lines of text that end with a soft line break to fill the width of
  /// the container.
  ///
  /// Lines that end with hard line breaks are aligned towards the [start] edge.
  justify,

  /// Align the text on the leading edge of the container.
  ///
  /// For left-to-right text ([TextDirection.ltr]), this is the left edge.
  ///
  /// For right-to-left text ([TextDirection.rtl]), this is the right edge.
  start,

  /// Align the text on the trailing edge of the container.
  ///
  /// For left-to-right text ([TextDirection.ltr]), this is the right edge.
  ///
  /// For right-to-left text ([TextDirection.rtl]), this is the left edge.
  end,
}

/// Whether to use the italic type variation of glyphs in the font.
///
/// Some modern fonts allow this to be selected in a more fine-grained manner.
/// See [FontVariation.italic] for details.
///
/// Italic type is distinct from slanted glyphs. To control the slant of a
/// glyph, consider the [FontVariation.slant] font feature.
enum FontStyle {
  /// Use the upright ("Roman") glyphs.
  normal,

  /// Use glyphs that have a more pronounced angle and typically a cursive style
  /// ("italic type").
  italic,
}

/// The thickness of the glyphs used to draw the text.
///
/// Fonts are typically weighted on a 9-point scale, which, for historical
/// reasons, uses the names 100 to 900. In Flutter, these are named `w100` to
/// `w900` and have the following conventional meanings:
///
///  * [w100]: Thin, the thinnest font weight.
///
///  * [w200]: Extra light.
///
///  * [w300]: Light.
///
///  * [w400]: Normal. The constant [FontWeight.normal] is an alias for this value.
///
///  * [w500]: Medium.
///
///  * [w600]: Semi-bold.
///
///  * [w700]: Bold. The constant [FontWeight.bold] is an alias for this value.
///
///  * [w800]: Extra-bold.
///
///  * [w900]: Black, the thickest font weight.
///
/// For example, the font named "Roboto Medium" is typically exposed as a font
/// with the name "Roboto" and the weight [FontWeight.w500].
///
/// Some modern fonts allow the weight to be adjusted in arbitrary increments.
/// See [FontVariation.weight] for details.
class FontWeight {
  const FontWeight._(this.index, this.value);

  /// The encoded integer value of this font weight.
  final int index;

  /// The thickness value of this font weight.
  final int value;

  /// Thin, the least thick.
  static const FontWeight w100 = FontWeight._(0, 100);

  /// Extra-light.
  static const FontWeight w200 = FontWeight._(1, 200);

  /// Light.
  static const FontWeight w300 = FontWeight._(2, 300);

  /// Normal / regular / plain.
  static const FontWeight w400 = FontWeight._(3, 400);

  /// Medium.
  static const FontWeight w500 = FontWeight._(4, 500);

  /// Semi-bold.
  static const FontWeight w600 = FontWeight._(5, 600);

  /// Bold.
  static const FontWeight w700 = FontWeight._(6, 700);

  /// Extra-bold.
  static const FontWeight w800 = FontWeight._(7, 800);

  /// Black, the most thick.
  static const FontWeight w900 = FontWeight._(8, 900);

  /// The default font weight.
  static const FontWeight normal = w400;

  /// A commonly used font weight that is heavier than normal.
  static const FontWeight bold = w700;

  /// A list of all the font weights.
  static const List<FontWeight> values = <FontWeight>[
    w100,
    w200,
    w300,
    w400,
    w500,
    w600,
    w700,
    w800,
    w900
  ];

  /// Linearly interpolates between two font weights.
  ///
  /// Rather than using fractional weights, the interpolation rounds to the
  /// nearest weight.
  ///
  /// For a smoother animation of font weight, consider using
  /// [FontVariation.weight] if the font in question supports it.
  ///
  /// If both `a` and `b` are null, then this method will return null. Otherwise,
  /// any null values for `a` or `b` are interpreted as equivalent to [normal]
  /// (also known as [w400]).
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]). The result
  /// is clamped to the range [w100]–[w900].
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static FontWeight? lerp(FontWeight? a, FontWeight? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return values[lerpInt((a ?? normal).index, (b ?? normal).index, t)
        .round()
        .clamp(0, 8)];
  }

  @override
  String toString() {
    return const <int, String>{
      0: 'FontWeight.w100',
      1: 'FontWeight.w200',
      2: 'FontWeight.w300',
      3: 'FontWeight.w400',
      4: 'FontWeight.w500',
      5: 'FontWeight.w600',
      6: 'FontWeight.w700',
      7: 'FontWeight.w800',
      8: 'FontWeight.w900',
    }[index]!;
  }
}

/// A feature tag and value that affect the selection of glyphs in a font.
///
/// Different fonts support different features. Consider using a tool
/// such as <https://wakamaifondue.com/> to examine your fonts to
/// determine what features are available.
///
/// {@tool sample}
/// This example shows usage of several OpenType font features,
/// including Small Caps (selected manually using the "smcp" code),
/// old-style figures, fractional ligatures, and stylistic sets.
///
/// ** See code in examples/api/lib/ui/text/font_feature.0.dart **
/// {@end-tool}
///
/// Some fonts also support continuous font variations; see the [FontVariation]
/// class.
///
/// See also:
///
///  * <https://en.wikipedia.org/wiki/List_of_typographic_features>,
///    Wikipedia's description of these typographic features.
///
///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags>,
///    Microsoft's registry of these features.
class FontFeature {
  /// Creates a [FontFeature] object, which can be added to a [TextStyle] to
  /// change how the engine selects glyphs when rendering text.
  ///
  /// `feature` is the four-character tag that identifies the feature.
  /// These tags are specified by font formats such as OpenType.
  ///
  /// `value` is the value that the feature will be set to. The behavior
  /// of the value depends on the specific feature. Many features are
  /// flags whose value can be 1 (when enabled) or 0 (when disabled).
  ///
  /// See <https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags>
  const FontFeature(this.feature, [this.value = 1])
      : assert(feature.length == 4,
            'Feature tag must be exactly four characters long.'),
        assert(value >= 0, 'Feature value must be zero or a positive integer.');

  /// Create a [FontFeature] object that enables the feature with the given tag.
  const FontFeature.enable(String feature) : this(feature, 1);

  /// Create a [FontFeature] object that disables the feature with the given tag.
  const FontFeature.disable(String feature) : this(feature, 0);

  // Features below should be alphabetic by feature tag. This makes it
  // easier to determine when a feature is missing so that we avoid
  // adding duplicates.
  //
  // The full list is extremely long, and many of the features are
  // language-specific, or indeed force-enabled for particular locales
  // by HarfBuzz, so we don't even attempt to be comprehensive here.
  // Features listed below are those we deemed "interesting enough" to
  // have their own constructor, mostly on the basis of whether we
  // could find a font where the feature had a useful effect that
  // could be demonstrated.

  // Start of feature tag list.
  // ------------------------------------------------------------------------

  /// Access alternative glyphs. (`aalt`)
  ///
  /// This feature selects the given glyph variant for glyphs in the span.
  ///
  /// {@tool sample}
  /// The Raleway font supports several alternate glyphs. The code
  /// below shows how specific glyphs can be selected. With `aalt` set
  /// to zero, the default, the normal glyphs are used. With a
  /// non-zero value, Raleway substitutes small caps for lower case
  /// letters. With value 2, the lowercase "a" changes to a stemless
  /// "a", whereas the lowercase "t" changes to a vertical bar instead
  /// of having a curve. By targeting specific letters in the text
  /// (using [widgets.Text.rich]), the desired rendering for each glyph can be
  /// achieved.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_aalt.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_alternative.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#aalt>
  const FontFeature.alternative(this.value) : feature = 'aalt';

  /// Use alternative ligatures to represent fractions. (`afrc`)
  ///
  /// When this feature is enabled (and the font supports it),
  /// sequences of digits separated by U+002F SOLIDUS character (/) or
  /// U+2044 FRACTION SLASH (⁄) are replaced by ligatures that
  /// represent the corresponding fraction. These ligatures may differ
  /// from those used by the [FontFeature.fractions] feature.
  ///
  /// This feature overrides all other features.
  ///
  /// {@tool sample}
  /// The Ubuntu Mono font supports the `afrc` feature. It causes digits
  /// before slashes to become superscripted and digits after slashes to become
  /// subscripted. This contrasts to the effect seen with [FontFeature.fractions].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_afrc.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_alternative_fractions.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.fractions], which has a similar (but different) effect.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#afrc>
  const FontFeature.alternativeFractions()
      : feature = 'afrc',
        value = 1;

  /// Enable contextual alternates. (`calt`)
  ///
  /// With this feature enabled, specific glyphs may be replaced by
  /// alternatives based on nearby text.
  ///
  /// {@tool sample}
  /// The Barriecito font supports the `calt` feature. It causes some
  /// letters in close proximity to other instances of themselves to
  /// use different glyphs, to give the appearance of more variation
  /// in the glyphs, rather than having each letter always use a
  /// particular glyph.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_calt.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_contextual_alternates.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.randomize], which is more a rarely supported but more
  ///    powerful way to get a similar effect.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#calt>
  const FontFeature.contextualAlternates()
      : feature = 'calt',
        value = 1;

  /// Enable case-sensitive forms. (`case`)
  ///
  /// Some glyphs, for example parentheses or operators, are typically
  /// designed to fit nicely with mixed case, or even predominantly
  /// lowercase, text. When these glyphs are placed near strings of
  /// capital letters, they appear a little off-center.
  ///
  /// This feature, when supported by the font, causes these glyphs to
  /// be shifted slightly, or otherwise adjusted, so as to form a more
  /// aesthetically pleasing combination with capital letters.
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `case` feature. It causes
  /// parentheses, brackets, braces, guillemets, slashes, bullets, and
  /// some other glyphs (not shown below) to be shifted up slightly so
  /// that capital letters appear centered in comparison. When the
  /// feature is disabled, those glyphs are optimized for use with
  /// lowercase letters, and so capital letters appear to ride higher
  /// relative to the punctuation marks.
  ///
  /// The difference is very subtle. It may be most obvious when
  /// examining the square brackets compared to the capital A.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_case.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_case_sensitive_forms.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#case>
  const FontFeature.caseSensitiveForms()
      : feature = 'case',
        value = 1;

  /// Select a character variant. (`cv01` through `cv99`)
  ///
  /// Fonts may have up to 99 character variant sets, numbered 1
  /// through 99, each of which can be independently enabled or
  /// disabled.
  ///
  /// Related character variants are typically grouped into stylistic
  /// sets, controlled by the [FontFeature.stylisticSet] feature
  /// (`ssXX`).
  ///
  /// {@tool sample}
  /// The Source Code Pro font supports the `cvXX` feature for several
  /// characters. In the example below, variants 1 (`cv01`), 2
  /// (`cv02`), and 4 (`cv04`) are selected. Variant 1 changes the
  /// rendering of the "a" character, variant 2 changes the lowercase
  /// "g" character, and variant 4 changes the lowercase "i" and "l"
  /// characters. There are also variants (not shown here) that
  /// control the rendering of various greek characters such as beta
  /// and theta.
  ///
  /// Notably, this can be contrasted with the stylistic sets, where
  /// the set which affects the "a" character also affects beta, and
  /// the set which affects the "g" character also affects theta and
  /// delta.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_cvXX.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_character_variant.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.stylisticSet], which allows for groups of characters
  ///    variants to be selected at once, as opposed to individual character variants.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#cv01-cv99>
  factory FontFeature.characterVariant(int value) {
    assert(value >= 1);
    assert(value <= 99);
    return FontFeature('cv${value.toString().padLeft(2, "0")}');
  }

  /// Display digits as denominators. (`dnom`)
  ///
  /// This is typically used automatically by the font rendering
  /// system as part of the implementation of `frac` for the denominator
  /// part of fractions (see [FontFeature.fractions]).
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `dnom` feature. It causes
  /// the digits to be rendered smaller and near the bottom of the EM box.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_dnom.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_denominator.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ae#dnom>
  const FontFeature.denominator()
      : feature = 'dnom',
        value = 1;

  /// Use ligatures to represent fractions. (`afrc`)
  ///
  /// When this feature is enabled (and the font supports it),
  /// sequences of digits separated by U+002F SOLIDUS character (/) or
  /// U+2044 FRACTION SLASH (⁄) are replaced by ligatures that
  /// represent the corresponding fraction.
  ///
  /// This feature may imply the [FontFeature.numerators] and
  /// [FontFeature.denominator] features.
  ///
  /// {@tool sample}
  /// The Ubuntu Mono font supports the `frac` feature. It causes
  /// digits around slashes to be turned into dedicated fraction
  /// glyphs. This contrasts to the effect seen with
  /// [FontFeature.alternativeFractions].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_frac.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_fractions.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.alternativeFractions], which has a similar (but different) effect.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_fj#frac>
  const FontFeature.fractions()
      : feature = 'frac',
        value = 1;

  /// Use historical forms. (`hist`)
  ///
  /// Some fonts have alternatives for letters whose forms have changed
  /// through the ages. In the Latin alphabet, this is common for
  /// example with the long-form "s" or the Fraktur "k". This feature enables
  /// those alternative glyphs.
  ///
  /// This does not enable legacy ligatures, only single-character alternatives.
  /// To enable historical ligatures, use [FontFeature.historicalLigatures].
  ///
  /// This feature may override other glyph-substitution features.
  ///
  /// {@tool sample}
  /// The Cardo font supports the `hist` feature specifically for the
  /// letter "s": it changes occurrences of that letter for the glyph
  /// used by U+017F LATIN SMALL LETTER LONG S.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_historical.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_historical_forms.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_fj#hist>
  const FontFeature.historicalForms()
      : feature = 'hist',
        value = 1;

  /// Use historical ligatures. (`hlig`)
  ///
  /// Some fonts support ligatures that have fallen out of favor today,
  /// but were historically in common use. This feature enables those
  /// ligatures.
  ///
  /// For example, the "long s" glyph was historically typeset with
  /// characters such as "t" and "h" as a single ligature.
  ///
  /// This does not enable the legacy forms, only ligatures. See
  /// [FontFeature.historicalForms] to enable single characters to be
  /// replaced with their historical alternatives. Combining both is
  /// usually desired since the ligatures typically apply specifically
  /// to characters that have historical forms as well. For example,
  /// the historical forms feature might replace the "s" character
  /// with the "long s" (ſ) character, while the historical ligatures
  /// feature might specifically apply to cases where "long s" is
  /// followed by other characters such as "t". In such cases, without
  /// the historical forms being enabled, the ligatures would only
  /// apply when the "long s" is used explicitly.
  ///
  /// This feature may override other glyph-substitution features.
  ///
  /// {@tool sample}
  /// The Cardo font supports the `hlig` feature. It has legacy
  /// ligatures for "VI" and "NT", and various ligatures involving the
  /// "long s". In the example below, both historical forms (`hist 1`)
  /// and historical ligatures (`hlig 1`) are enabled, so, for
  /// instance, "fish" becomes "fiſh" which is then rendered using a
  /// ligature for the last two characters.
  ///
  /// Similarly, the word "business" is turned into "buſineſſ" by
  /// `hist`, and the `ſi` and `ſſ` pairs are ligated by `hlig`.
  /// Observe in particular the position of the dot of the "i" in
  /// "business" in the various combinations of these features.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_historical.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_historical_ligatures.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_fj#hlig>
  const FontFeature.historicalLigatures()
      : feature = 'hlig',
        value = 1;

  /// Use lining figures. (`lnum`)
  ///
  /// Some fonts have digits that, like lowercase latin letters, have
  /// both descenders and ascenders. In some situations, especially in
  /// conjunction with capital letters, this leads to an aesthetically
  /// questionable irregularity. Lining figures, on the other hand,
  /// have a uniform height, and align with the baseline and the
  /// height of capital letters. Conceptually, they can be thought of
  /// as "capital digits".
  ///
  /// This feature may conflict with [FontFeature.oldstyleFigures].
  ///
  /// {@tool sample}
  /// The Sorts Mill Goudy font supports the `lnum` feature. It causes
  /// digits to fit more seamlessly with capital letters.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_lnum.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_lining_figures.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#lnum>
  const FontFeature.liningFigures()
      : feature = 'lnum',
        value = 1;

  /// Use locale-specific glyphs. (`locl`)
  ///
  /// Some characters, most notably those in the Unicode Han
  /// Unification blocks, vary in presentation based on the locale in
  /// use. For example, the ideograph for "grass" (U+8349, 草) has a
  /// broken top line in Traditional Chinese, but a solid top line in
  /// Simplified Chinese, Japanese, Korean, and Vietnamese. This kind
  /// of variation also exists with other alphabets, for example
  /// Cyrillic characters as used in the Bulgarian and Serbian
  /// alphabets vary from their Russian counterparts.
  ///
  /// A particular font may default to the forms for the locale for
  /// which it was constructed, but still support alternative forms
  /// for other locales. When this feature is enabled, the locale (as
  /// specified using [painting.TextStyle.locale], for instance) is
  /// used to determine which glyphs to use when locale-specific
  /// alternatives exist. Disabling this feature causes the font
  /// rendering to ignore locale information and only use the default
  /// glyphs.
  ///
  /// This feature is enabled by default. Using
  /// `FontFeature.localeAware(enable: false)` disables the
  /// locale-awareness. (So does not specifying the locale in the
  /// first place, of course.)
  ///
  /// {@tool sample}
  /// The Noto Sans CJK font supports the `locl` feature for CJK characters.
  /// In this example, the `localeAware` feature is not explicitly used, as it is
  /// enabled by default. This example instead shows how to set the locale,
  /// thus demonstrating how Noto Sans adapts the glyph shapes to the locale.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_locl.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_locale_aware.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#locl>
  ///  * <https://en.wikipedia.org/wiki/Han_unification>
  ///  * <https://en.wikipedia.org/wiki/Cyrillic_script>
  const FontFeature.localeAware({bool enable = true})
      : feature = 'locl',
        value = enable ? 1 : 0;

  /// Display alternative glyphs for numerals (alternate annotation forms). (`nalt`)
  ///
  /// Replaces glyphs used in numbering lists (e.g. 1, 2, 3...; or a, b, c...) with notational
  /// variants that might be more typographically interesting.
  ///
  /// Fonts sometimes support multiple alternatives, and the argument
  /// selects the set to use (a positive integer, or 0 to disable the
  /// feature). The default set if none is specified is 1.
  ///
  /// {@tool sample}
  /// The Gothic A1 font supports several notational variant sets via
  /// the `nalt` feature.
  ///
  /// Set 1 changes the spacing of the glyphs. Set 2 parenthesizes the
  /// latin letters and reduces the numerals to subscripts. Set 3
  /// circles the glyphs. Set 4 parenthesizes the digits. Set 5 uses
  /// reverse-video circles for the digits. Set 7 superscripts the
  /// digits.
  ///
  /// The code below shows how to select set 3.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_nalt.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_notational_forms.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#nalt>
  const FontFeature.notationalForms([this.value = 1])
      : feature = 'nalt',
        assert(value >= 0);

  /// Display digits as numerators. (`numr`)
  ///
  /// This is typically used automatically by the font rendering
  /// system as part of the implementation of `frac` for the numerator
  /// part of fractions (see [FontFeature.fractions]).
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `numr` feature. It causes
  /// the digits to be rendered smaller and near the top of the EM box.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_numr.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_numerators.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#numr>
  const FontFeature.numerators()
      : feature = 'numr',
        value = 1;

  /// Use old style figures. (`onum`)
  ///
  /// Some fonts have variants of the figures (e.g. the digit 9) that,
  /// when this feature is enabled, render with descenders under the
  /// baseline instead of being entirely above the baseline. If the
  /// default digits are lining figures, this allows the selection of
  /// digits that fit better with mixed case (uppercase and lowercase)
  /// text.
  ///
  /// This overrides [FontFeature.slashedZero] and may conflict with
  /// [FontFeature.liningFigures].
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `onum` feature. It causes
  /// digits to extend below the baseline.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_onum.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_oldstyle_figures.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#onum>
  ///  * <https://en.wikipedia.org/wiki/Text_figures>
  const FontFeature.oldstyleFigures()
      : feature = 'onum',
        value = 1;

  /// Use ordinal forms for alphabetic glyphs. (`ordn`)
  ///
  /// Some fonts have variants of the alphabetic glyphs intended for
  /// use after numbers when expressing ordinals, as in "1st", "2nd",
  /// "3rd". This feature enables those alternative glyphs.
  ///
  /// This may override other features that substitute glyphs.
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `ordn` feature. It causes
  /// alphabetic glyphs to become smaller and superscripted.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_ordn.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_ordinal_forms.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_ko#ordn>
  const FontFeature.ordinalForms()
      : feature = 'ordn',
        value = 1;

  /// Use proportional (varying width) figures. (`pnum`)
  ///
  /// For fonts that have both proportional and tabular (monospace) figures,
  /// this enables the proportional figures.
  ///
  /// This is mutually exclusive with [FontFeature.tabularFigures].
  ///
  /// The default behavior varies from font to font.
  ///
  /// {@tool sample}
  /// The Kufam font supports the `pnum` feature. It causes the digits
  /// to become proportionally-sized, rather than all being the same
  /// width. In this font this is especially noticeable with the digit
  /// "1": normally, the 1 has very noticeable serifs in this
  /// sans-serif font, but with the proportionally figures enabled,
  /// the digit becomes much narrower.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_pnum.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_proportional_figures.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#pnum>
  const FontFeature.proportionalFigures()
      : feature = 'pnum',
        value = 1;

  /// Randomize the alternate forms used in text. (`rand`)
  ///
  /// For example, this can be used with suitably-prepared handwriting fonts to
  /// vary the forms used for each character, so that, for instance, the word
  /// "cross-section" would be rendered with two different "c"s, two different "o"s,
  /// and three different "s"s.
  ///
  /// Contextual alternates ([FontFeature.contextualAlternates])
  /// provide a similar effect in some fonts, without using
  /// randomness.
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#rand>
  const FontFeature.randomize()
      : feature = 'rand',
        value = 1;

  /// Enable stylistic alternates. (`salt`)
  ///
  /// Some fonts have alternative forms that are not tied to a
  /// particular purpose (such as being historical forms, or
  /// contextually relevant alternatives, or ligatures, etc). This
  /// font feature enables these purely stylistic alternatives.
  ///
  /// This may override other features that substitute glyphs.
  ///
  /// {@tool sample}
  /// The Source Code Pro font supports the `salt` feature. It causes
  /// some glyphs to be rendered differently, for example the "a" and
  /// "g" glyphs change from their typographically common
  /// double-storey forms to simpler single-storey forms, the dollar
  /// sign's line changes from discontinuous to continuous (and is
  /// angled), and the "0" rendering changes from a center dot to a
  /// slash.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_salt.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_stylistic_alternates.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.contextualAlternates], which is enables alternates specific to certain contexts.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#salt>
  const FontFeature.stylisticAlternates()
      : feature = 'salt',
        value = 1;

  /// Use scientific inferiors. (`sinf`)
  ///
  /// Some fonts have variants of the figures (e.g. the digit 2) that,
  /// when this feature is enabled, render in a manner more
  /// appropriate for subscripted digits ("inferiors") used in
  /// scientific contexts, e.g. the subscripts in chemical formulae.
  ///
  /// This may override other features that substitute glyphs.
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `sinf` feature. It causes
  /// digits to be smaller and subscripted.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_sinf.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_scientific_inferiors.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#sinf>
  const FontFeature.scientificInferiors()
      : feature = 'sinf',
        value = 1;

  /// Select a stylistic set. (`ss01` through `ss20`)
  ///
  /// Fonts may have up to 20 stylistic sets, numbered 1 through 20,
  /// each of which can be independently enabled or disabled.
  ///
  /// For more fine-grained control, in some fonts individual
  /// character variants can also be controlled by the
  /// [FontFeature.characterVariant] feature (`cvXX`).
  ///
  /// {@tool sample}
  /// The Source Code Pro font supports the `ssXX` feature for several
  /// sets. In the example below, stylistic sets 2 (`ss02`), 3
  /// (`ss03`), and 4 (`ss04`) are selected. Stylistic set 2 changes
  /// the rendering of the "a" character and the beta character,
  /// stylistic set 3 changes the lowercase "g", theta, and delta
  /// characters, and stylistic set 4 changes the lowercase "i" and
  /// "l" characters.
  ///
  /// This font also supports character variants (see
  /// [FontFeature.characterVariant]).
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_ssXX_1.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_stylistic_set.0.dart **
  /// {@end-tool}
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `ssXX` feature for more
  /// elaborate stylistic effects. Set 1 turns some Latin characters
  /// into Roman numerals, set 2 enables some ASCII characters to be
  /// used to create pretty arrows, and so forth.
  ///
  /// _These_ stylistic sets do _not_ correspond to character variants.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_ssXX_2.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_stylistic_set.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [FontFeature.characterVariant], which allows for individual character
  ///    variants to be selected, as opposed to entire sets.
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#ssxx>
  factory FontFeature.stylisticSet(int value) {
    assert(value >= 1);
    assert(value <= 20);
    return FontFeature('ss${value.toString().padLeft(2, "0")}');
  }

  /// Enable subscripts. (`subs`)
  ///
  /// This feature causes some fonts to change some glyphs to their subscripted form.
  ///
  /// It typically does not affect all glyphs, and so is not appropriate for generally causing
  /// all text to be subscripted.
  ///
  /// This may override other features that substitute glyphs.
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `subs` feature. It causes
  /// digits to be smaller and subscripted.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_subs.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_subscripts.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#subs>
  ///  * [FontFeature.scientificInferiors], which is similar but intended specifically for
  ///    subscripts used in scientific contexts.
  ///  * [FontFeature.superscripts], which is similar but for subscripting.
  const FontFeature.subscripts()
      : feature = 'subs',
        value = 1;

  /// Enable superscripts. (`sups`)
  ///
  /// This feature causes some fonts to change some glyphs to their
  /// superscripted form. This may be more than just changing their
  /// position. For example, digits might change to lining figures
  /// (see [FontFeature.liningFigures]) in addition to being raised
  /// and shrunk.
  ///
  /// It typically does not affect all glyphs, and so is not
  /// appropriate for generally causing all text to be superscripted.
  ///
  /// This may override other features that substitute glyphs.
  ///
  /// {@tool sample}
  /// The Sorts Mill Goudy font supports the `sups` feature. It causes
  /// digits to be smaller, superscripted, and changes them to lining
  /// figures (so they are all the same height).
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_sups.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_superscripts.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#sups>
  ///  * [FontFeature.subscripts], which is similar but for subscripting.
  const FontFeature.superscripts()
      : feature = 'sups',
        value = 1;

  /// Enable swash glyphs. (`swsh`)
  ///
  /// Some fonts have beautiful flourishes on some characters. These
  /// come in many forms, such as exaggerated serifs, long tails, long
  /// entry strokes, or other forms of decorative extensions to the
  /// base character.
  ///
  /// This feature enables the rendering of these flourishes. Some
  /// fonts have many swashes per character; the argument, if
  /// specified, selects which swash to use (0 disables them
  /// altogether).
  ///
  /// Some fonts have an absurd number of alternative swashes. For
  /// example, Adobe's Poetica famously has 63 different ampersand
  /// forms available through this feature!
  ///
  /// {@tool sample}
  /// The BioRhyme Expanded font supports the `swsh` feature specifically
  /// for the capital "Q" and "R" glyphs and the ampersand.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_swsh.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_swash.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#swsh>
  ///  * <https://en.wikipedia.org/wiki/Swash_(typography)>
  const FontFeature.swash([this.value = 1])
      : feature = 'swsh',
        assert(value >= 0);

  /// Use tabular (monospace) figures. (`tnum`)
  ///
  /// For fonts that have both proportional (varying width) and tabular figures,
  /// this enables the tabular figures. Tabular figures are monospaced (all the
  /// same width), so that they align in tables of figures.
  ///
  /// This is mutually exclusive with [FontFeature.proportionalFigures].
  ///
  /// The default behavior varies from font to font.
  ///
  /// {@tool sample}
  /// The Piazzolla font supports the `tnum` feature. It causes the
  /// digits to become uniformly-sized, rather than having variable
  /// widths. In this font this is especially noticeable with the
  /// digit "1"; with tabular figures enabled, the "1" digit is more
  /// widely spaced.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_tnum.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_tabular_figures.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_pt#tnum>
  const FontFeature.tabularFigures()
      : feature = 'tnum',
        value = 1;

  /// Use the slashed zero. (`zero`)
  ///
  /// Some fonts contain both a circular zero and a zero with a slash. This
  /// enables the use of the latter form.
  ///
  /// This is overridden by [FontFeature.oldstyleFigures].
  ///
  /// {@tool sample}
  /// The Source Code Pro font supports the `zero` feature. It causes the
  /// zero digit to be drawn with a slash rather than the default rendering,
  /// which in this case has a dot through the zero rather than a slash.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/font_feature_zero.png)
  ///
  /// ** See code in examples/api/lib/ui/text/font_feature.font_feature_slashed_zero.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/features_uz#zero>
  const FontFeature.slashedZero()
      : feature = 'zero',
        value = 1;

  // ------------------------------------------------------------------------
  // End of feature tags list.

  /// The tag that identifies the effect of this feature.  Must consist of 4
  /// ASCII characters (typically lowercase letters).
  ///
  /// These features are defined in a registry maintained by Microsoft:
  /// <https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags>
  final String feature;

  /// The value assigned to this feature.
  ///
  /// Must be a positive integer. Many features are Boolean values that accept
  /// values of either 0 (feature is disabled) or 1 (feature is enabled). Other
  /// features have a bound range of values (which may be documented in these
  /// API docs for features that have dedicated constructors, and are generally
  /// documented in the official registry). In some cases the precise supported
  /// range depends on the font.
  ///
  /// See also:
  ///
  ///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist>
  final int value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FontFeature &&
        other.feature == feature &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(feature, value);

  @override
  String toString() => "FontFeature('$feature', $value)";
}

/// An axis tag and value that can be used to customize variable fonts.
///
/// Some fonts are variable fonts that can generate a range of different
/// font faces by altering the values of the font's design axes.
///
/// For example:
///
/// ```dart
/// const TextStyle(fontVariations: <ui.FontVariation>[ui.FontVariation('wght', 800.0)])
/// ```
///
/// Font variations are distinct from font features, as exposed by the
/// [FontFeature] class. Where features can be enabled or disabled in a discrete
/// manner, font variations provide a continuous axis of control.
///
/// See also:
///
///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxisreg#registered-axis-tags>,
///    which lists registered axis tags.
///
///  * <https://docs.microsoft.com/en-us/typography/opentype/spec/otvaroverview>,
///    an overview of the font variations technology.
class FontVariation {
  /// Creates a [FontVariation] object, which can be added to a [TextStyle] to
  /// change the variable attributes of a font.
  ///
  /// `axis` is the four-character tag that identifies the design axis.
  /// OpenType lists the [currently registered axis
  /// tags](https://docs.microsoft.com/en-us/typography/opentype/spec/dvaraxisreg).
  ///
  /// `value` is the value that the axis will be set to. The behavior
  /// depends on how the font implements the axis.
  const FontVariation(
    this.axis,
    this.value,
  )   : assert(
            axis.length == 4, 'Axis tag must be exactly four characters long.'),
        assert(value >= -32768.0 && value < 32768.0,
            'Value must be representable as a signed 16.16 fixed-point number, i.e. it must be in this range: -32768.0 ≤ value < 32768.0');

  // Constructors below should be alphabetic by axis tag. This makes it easier
  // to determine when an axis is missing so that we avoid adding duplicates.

  // Start of axis tag list.
  // ------------------------------------------------------------------------

  /// Variable font style. (`ital`)
  ///
  /// Varies the style of glyphs in the font between normal and italic.
  ///
  /// Values must in the range 0.0 (meaning normal, or Roman, as in
  /// [FontStyle.normal]) to 1.0 (meaning fully italic, as in
  /// [FontStyle.italic]).
  ///
  /// This is distinct from [FontVariation.slant], which leans the characters
  /// without changing the font style.
  ///
  /// See also:
  ///
  ///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxistag_ital>
  const FontVariation.italic(this.value)
      : assert(value >= 0.0),
        assert(value <= 1.0),
        axis = 'ital';

  /// Optical size optimization. (`opzs`)
  ///
  /// Changes the rendering of the font to be optimized for the given text size.
  /// Normally, the optical size of the font will be derived from the font size.
  ///
  /// This feature could be used when the text represents a particular physical
  /// font size, for example text in the representation of a hardcopy magazine,
  /// which does not correspond to the actual font size being used to render the
  /// text. By setting the optical size explicitly, font variations that might
  /// be applied as the text is zoomed will be fixed at the size being
  /// represented by the text.
  ///
  /// This feature could also be used to smooth animations. If a font varies its
  /// rendering as the font size is adjusted, it may appear to "quiver" (or, one
  /// might even say, "flutter") if the font size is animated. By setting a
  /// fixed optical size, the rendering can be fixed to one particular style as
  /// the text size animates.
  ///
  /// Values must be greater than zero, and are interpreted as points. A point
  /// is 1/72 of an inch, or 1.333 logical pixels (96/72).
  ///
  /// See also:
  ///
  ///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxistag_opsz>
  const FontVariation.opticalSize(this.value)
      : assert(value > 0.0),
        axis = 'opsz';

  /// Variable font width. (`slnt`)
  ///
  /// Varies the slant of glyphs in the font.
  ///
  /// Values must be greater than -90.0 and less than +90.0, and represents the
  /// angle in _counter-clockwise_ degrees relative to "normal", at 0.0.
  ///
  /// For example, to lean the glyphs forward by 45 degrees, one would use
  /// `FontVariation.slant(-45.0)`.
  ///
  /// This is distinct from [FontVariation.italic], in that slant leans the
  /// characters without changing the font style.
  ///
  /// See also:
  ///
  ///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxistag_slnt>
  const FontVariation.slant(this.value)
      : assert(value > -90.0),
        assert(value < 90.0),
        axis = 'slnt';

  /// Variable font width. (`wdth`)
  ///
  /// Varies the width of glyphs in the font.
  ///
  /// Values must be greater than zero, with no upper limit. 100.0 represents
  /// the "normal" width. Smaller values are "condensed", greater values are
  /// "extended".
  ///
  /// See also:
  ///
  ///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxistag_wdth>
  const FontVariation.width(this.value)
      : assert(value >= 0.0),
        axis = 'wdth';

  /// Variable font weight. (`wght`)
  ///
  /// Varies the stroke thickness of the font, similar to [FontWeight] but on a
  /// continuous axis.
  ///
  /// Values must be in the range 1..1000, and are to be interpreted in a manner
  /// consistent with the values of [FontWeight]. For instance, `400` is the
  /// "normal" weight, and `700` is "bold".
  ///
  /// See also:
  ///
  ///  * <https://learn.microsoft.com/en-us/typography/opentype/spec/dvaraxistag_wght>
  const FontVariation.weight(this.value)
      : assert(value >= 1),
        assert(value <= 1000),
        axis = 'wght';

  // ------------------------------------------------------------------------
  // End of axis tags list.

  /// The tag that identifies the design axis.
  ///
  /// An axis tag must consist of 4 ASCII characters.
  final String axis;

  /// The value assigned to this design axis.
  ///
  /// The range of usable values depends on the specification of the axis.
  ///
  /// While this property is represented as a [double] in this API
  /// ([binary64](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)),
  /// fonts use the fixed-point 16.16 format to represent the value of font
  /// variations. This means that the actual range is -32768.0 to approximately
  /// 32767.999985 and in principle the smallest increment between two values is
  /// approximately 0.000015 (1/65536).
  ///
  /// Unfortunately for technical reasons the value is first converted to the
  /// [binary32 floating point
  /// format](https://en.wikipedia.org/wiki/Single-precision_floating-point_format),
  /// which only has 24 bits of precision. This means that for values outside
  /// the range -256.0 to 256.0, the smallest increment is larger than what is
  /// technically supported by OpenType. At the extreme edge of the range, the
  /// smallest increment is only approximately ±0.002.
  final double value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FontVariation && other.axis == axis && other.value == value;
  }

  @override
  int get hashCode => Object.hash(axis, value);

  /// Linearly interpolates between two font variations.
  ///
  /// If the two variations have different axis tags, the interpolation switches
  /// abruptly from one to the other at t=0.5. Otherwise, the value is
  /// interpolated (see [lerpDouble].
  ///
  /// The value is not clamped to the valid values of the axis tag, but it is
  /// clamped to the valid range of font variations values in general (the range
  /// of signed 16.16 fixed point numbers).
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static FontVariation? lerp(FontVariation? a, FontVariation? b, double t) {
    if (a?.axis != b?.axis || (a == null && b == null)) {
      return t < 0.5 ? a : b;
    }
    return FontVariation(
      a!.axis,
      clampDouble(
          lerpDouble(a.value, b!.value, t), -32768.0, 32768.0 - 1.0 / 65536.0),
    );
  }

  @override
  String toString() => "FontVariation('$axis', $value)";
}

/// A linear decoration to draw near the text.
class TextDecoration {
  const TextDecoration._(this._mask);

  /// Creates a decoration that paints the union of all the given decorations.
  factory TextDecoration.combine(List<TextDecoration> decorations) {
    int mask = 0;
    for (final TextDecoration decoration in decorations) {
      mask |= decoration._mask;
    }
    return TextDecoration._(mask);
  }

  final int _mask;

  /// Whether this decoration will paint at least as much decoration as the given decoration.
  bool contains(TextDecoration other) {
    return (_mask | other._mask) == _mask;
  }

  /// Do not draw a decoration
  static const TextDecoration none = TextDecoration._(0x0);

  /// Draw a line underneath each line of text
  static const TextDecoration underline = TextDecoration._(0x1);

  /// Draw a line above each line of text
  static const TextDecoration overline = TextDecoration._(0x2);

  /// Draw a line through each line of text
  static const TextDecoration lineThrough = TextDecoration._(0x4);

  @override
  bool operator ==(Object other) {
    return other is TextDecoration && other._mask == _mask;
  }

  @override
  int get hashCode => _mask.hashCode;

  @override
  String toString() {
    if (_mask == 0) {
      return 'TextDecoration.none';
    }
    final List<String> values = <String>[];
    if (_mask & underline._mask != 0) {
      values.add('underline');
    }
    if (_mask & overline._mask != 0) {
      values.add('overline');
    }
    if (_mask & lineThrough._mask != 0) {
      values.add('lineThrough');
    }
    if (values.length == 1) {
      return 'TextDecoration.${values[0]}';
    }
    return 'TextDecoration.combine([${values.join(", ")}])';
  }
}

/// The style in which to draw a text decoration
enum TextDecorationStyle {
  /// Draw a solid line
  solid,

  /// Draw two lines
  double,

  /// Draw a dotted line
  dotted,

  /// Draw a dashed line
  dashed,

  /// Draw a sinusoidal line
  wavy
}

/// {@macro dart.ui.textLeadingDistribution}
enum TextLeadingDistribution {
  /// Distributes the [leading](https://en.wikipedia.org/wiki/Leading)
  /// of the text proportionally above and below the text, to the font's
  /// ascent/descent ratio.
  ///
  /// {@template dart.ui.leading}
  /// The leading of a text run is defined as
  /// `TextStyle.height * TextStyle.fontSize - TextStyle.fontSize`. When
  /// [TextStyle.height] is not set, the text run uses the leading specified by
  /// the font instead.
  /// {@endtemplate}
  proportional,

  /// Distributes the ["leading"](https://en.wikipedia.org/wiki/Leading)
  /// of the text evenly above and below the text (i.e. evenly above the
  /// font's ascender and below the descender).
  ///
  /// {@macro dart.ui.leading}
  ///
  /// The leading can become negative when [TextStyle.height] is smaller than
  /// 1.0.
  ///
  /// This is the default strategy used by CSS, known as
  /// ["half-leading"](https://www.w3.org/TR/css-inline-3/#half-leading).
  even,
}

/// {@template dart.ui.textHeightBehavior}
/// Defines how to apply [TextStyle.height] over and under text.
///
/// [TextHeightBehavior.applyHeightToFirstAscent] and
/// [TextHeightBehavior.applyHeightToLastDescent] represent whether the
/// [TextStyle.height] modifier will be applied to the corresponding metric. By
/// default both properties are true, and [TextStyle.height] is applied as
/// normal. When set to false, the font's default ascent will be used.
///
/// [TextHeightBehavior.leadingDistribution] determines how the
/// leading is distributed over and under text. This
/// property applies before [TextHeightBehavior.applyHeightToFirstAscent] and
/// [TextHeightBehavior.applyHeightToLastDescent].
///
/// {@endtemplate}
class TextHeightBehavior {
  /// Creates a new TextHeightBehavior object.
  ///
  ///  * applyHeightToFirstAscent: When true, the [TextStyle.height] modifier
  ///    will be applied to the ascent of the first line. When false, the font's
  ///    default ascent will be used.
  ///  * applyHeightToLastDescent: When true, the [TextStyle.height] modifier
  ///    will be applied to the descent of the last line. When false, the font's
  ///    default descent will be used.
  ///  * leadingDistribution: How the leading is distributed over and under
  ///    text.
  ///
  /// All properties default to true (height modifications applied as normal).
  const TextHeightBehavior({
    this.applyHeightToFirstAscent = true,
    this.applyHeightToLastDescent = true,
    this.leadingDistribution = TextLeadingDistribution.proportional,
  });

  /// Creates a new TextHeightBehavior object from an encoded form.
  ///
  /// See [_encode] for the creation of the encoded form.
  const TextHeightBehavior._fromEncoded(int encoded, this.leadingDistribution)
      : applyHeightToFirstAscent = (encoded & 0x1) == 0,
        applyHeightToLastDescent = (encoded & 0x2) == 0;

  /// Whether to apply the [TextStyle.height] modifier to the ascent of the first
  /// line in the paragraph.
  ///
  /// When true, the [TextStyle.height] modifier will be applied to the ascent
  /// of the first line. When false, the font's default ascent will be used and
  /// the [TextStyle.height] will have no effect on the ascent of the first line.
  ///
  /// This property only has effect if a non-null [TextStyle.height] is specified.
  ///
  /// Defaults to true (height modifications applied as normal).
  final bool applyHeightToFirstAscent;

  /// Whether to apply the [TextStyle.height] modifier to the descent of the last
  /// line in the paragraph.
  ///
  /// When true, the [TextStyle.height] modifier will be applied to the descent
  /// of the last line. When false, the font's default descent will be used and
  /// the [TextStyle.height] will have no effect on the descent of the last line.
  ///
  /// This property only has effect if a non-null [TextStyle.height] is specified.
  ///
  /// Defaults to true (height modifications applied as normal).
  final bool applyHeightToLastDescent;

  /// {@template dart.ui.textLeadingDistribution}
  /// How the ["leading"](https://en.wikipedia.org/wiki/Leading) is distributed
  /// over and under the text.
  ///
  /// Does not affect layout when [TextStyle.height] is not specified. The
  /// leading can become negative, for example, when [TextLeadingDistribution.even]
  /// is used with a [TextStyle.height] much smaller than 1.0.
  /// {@endtemplate}
  ///
  /// Defaults to [TextLeadingDistribution.proportional],
  final TextLeadingDistribution leadingDistribution;

  /// Returns an encoded int representation of this object (excluding
  /// [leadingDistribution]).
  int _encode() {
    return (applyHeightToFirstAscent ? 0 : 1 << 0) |
        (applyHeightToLastDescent ? 0 : 1 << 1);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TextHeightBehavior &&
        other.applyHeightToFirstAscent == applyHeightToFirstAscent &&
        other.applyHeightToLastDescent == applyHeightToLastDescent &&
        other.leadingDistribution == leadingDistribution;
  }

  @override
  int get hashCode {
    return Object.hash(
      applyHeightToFirstAscent,
      applyHeightToLastDescent,
      leadingDistribution.index,
    );
  }

  @override
  String toString() {
    return 'TextHeightBehavior('
        'applyHeightToFirstAscent: $applyHeightToFirstAscent, '
        'applyHeightToLastDescent: $applyHeightToLastDescent, '
        'leadingDistribution: $leadingDistribution'
        ')';
  }
}

/// Determines if lists [a] and [b] are deep equivalent.
///
/// Returns true if the lists are both null, or if they are both non-null, have
/// the same length, and contain the same elements in the same order. Returns
/// false otherwise.
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}

// This encoding must match the C++ version of ParagraphBuilder::pushStyle.
//
// The encoded array buffer has 8 elements.
//
//  - Element 0: A bit field where the ith bit indicates whether the ith element
//    has a non-null value. Bits 8 to 12 indicate whether |fontFamily|,
//    |fontSize|, |letterSpacing|, |wordSpacing|, and |height| are non-null,
//    respectively. Bit 0 indicates the [TextLeadingDistribution] of the text
//    style.
//
//  - Element 1: The |color| in ARGB with 8 bits per channel.
//
//  - Element 2: A bit field indicating which text decorations are present in
//    the |textDecoration| list. The ith bit is set if there's a TextDecoration
//    with enum index i in the list.
//
//  - Element 3: The |decorationColor| in ARGB with 8 bits per channel.
//
//  - Element 4: The bit field of the |decorationStyle|.
//
//  - Element 5: The index of the |fontWeight|.
//
//  - Element 6: The enum index of the |fontStyle|.
//
//  - Element 7: The enum index of the |textBaseline|.
//
Int32List _encodeTextStyle(
  Color? color,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  TextBaseline? textBaseline,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  double? fontSize,
  double? letterSpacing,
  double? wordSpacing,
  double? height,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
) {
  final Int32List result = Int32List(9);
  // The 0th bit of result[0] is reserved for leadingDistribution.

  if (color != null) {
    result[0] |= 1 << 1;
    result[1] = color.value;
  }
  if (decoration != null) {
    result[0] |= 1 << 2;
    result[2] = decoration._mask;
  }
  if (decorationColor != null) {
    result[0] |= 1 << 3;
    result[3] = decorationColor.value;
  }
  if (decorationStyle != null) {
    result[0] |= 1 << 4;
    result[4] = decorationStyle.index;
  }
  if (fontWeight != null) {
    result[0] |= 1 << 5;
    result[5] = fontWeight.index;
  }
  if (fontStyle != null) {
    result[0] |= 1 << 6;
    result[6] = fontStyle.index;
  }
  if (textBaseline != null) {
    result[0] |= 1 << 7;
    result[7] = textBaseline.index;
  }
  if (decorationThickness != null) {
    result[0] |= 1 << 8;
  }
  if (fontFamily != null ||
      (fontFamilyFallback != null && fontFamilyFallback.isNotEmpty)) {
    result[0] |= 1 << 9;
    // Passed separately to native.
  }
  if (fontSize != null) {
    result[0] |= 1 << 10;
    // Passed separately to native.
  }
  if (letterSpacing != null) {
    result[0] |= 1 << 11;
    // Passed separately to native.
  }
  if (wordSpacing != null) {
    result[0] |= 1 << 12;
    // Passed separately to native.
  }
  if (height != null) {
    result[0] |= 1 << 13;
    // Passed separately to native.
  }
  if (fontFeatures != null) {
    result[0] |= 1 << 18;
    // Passed separately to native.
  }
  if (fontVariations != null) {
    result[0] |= 1 << 19;
    // Passed separately to native.
  }

  return result;
}

// This encoding must match the C++ version ParagraphBuilder::build.
//
// The encoded array buffer has 6 elements.
//
//  - Element 0: A bit mask indicating which fields are non-null.
//    Bit 0 is unused. Bits 1-n are set if the corresponding index in the
//    encoded array is non-null.  The remaining bits represent fields that
//    are passed separately from the array.
//
//  - Element 1: The enum index of the |textAlign|.
//
//  - Element 2: The enum index of the |textDirection|.
//
//  - Element 3: The index of the |fontWeight|.
//
//  - Element 4: The enum index of the |fontStyle|.
//
//  - Element 5: The value of |maxLines|.
//
//  - Element 6: The encoded value of |textHeightBehavior|, except its leading
//    distribution.
Int32List _encodeParagraphStyle(
  TextAlign? textAlign,
  TextDirection? textDirection,
  int? maxLines,
  String? fontFamily,
  double? fontSize,
  double? height,
  TextHeightBehavior? textHeightBehavior,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  StrutStyle? strutStyle,
  String? ellipsis,
) {
  final Int32List result = Int32List(7); // also update paragraph_builder.cc
  if (textAlign != null) {
    result[0] |= 1 << 1;
    result[1] = textAlign.index;
  }
  if (textDirection != null) {
    result[0] |= 1 << 2;
    result[2] = textDirection.index;
  }
  if (fontWeight != null) {
    result[0] |= 1 << 3;
    result[3] = fontWeight.index;
  }
  if (fontStyle != null) {
    result[0] |= 1 << 4;
    result[4] = fontStyle.index;
  }
  if (maxLines != null) {
    result[0] |= 1 << 5;
    result[5] = maxLines;
  }
  if (textHeightBehavior != null) {
    result[0] |= 1 << 6;
    result[6] = textHeightBehavior._encode();
  }
  if (fontFamily != null) {
    result[0] |= 1 << 7;
    // Passed separately to native.
  }
  if (fontSize != null) {
    result[0] |= 1 << 8;
    // Passed separately to native.
  }
  if (height != null) {
    result[0] |= 1 << 9;
    // Passed separately to native.
  }
  if (strutStyle != null) {
    result[0] |= 1 << 10;
    // Passed separately to native.
  }
  if (ellipsis != null) {
    result[0] |= 1 << 11;
    // Passed separately to native.
  }
  return result;
}

/// An opaque object that determines the configuration used by
/// [ParagraphBuilder] to position lines within a [Paragraph] of text.
class ParagraphStyle {
  /// Creates a new ParagraphStyle object.
  ///
  /// * `textAlign`: The alignment of the text within the lines of the
  ///   paragraph. If the last line is ellipsized (see `ellipsis` below), the
  ///   alignment is applied to that line after it has been truncated but before
  ///   the ellipsis has been added.
  ///   See: https://github.com/flutter/flutter/issues/9819
  ///
  /// * `textDirection`: The directionality of the text, left-to-right (e.g.
  ///   Norwegian) or right-to-left (e.g. Hebrew). This controls the overall
  ///   directionality of the paragraph, as well as the meaning of
  ///   [TextAlign.start] and [TextAlign.end] in the `textAlign` field.
  ///
  /// * `maxLines`: The maximum number of lines painted. Lines beyond this
  ///   number are silently dropped. For example, if `maxLines` is 1, then only
  ///   one line is rendered. If `maxLines` is null, but `ellipsis` is not null,
  ///   then lines after the first one that overflows the width constraints are
  ///   dropped. The width constraints are those set in the
  ///   [ParagraphConstraints] object passed to the [Paragraph.layout] method.
  ///
  /// * `fontFamily`: The name of the font family to apply when painting the text,
  ///   in the absence of a `textStyle` being attached to the span.
  ///
  /// * `fontSize`: The fallback size of glyphs (in logical pixels) to
  ///   use when painting the text. This is used when there is no [TextStyle].
  ///
  /// * `height`: The fallback height of the spans as a multiplier of the font
  ///   size. The fallback height is used when no height is provided through
  ///   [TextStyle.height]. Omitting `height` here and in [TextStyle] will allow
  ///   the line height to take the height as defined by the font, which may not
  ///   be exactly the height of the `fontSize`.
  ///
  /// * `textHeightBehavior`: Specifies how the `height` multiplier is
  ///   applied to ascent of the first line and the descent of the last line.
  ///
  /// * `leadingDistribution`: Specifies how the extra vertical space added by
  ///   the `height` multiplier should be distributed over and under the text.
  ///   Defaults to [TextLeadingDistribution.proportional].
  ///
  /// * `fontWeight`: The typeface thickness to use when painting the text
  ///   (e.g., bold).
  ///
  /// * `fontStyle`: The typeface variant to use when drawing the letters (e.g.,
  ///   italics).
  ///
  /// * `strutStyle`: The properties of the strut. Strut defines a set of minimum
  ///   vertical line height related metrics and can be used to obtain more
  ///   advanced line spacing behavior.
  ///
  /// * `ellipsis`: String used to ellipsize overflowing text. If `maxLines` is
  ///   not null, then the `ellipsis`, if any, is applied to the last rendered
  ///   line, if that line overflows the width constraints. If `maxLines` is
  ///   null, then the `ellipsis` is applied to the first line that overflows
  ///   the width constraints, and subsequent lines are dropped. The width
  ///   constraints are those set in the [ParagraphConstraints] object passed to
  ///   the [Paragraph.layout] method. The empty string and the null value are
  ///   considered equivalent and turn off this behavior.
  ///
  /// * `locale`: The locale used to select region-specific glyphs.
  ParagraphStyle({
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    String? fontFamily,
    double? fontSize,
    double? height,
    TextHeightBehavior? textHeightBehavior,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    StrutStyle? strutStyle,
    String? ellipsis,
  })  : _encoded = _encodeParagraphStyle(
          textAlign,
          textDirection,
          maxLines,
          fontFamily,
          fontSize,
          height,
          textHeightBehavior,
          fontWeight,
          fontStyle,
          strutStyle,
          ellipsis,
        ),
        _fontFamily = fontFamily,
        _fontSize = fontSize,
        _height = height,
        _strutStyle = strutStyle,
        _ellipsis = ellipsis,
        _leadingDistribution = textHeightBehavior?.leadingDistribution ??
            TextLeadingDistribution.proportional;

  final Int32List _encoded;
  final String? _fontFamily;
  final double? _fontSize;
  final double? _height;
  final StrutStyle? _strutStyle;
  final String? _ellipsis;
  final TextLeadingDistribution _leadingDistribution;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ParagraphStyle &&
        other._fontFamily == _fontFamily &&
        other._fontSize == _fontSize &&
        other._height == _height &&
        other._strutStyle == _strutStyle &&
        other._ellipsis == _ellipsis &&
        other._leadingDistribution == _leadingDistribution &&
        _listEquals<int>(other._encoded, _encoded);
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(_encoded), _fontFamily,
      _fontSize, _height, _ellipsis, _leadingDistribution);

  @override
  String toString() {
    return 'ParagraphStyle('
        'textAlign: ${_encoded[0] & 0x002 == 0x002 ? TextAlign.values[_encoded[1]] : "unspecified"}, '
        'textDirection: ${_encoded[0] & 0x004 == 0x004 ? TextDirection.values[_encoded[2]] : "unspecified"}, '
        'fontWeight: ${_encoded[0] & 0x008 == 0x008 ? FontWeight.values[_encoded[3]] : "unspecified"}, '
        'fontStyle: ${_encoded[0] & 0x010 == 0x010 ? FontStyle.values[_encoded[4]] : "unspecified"}, '
        'maxLines: ${_encoded[0] & 0x020 == 0x020 ? _encoded[5] : "unspecified"}, '
        'textHeightBehavior: ${_encoded[0] & 0x040 == 0x040 ? TextHeightBehavior._fromEncoded(_encoded[6], _leadingDistribution).toString() : "unspecified"}, '
        'fontFamily: ${_encoded[0] & 0x080 == 0x080 ? _fontFamily : "unspecified"}, '
        'fontSize: ${_encoded[0] & 0x100 == 0x100 ? _fontSize : "unspecified"}, '
        'height: ${_encoded[0] & 0x200 == 0x200 ? "${_height}x" : "unspecified"}, '
        'strutStyle: ${_encoded[0] & 0x400 == 0x400 ? _strutStyle : "unspecified"}, '
        'ellipsis: ${_encoded[0] & 0x800 == 0x800 ? '"$_ellipsis"' : "unspecified"}, '
        ')';
  }
}

// Serialize strut properties into ByteData. This encoding errs towards
// compactness. The first 8 bits is a bitmask that records which properties are
// null. The rest of the values are encoded in the same order encountered in the
// bitmask. The final returned value truncates any unused bytes at the end. For
// ease of decoding, all 8 bit integers are stored before any 32 bit integers.
//
// We serialize this more thoroughly than ParagraphStyle because it is
// much more likely that the strut is empty/null and we wish to add
// minimal overhead for non-strut cases.
ByteData _encodeStrut(
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    double? leading,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool? forceStrutHeight) {
  if (fontFamily == null &&
      fontSize == null &&
      height == null &&
      leadingDistribution == null &&
      leading == null &&
      fontWeight == null &&
      fontStyle == null &&
      forceStrutHeight == null) {
    return ByteData(0);
  }

  final ByteData data = ByteData(16); // Max size is 16 bytes
  int bitmask = 0; // 8 bit mask
  int byteCount = 1;
  if (fontWeight != null) {
    bitmask |= 1 << 0;
    data.setInt8(byteCount, fontWeight.index);
    byteCount += 1;
  }
  if (fontStyle != null) {
    bitmask |= 1 << 1;
    data.setInt8(byteCount, fontStyle.index);
    byteCount += 1;
  }
  if (fontFamily != null ||
      (fontFamilyFallback != null && fontFamilyFallback.isNotEmpty)) {
    bitmask |= 1 << 2;
    // passed separately to native
  }

  // The 3rd bit (0-indexed) is reserved for leadingDistribution.

  if (fontSize != null) {
    bitmask |= 1 << 4;
    data.setFloat32(byteCount, fontSize, _kFakeHostEndian);
    byteCount += 4;
  }
  if (height != null) {
    bitmask |= 1 << 5;
    data.setFloat32(byteCount, height, _kFakeHostEndian);
    byteCount += 4;
  }
  if (leading != null) {
    bitmask |= 1 << 6;
    data.setFloat32(byteCount, leading, _kFakeHostEndian);
    byteCount += 4;
  }
  if (forceStrutHeight ?? false) {
    bitmask |= 1 << 7;
  }

  data.setInt8(0, bitmask);

  assert(byteCount <= 16);
  assert(bitmask >> 8 == 0, 'strut bitmask overflow: $bitmask');
  return ByteData.view(data.buffer, 0, byteCount);
}

/// See also:
///
///  * [StrutStyle](https://api.flutter.dev/flutter/painting/StrutStyle-class.html), the class in the [painting] library.
///
class StrutStyle {
  /// Creates a new StrutStyle object.
  ///
  /// * `fontFamily`: The name of the font to use when painting the text (e.g.,
  ///   Roboto).
  ///
  /// * `fontFamilyFallback`: An ordered list of font family names that will be
  ///    searched for when the font in `fontFamily` cannot be found.
  ///
  /// * `fontSize`: The size of glyphs (in logical pixels) to use when painting
  ///   the text.
  ///
  /// * `height`: The minimum height of the line boxes, as a multiplier of the
  ///   font size. The lines of the paragraph will be at least
  ///   `(height + leading) * fontSize` tall when `fontSize` is not null. Omitting
  ///   `height` will allow the minimum line height to take the height as defined
  ///   by the font, which may not be exactly the height of the `fontSize`. When
  ///   `fontSize` is null, there is no minimum line height. Tall glyphs due to
  ///   baseline alignment or large [TextStyle.fontSize] may cause the actual line
  ///   height after layout to be taller than specified here. The `fontSize` must
  ///   be provided for this property to take effect.
  ///
  /// * `leading`: The minimum amount of leading between lines as a multiple of
  ///   the font size. `fontSize` must be provided for this property to take
  ///   effect. The leading added by this property is distributed evenly over
  ///   and under the text, regardless of `leadingDistribution`.
  ///
  /// * `leadingDistribution`: how the extra vertical space added by the
  ///   `height` multiplier should be distributed over and under the text,
  ///   independent of `leading` (which is always distributed evenly over and
  ///   under text). Defaults to the paragraph's [TextHeightBehavior]'s leading
  ///   distribution.
  ///
  /// * `fontWeight`: The typeface thickness to use when painting the text
  ///   (e.g., bold).
  ///
  /// * `fontStyle`: The typeface variant to use when drawing the letters (e.g.,
  ///   italics).
  ///
  /// * `forceStrutHeight`: When true, the paragraph will force all lines to be exactly
  ///   `(height + leading) * fontSize` tall from baseline to baseline.
  ///   [TextStyle] is no longer able to influence the line height, and any tall
  ///   glyphs may overlap with lines above. If a `fontFamily` is specified, the
  ///   total ascent of the first line will be the min of the `Ascent + half-leading`
  ///   of the `fontFamily` and `(height + leading) * fontSize`. Otherwise, it
  ///   will be determined by the Ascent + half-leading of the first text.
  StrutStyle({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    double? leading,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool? forceStrutHeight,
  })  : _encoded = _encodeStrut(
          fontFamily,
          fontFamilyFallback,
          fontSize,
          height,
          leadingDistribution,
          leading,
          fontWeight,
          fontStyle,
          forceStrutHeight,
        ),
        _leadingDistribution = leadingDistribution,
        _fontFamily = fontFamily,
        _fontFamilyFallback = fontFamilyFallback;

  final ByteData _encoded; // Most of the data for strut is encoded.
  final String? _fontFamily;
  final List<String>? _fontFamilyFallback;
  final TextLeadingDistribution? _leadingDistribution;

  bool get _enabled => _encoded.lengthInBytes > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StrutStyle &&
        other._fontFamily == _fontFamily &&
        other._leadingDistribution == _leadingDistribution &&
        _listEquals<String>(other._fontFamilyFallback, _fontFamilyFallback) &&
        _listEquals<int>(
            other._encoded.buffer.asInt8List(), _encoded.buffer.asInt8List());
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(_encoded.buffer.asInt8List()),
      _fontFamily, _leadingDistribution);
}

/// A rectangle enclosing a run of text.
///
/// This is similar to [Rect] but includes an inherent [TextDirection].
class TextBox {
  /// Creates an object that describes a box containing text.
  const TextBox.fromLTRBD(
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.direction,
  );

  /// The left edge of the text box, irrespective of direction.
  ///
  /// To get the leading edge (which may depend on the [direction]), consider [start].
  final double left;

  /// The top edge of the text box.
  final double top;

  /// The right edge of the text box, irrespective of direction.
  ///
  /// To get the trailing edge (which may depend on the [direction]), consider [end].
  final double right;

  /// The bottom edge of the text box.
  final double bottom;

  /// The direction in which text inside this box flows.
  final TextDirection direction;

  /// Returns a rect of the same size as this box.
  Rect toRect() => Rect.fromLTRB(left, top, right, bottom);

  /// The [left] edge of the box for left-to-right text; the [right] edge of the box for right-to-left text.
  ///
  /// See also:
  ///
  ///  * [direction], which specifies the text direction.
  double get start {
    return (direction == TextDirection.ltr) ? left : right;
  }

  /// The [right] edge of the box for left-to-right text; the [left] edge of the box for right-to-left text.
  ///
  /// See also:
  ///
  ///  * [direction], which specifies the text direction.
  double get end {
    return (direction == TextDirection.ltr) ? right : left;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TextBox &&
        other.left == left &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom &&
        other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(left, top, right, bottom, direction);

  @override
  String toString() =>
      'TextBox.fromLTRBD(${left.toStringAsFixed(1)}, ${top.toStringAsFixed(1)}, ${right.toStringAsFixed(1)}, ${bottom.toStringAsFixed(1)}, $direction)';
}

/// A way to disambiguate a [TextPosition] when its offset could match two
/// different locations in the rendered string.
///
/// For example, at an offset where the rendered text wraps, there are two
/// visual positions that the offset could represent: one prior to the line
/// break (at the end of the first line) and one after the line break (at the
/// start of the second line). A text affinity disambiguates between these two
/// cases.
///
/// This affects only line breaks caused by wrapping, not explicit newline
/// characters. For newline characters, the position is fully specified by the
/// offset alone, and there is no ambiguity.
///
/// [TextAffinity] also affects bidirectional text at the interface between LTR
/// and RTL text. Consider the following string, where the lowercase letters
/// will be displayed as LTR and the uppercase letters RTL: "helloHELLO".  When
/// rendered, the string would appear visually as "helloOLLEH".  An offset of 5
/// would be ambiguous without a corresponding [TextAffinity].  Looking at the
/// string in code, the offset represents the position just after the "o" and
/// just before the "H".  When rendered, this offset could be either in the
/// middle of the string to the right of the "o" or at the end of the string to
/// the right of the "H".
enum TextAffinity {
  /// The position has affinity for the upstream side of the text position, i.e.
  /// in the direction of the beginning of the string.
  ///
  /// In the example of an offset at the place where text is wrapping, upstream
  /// indicates the end of the first line.
  ///
  /// In the bidirectional text example "helloHELLO", an offset of 5 with
  /// [TextAffinity] upstream would appear in the middle of the rendered text,
  /// just to the right of the "o". See the definition of [TextAffinity] for the
  /// full example.
  upstream,

  /// The position has affinity for the downstream side of the text position,
  /// i.e. in the direction of the end of the string.
  ///
  /// In the example of an offset at the place where text is wrapping,
  /// downstream indicates the beginning of the second line.
  ///
  /// In the bidirectional text example "helloHELLO", an offset of 5 with
  /// [TextAffinity] downstream would appear at the end of the rendered text,
  /// just to the right of the "H". See the definition of [TextAffinity] for the
  /// full example.
  downstream,
}

/// A position in a string of text.
///
/// A TextPosition can be used to describe a caret position in between
/// characters. The [offset] points to the position between `offset - 1` and
/// `offset` characters of the string, and the [affinity] is used to describe
/// which character this position affiliates with.
///
/// One use case is when rendered text is forced to wrap. In this case, the offset
/// where the wrap occurs could visually appear either at the end of the first
/// line or the beginning of the second line. The second way is with
/// bidirectional text.  An offset at the interface between two different text
/// directions could have one of two locations in the rendered text.
///
/// See the documentation for [TextAffinity] for more information on how
/// TextAffinity disambiguates situations like these.
class TextPosition {
  /// Creates an object representing a particular position in a string.
  ///
  /// The arguments must not be null (so the [offset] argument is required).
  const TextPosition({
    required this.offset,
    this.affinity = TextAffinity.downstream,
  });

  /// The index of the character that immediately follows the position in the
  /// string representation of the text.
  ///
  /// For example, given the string `'Hello'`, offset 0 represents the cursor
  /// being before the `H`, while offset 5 represents the cursor being just
  /// after the `o`.
  final int offset;

  /// Disambiguates cases where the position in the string given by [offset]
  /// could represent two different visual positions in the rendered text. For
  /// example, this can happen when text is forced to wrap, or when one string
  /// of text is rendered with multiple text directions.
  ///
  /// See the documentation for [TextAffinity] for more information on how
  /// TextAffinity disambiguates situations like these.
  final TextAffinity affinity;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TextPosition &&
        other.offset == offset &&
        other.affinity == affinity;
  }

  @override
  int get hashCode => Object.hash(offset, affinity);

  @override
  String toString() {
    return 'TextPosition(offset: $offset, affinity: $affinity)';
  }
}

/// A range of characters in a string of text.
class TextRange {
  /// Creates a text range.
  ///
  /// The [start] and [end] arguments must not be null. Both the [start] and
  /// [end] must either be greater than or equal to zero or both exactly -1.
  ///
  /// The text included in the range includes the character at [start], but not
  /// the one at [end].
  ///
  /// Instead of creating an empty text range, consider using the [empty]
  /// constant.
  const TextRange({
    required this.start,
    required this.end,
  })  : assert(start >= -1),
        assert(end >= -1);

  /// A text range that starts and ends at offset.
  ///
  /// The [offset] argument must be non-null and greater than or equal to -1.
  const TextRange.collapsed(int offset)
      : assert(offset >= -1),
        start = offset,
        end = offset;

  /// A text range that contains nothing and is not in the text.
  static const TextRange empty = TextRange(start: -1, end: -1);

  /// The index of the first character in the range.
  ///
  /// If [start] and [end] are both -1, the text range is empty.
  final int start;

  /// The next index after the characters in this range.
  ///
  /// If [start] and [end] are both -1, the text range is empty.
  final int end;

  /// Whether this range represents a valid position in the text.
  bool get isValid => start >= 0 && end >= 0;

  /// Whether this range is empty (but still potentially placed inside the text).
  bool get isCollapsed => start == end;

  /// Whether the start of this range precedes the end.
  bool get isNormalized => end >= start;

  /// The text before this range.
  String textBefore(String text) {
    assert(isNormalized);
    return text.substring(0, start);
  }

  /// The text after this range.
  String textAfter(String text) {
    assert(isNormalized);
    return text.substring(end);
  }

  /// The text inside this range.
  String textInside(String text) {
    assert(isNormalized);
    return text.substring(start, end);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TextRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(
        start.hashCode,
        end.hashCode,
      );

  @override
  String toString() => 'TextRange(start: $start, end: $end)';
}

/// Layout constraints for [Paragraph] objects.
///
/// Instances of this class are typically used with [Paragraph.layout].
///
/// The only constraint that can be specified is the [width]. See the discussion
/// at [width] for more details.
class ParagraphConstraints {
  /// Creates constraints for laying out a paragraph.
  ///
  /// The [width] argument must not be null.
  const ParagraphConstraints({
    required this.width,
  });

  /// The width the paragraph should use whey computing the positions of glyphs.
  ///
  /// If possible, the paragraph will select a soft line break prior to reaching
  /// this width. If no soft line break is available, the paragraph will select
  /// a hard line break prior to reaching this width. If that would force a line
  /// break without any characters having been placed (i.e. if the next
  /// character to be laid out does not fit within the given width constraint)
  /// then the next character is allowed to overflow the width constraint and a
  /// forced line break is placed after it (even if an explicit line break
  /// follows).
  ///
  /// The width influences how ellipses are applied. See the discussion at
  /// [ParagraphStyle.new] for more details.
  ///
  /// This width is also used to position glyphs according to the [TextAlign]
  /// alignment described in the [ParagraphStyle] used when building the
  /// [Paragraph] with a [ParagraphBuilder].
  final double width;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ParagraphConstraints && other.width == width;
  }

  @override
  int get hashCode => width.hashCode;

  @override
  String toString() => 'ParagraphConstraints(width: $width)';
}

/// Defines various ways to vertically bound the boxes returned by
/// [Paragraph.getBoxesForRange].
///
/// See [BoxWidthStyle] for a similar property to control width.
enum BoxHeightStyle {
  /// Provide tight bounding boxes that fit heights per run. This style may result
  /// in uneven bounding boxes that do not nicely connect with adjacent boxes.
  tight,

  /// The height of the boxes will be the maximum height of all runs in the
  /// line. All boxes in the same line will be the same height.
  ///
  /// This does not guarantee that the boxes will cover the entire vertical height of the line
  /// when there is additional line spacing.
  ///
  /// See [BoxHeightStyle.includeLineSpacingTop], [BoxHeightStyle.includeLineSpacingMiddle],
  /// and [BoxHeightStyle.includeLineSpacingBottom] for styles that will cover
  /// the entire line.
  max,

  /// Extends the top and bottom edge of the bounds to fully cover any line
  /// spacing.
  ///
  /// The top and bottom of each box will cover half of the
  /// space above and half of the space below the line.
  ///
  /// {@template dart.ui.boxHeightStyle.includeLineSpacing}
  /// The top edge of each line should be the same as the bottom edge
  /// of the line above. There should be no gaps in vertical coverage given any
  /// amount of line spacing. Line spacing is not included above the first line
  /// and below the last line due to no additional space present there.
  /// {@endtemplate}
  includeLineSpacingMiddle,

  /// Extends the top edge of the bounds to fully cover any line spacing.
  ///
  /// The line spacing will be added to the top of the box.
  ///
  /// {@macro dart.ui.boxHeightStyle.includeLineSpacing}
  includeLineSpacingTop,

  /// Extends the bottom edge of the bounds to fully cover any line spacing.
  ///
  /// The line spacing will be added to the bottom of the box.
  ///
  /// {@macro dart.ui.boxHeightStyle.includeLineSpacing}
  includeLineSpacingBottom,

  /// Calculate box heights based on the metrics of this paragraph's [StrutStyle].
  ///
  /// Boxes based on the strut will have consistent heights throughout the
  /// entire paragraph.  The top edge of each line will align with the bottom
  /// edge of the previous line.  It is possible for glyphs to extend outside
  /// these boxes.
  strut,
}

/// Defines various ways to horizontally bound the boxes returned by
/// [Paragraph.getBoxesForRange].
///
/// See [BoxHeightStyle] for a similar property to control height.
enum BoxWidthStyle {
  /// Provide tight bounding boxes that fit widths to the runs of each line
  /// independently.
  tight,

  /// Adds up to two additional boxes as needed at the beginning and/or end
  /// of each line so that the widths of the boxes in line are the same width
  /// as the widest line in the paragraph.
  ///
  /// The additional boxes on each line are only added when the relevant box
  /// at the relevant edge of that line does not span the maximum width of
  /// the paragraph.
  max,
}

/// Where to vertically align the placeholder relative to the surrounding text.
///
/// Used by [ParagraphBuilder.addPlaceholder].
enum PlaceholderAlignment {
  /// Match the baseline of the placeholder with the baseline.
  ///
  /// The [TextBaseline] to use must be specified and non-null when using this
  /// alignment mode.
  baseline,

  /// Align the bottom edge of the placeholder with the baseline such that the
  /// placeholder sits on top of the baseline.
  ///
  /// The [TextBaseline] to use must be specified and non-null when using this
  /// alignment mode.
  aboveBaseline,

  /// Align the top edge of the placeholder with the baseline specified
  /// such that the placeholder hangs below the baseline.
  ///
  /// The [TextBaseline] to use must be specified and non-null when using this
  /// alignment mode.
  belowBaseline,

  /// Align the top edge of the placeholder with the top edge of the text.
  ///
  /// When the placeholder is very tall, the extra space will hang from
  /// the top and extend through the bottom of the line.
  top,

  /// Align the bottom edge of the placeholder with the bottom edge of the text.
  ///
  /// When the placeholder is very tall, the extra space will rise from the
  /// bottom and extend through the top of the line.
  bottom,

  /// Align the middle of the placeholder with the middle of the text.
  ///
  /// When the placeholder is very tall, the extra space will grow equally
  /// from the top and bottom of the line.
  middle,
}

/// [LineMetrics] stores the measurements and statistics of a single line in the
/// paragraph.
///
/// The measurements here are for the line as a whole, and represent the maximum
/// extent of the line instead of per-run or per-glyph metrics. For more detailed
/// metrics, see [TextBox] and [Paragraph.getBoxesForRange].
///
/// [LineMetrics] should be obtained directly from the [Paragraph.computeLineMetrics]
/// method.
class LineMetrics {
  /// Creates a [LineMetrics] object with only the specified values.
  LineMetrics({
    required this.hardBreak,
    required this.ascent,
    required this.descent,
    required this.unscaledAscent,
    required this.height,
    required this.width,
    required this.left,
    required this.baseline,
    required this.lineNumber,
  });

  /// True if this line ends with an explicit line break (e.g. '\n') or is the end
  /// of the paragraph. False otherwise.
  final bool hardBreak;

  /// The rise from the [baseline] as calculated from the font and style for this line.
  ///
  /// This is the final computed ascent and can be impacted by the strut, height, scaling,
  /// as well as outlying runs that are very tall.
  ///
  /// The [ascent] is provided as a positive value, even though it is typically defined
  /// in fonts as negative. This is to ensure the signage of operations with these
  /// metrics directly reflects the intended signage of the value. For example,
  /// the y coordinate of the top edge of the line is `baseline - ascent`.
  final double ascent;

  /// The drop from the [baseline] as calculated from the font and style for this line.
  ///
  /// This is the final computed ascent and can be impacted by the strut, height, scaling,
  /// as well as outlying runs that are very tall.
  ///
  /// The y coordinate of the bottom edge of the line is `baseline + descent`.
  final double descent;

  /// The rise from the [baseline] as calculated from the font and style for this line
  /// ignoring the [TextStyle.height].
  ///
  /// The [unscaledAscent] is provided as a positive value, even though it is typically
  /// defined in fonts as negative. This is to ensure the signage of operations with
  /// these metrics directly reflects the intended signage of the value.
  final double unscaledAscent;

  /// Total height of the line from the top edge to the bottom edge.
  ///
  /// This is equivalent to `round(ascent + descent)`. This value is provided
  /// separately due to rounding causing sub-pixel differences from the unrounded
  /// values.
  final double height;

  /// Width of the line from the left edge of the leftmost glyph to the right
  /// edge of the rightmost glyph.
  ///
  /// This is not the same as the width of the pargraph.
  ///
  /// See also:
  ///
  ///  * [Paragraph.width], the max width passed in during layout.
  ///  * [Paragraph.longestLine], the width of the longest line in the paragraph.
  final double width;

  /// The x coordinate of left edge of the line.
  ///
  /// The right edge can be obtained with `left + width`.
  final double left;

  /// The y coordinate of the baseline for this line from the top of the paragraph.
  ///
  /// The bottom edge of the paragraph up to and including this line may be obtained
  /// through `baseline + descent`.
  final double baseline;

  /// The number of this line in the overall paragraph, with the first line being
  /// index zero.
  ///
  /// For example, the first line is line 0, second line is line 1.
  final int lineNumber;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LineMetrics &&
        other.hardBreak == hardBreak &&
        other.ascent == ascent &&
        other.descent == descent &&
        other.unscaledAscent == unscaledAscent &&
        other.height == height &&
        other.width == width &&
        other.left == left &&
        other.baseline == baseline &&
        other.lineNumber == lineNumber;
  }

  @override
  int get hashCode => Object.hash(hardBreak, ascent, descent, unscaledAscent,
      height, width, left, baseline, lineNumber);

  @override
  String toString() {
    return 'LineMetrics(hardBreak: $hardBreak, '
        'ascent: $ascent, '
        'descent: $descent, '
        'unscaledAscent: $unscaledAscent, '
        'height: $height, '
        'width: $width, '
        'left: $left, '
        'baseline: $baseline, '
        'lineNumber: $lineNumber)';
  }
}
