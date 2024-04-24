// ignore_for_file: constant_identifier_names

import 'package:swap/src/basic_types/basic_types.dart';
import 'package:swap/src/widgets/swap.dart';
import 'package:vector_math/vector_math_64.dart';

class ArgumentEncoders {
  const ArgumentEncoders._();

  /// This is a workaround for https://github.com/dart-lang/sdk/issues/47021
  // ignore: unused_field
  static const ArgumentEncoders __ = ArgumentEncoders._();

  static dynamic v<T>(T value) {
    if (value is String) return value;
    if (value is double) return value;
    if (value is int) return value;
    throw Exception('Unsupported type: ${value?.runtimeType}');
  }

  static dynamic color(Color value) {
    return v<int>(value.value);
  }

  static dynamic duration(Duration value) {
    return v<int>(value.inMilliseconds);
  }

  static dynamic textStyle(TextStyle value) {
    return {
      if (value.color case final v?) 'color': color(v),
      if (value.fontFamily case final o?) 'fontFamily': v(o),
      if (value.fontSize case final o?) 'fontSize': v(o),
      if (value.fontStyle case final o?) 'fontStyle': enumValue(o),
      if (value.fontWeight case final o?) 'fontWeight': enumValue(o),
      if (value.letterSpacing case final o?) 'letterSpacing': v(o),
      if (value.wordSpacing case final o?) 'wordSpacing': v(o),
      if (value.height case final o?) 'height': v(o),
      if (value.decoration case final o?) 'decoration': enumValue(o),
      if (value.decorationColor case final o?) 'decorationColor': color(o),
      if (value.decorationStyle case final o?) 'decorationStyle': enumValue(o),
      if (value.decorationThickness case final o?) 'decorationThickness': v(o),
      if (value.fontFamilyFallback case final o?)
        'fontFamilyFallback': [
          for (var oo in o) v(oo),
        ],
      if (value.overflow case final o?) 'overflow': enumValue(o),
    };
  }

  static dynamic curve(Curve value) {
    switch (value) {
      case Curves.bounceIn:
        return 'bounceIn';
      case Curves.bounceInOut:
        return 'bounceInOut';
      case Curves.bounceOut:
        return 'bounceOut';
      case Curves.decelerate:
        return 'decelerate';
      case Curves.ease:
        return 'ease';
      case Curves.easeIn:
        return 'easeIn';
      case Curves.easeInBack:
        return 'easeInBack';
      case Curves.easeInCirc:
        return 'easeInCirc';
      case Curves.easeInCubic:
        return 'easeInCubic';
      case Curves.easeInExpo:
        return 'easeInExpo';
      case Curves.easeInOut:
        return 'easeInOut';
      case Curves.easeInOutBack:
        return 'easeInOutBack';
      case Curves.easeInOutCirc:
        return 'easeInOutCirc';
      case Curves.easeInOutCubic:
        return 'easeInOutCubic';
      case Curves.easeInOutExpo:
        return 'easeInOutExpo';
      case Curves.easeInOutQuad:
        return 'easeInOutQuad';
      case Curves.easeInOutQuart:
        return 'easeInOutQuart';
      case Curves.easeInOutQuint:
        return 'easeInOutQuint';
      case Curves.easeInOutSine:
        return 'easeInOutSine';
      case Curves.easeInQuad:
        return 'easeInQuad';
      case Curves.easeInQuart:
        return 'easeInQuart';
      case Curves.easeInQuint:
        return 'easeInQuint';
      case Curves.easeInSine:
        return 'easeInSine';
      case Curves.easeInToLinear:
        return 'easeInToLinear';
      case Curves.easeOut:
        return 'easeOut';
      case Curves.easeOutBack:
        return 'easeOutBack';
      case Curves.easeOutCirc:
        return 'easeOutCirc';
      case Curves.easeOutCubic:
        return 'easeOutCubic';
      case Curves.easeOutExpo:
        return 'easeOutExpo';
      case Curves.easeOutQuad:
        return 'easeOutQuad';
      case Curves.easeOutQuart:
        return 'easeOutQuart';
      case Curves.easeOutQuint:
        return 'easeOutQuint';
      case Curves.easeOutSine:
        return 'easeOutSine';
      case Curves.elasticIn:
        return 'elasticIn';
      case Curves.elasticInOut:
        return 'elasticInOut';
      case Curves.elasticOut:
        return 'elasticOut';
      case Curves.fastLinearToSlowEaseIn:
        return 'fastLinearToSlowEaseIn';
      case Curves.fastOutSlowIn:
        return 'fastOutSlowIn';
      case Curves.linear:
        return 'linear';
      case Curves.linearToEaseOut:
        return 'linearToEaseOut';
      case Curves.slowMiddle:
        return 'slowMiddle';
      default:
        return null;
    }
  }

  static dynamic edgeInsets(EdgeInsetsGeometry value) {
    final resolved = value.resolve(TextDirection.ltr);
    return [
      resolved.left,
      resolved.top,
      resolved.right,
      resolved.bottom,
    ];
  }

  static dynamic decoration(Decoration value) {
    if (value is BoxDecoration) {
      return {
        'type': 'box',
        if (value.color case final v?) 'color': color(v),
        if (value.image case final v?) 'image': decorationImage(v),
        if (value.borderRadius case final v?) 'borderRadius': borderRadius(v),
        if (value.border case final v?) 'border': border(v),
        if (value.boxShadow case final v?)
          'boxShadow': [
            for (var o in v) boxShadow(o),
          ],
        if (value.gradient case final v?) 'gradient': gradient(v),
        if (value.backgroundBlendMode case final v?)
          'backgroundBlendMode': enumValue(v),
        if (value.shape != BoxShape.rectangle) 'shape': enumValue(value.shape),
      };
    }
    return null;
  }

