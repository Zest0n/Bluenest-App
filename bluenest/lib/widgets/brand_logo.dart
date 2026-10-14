import 'package:flutter/material.dart';

/// All BlueNest logo variants in one place.
class BrandLogo {
  static const _full = 'assets/images/logo_full.png'; // square, blue bg, dove + wordmark
  static const _white = 'assets/images/logo_white.png'; // white on transparent lockup
  static const _mark = 'assets/images/logo_mark.png'; // dove only, blue square tile

  /// White lockup (dove + BLUENEST + HOUSING SOLUTIONS) for dark / photo backgrounds.
  static Widget white({double? width, double? height}) =>
      Image.asset(_white, width: width, height: height, fit: BoxFit.contain);

  /// Small dove tile for app bars, auth header, etc.
  static Widget mark({double size = 40, double? radius}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? size * 0.25),
        child: Image.asset(_mark, width: size, height: size, fit: BoxFit.cover),
      );

  /// Full square logo (splash-style use).
  static Widget full({double size = 160, double? radius}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? size * 0.12),
        child: Image.asset(_full, width: size, height: size, fit: BoxFit.cover),
      );
}