  static dynamic borderRadius(BorderRadiusGeometry value) {
    if (value is BorderRadiusDirectional) {
      return [
        radius(value.topStart),
        radius(value.topEnd),
        radius(value.bottomStart),
        radius(value.bottomEnd),
      ];
    }

    if (value is BorderRadius) {
      return [
        radius(value.topLeft),
        radius(value.topRight),
        radius(value.bottomLeft),
        radius(value.bottomRight),
      ];
    }

    return null;
  }

  static dynamic radius(Radius value) {
    return {
      'x': v(value.x),
      'y': v(value.y),
    };
  }

  static dynamic border(BoxBorder value) {
    if (value is Border) {
      return [
        borderSide(value.left),
        borderSide(value.top),
        borderSide(value.right),
        borderSide(value.bottom),
      ];
    }
    return null;
  }

  static dynamic borderSide(BorderSide value) {
    return {
      'color': color(value.color),
      'width': v(value.width),
      if (value.style != BorderStyle.solid) 'style': enumValue(value.style),
    };
  }

  static dynamic boxShadow(BoxShadow value) {
    return {
      if (value.color case final v?) 'color': color(v),
      if (value.offset case final v?) 'offset': offset(v),
      if (value.blurRadius case final o?) 'blurRadius': v(o),
      'spreadRadius': v(value.spreadRadius),
    };
  }

  static dynamic offset(Offset value) {
    return {
      'x': value.dx,
      'y': value.dy,
    };
  }

  static dynamic rect(Rect value) {
    return {
      'x': value.left,
      'y': value.top,
      'w': value.width,
      'h': value.height,
    };
  }

  static dynamic gradient(Gradient value) {
    if (value is LinearGradient) {
      return {
        'type': 'linear',
        'begin': alignment(value.begin),
        'end': alignment(value.end),
        if (value.tileMode != TileMode.clamp)
          'tileMode': enumValue(value.tileMode),
        'colors': [
          for (var v in value.colors) color(v),
        ],
        if (value.stops case final stops?)
          'stops': [
            for (var v in stops) v,
          ]
      };
    }
  }

  static dynamic decorationImage(DecorationImage value) {}

  static dynamic matrix(Matrix4 value) {
    return [
      for (var i = 0; i < 16; i++) v(value.storage[i]),
    ];
  }

  static dynamic alignment(AlignmentGeometry value) {
    if (value is AlignmentDirectional) {
      return {
        'start': value.start,
        'y': value.y,
      };
    }

    if (value is Alignment) {
      return {
        'x': value.x,
        'y': value.y,
      };
    }

    return null;
  }

  static dynamic boxConstraints(BoxConstraints value) {
    return {
      if (value.minWidth != 0) 'minWidth': v(value.minWidth),
      if (value.maxWidth != double.infinity) 'maxWidth': v(value.maxWidth),
      if (value.minHeight != 0) 'minHeight': v(value.minHeight),
      if (value.maxHeight != double.infinity) 'maxHeight': v(value.maxHeight),
    };
  }

  static dynamic textHeightBehavior(TextHeightBehavior value) {
    return {
      if (value.applyHeightToFirstAscent case false)
        'applyHeightToFirstAscent': false,
      if (value.applyHeightToLastDescent case false)
        'applyHeightToLastDescent': false,
      if (value.leadingDistribution != TextLeadingDistribution.proportional)
        'leadingDistribution': enumValue(value.leadingDistribution),
    };
  }

  static dynamic imageProvider(ImageProvider value) {
    if (value is AssetImage) {
      return {
        'source': value.name,
        if (value.package case final o?) 'package': o,
      };
    }

    if (value is NetworkImage) {
      return {
        'source': value.src,
        if (value.scale != 1.0) 'scale': value.scale,
        if (value.headers case final o?) 'headers': o,
      };
    }

    return null;
  }

  static dynamic iconData(IconData value) {
    return {
      'icon': value.codePoint,
      if (value.fontFamily != 'MaterialIcons') 'fontFamily': value.fontFamily,
      if (value.fontPackage != null) 'fontPackage': value.fontPackage,
      if (value.matchTextDirection)
        'matchTextDirection': value.matchTextDirection,
    };
  }

  static dynamic enumValue<T>(T value) {
    return value.toString().split('.').last;
  }

  static dynamic swapNotification(SwapNotification notification) {
    return switch (notification) {
      SwapSwapNotification(
        slotId: final slotId,
        newChild: final newChild,
      ) =>
        {
          'type': 'swap',
          'slotId': slotId,
          'newChild': newChild.createRenderObject().encode(),
        },
      FetchSwapNotification(
        slotId: final slotId,
        method: final method,
        path: final path,
        body: final body,
      ) =>
        {
          'type': 'fetch',
          'slotId': slotId,
          'method': method,
          'path': path,
          if (body case final o?) 'body': o,
        },
      ResetSwapNotification(
        slotId: final slotId,
      ) =>
        {
          'type': 'reset',
          'slotId': slotId,
        },
      SetFormDataSwapNotification(
        key: final key,
        value: final value,
      ) =>
        {
          'type': 'setFormData',
          'key': key,
          'value': value,
        },
      CustomSwapNotification(
        identifier: final identifier,
        data: final data,
      ) =>
        {
          'type': 'custom',
          'identifier': identifier,
          'data': data,
        },
    };
  }
}
