import 'package:flutter/material.dart';

const green = Color(0xFF4CAF50);
const orange = Color(0xFFFF9800);
const red = Color(0xFFF44336);


CustomColors lightCustomColors = const CustomColors(
  sourceGreen: Color(0xFF4CAF50),
  green: Color(0xFF006E1C),
  onGreen: Color(0xFFFFFFFF),
  greenContainer: Color(0xFF94F990),
  onGreenContainer: Color(0xFF002204),
  sourceOrange: Color(0xFFFF9800),
  orange: Color(0xFF8B5000),
  onOrange: Color(0xFFFFFFFF),
  orangeContainer: Color(0xFFFFDCBE),
  onOrangeContainer: Color(0xFF2C1600),
  sourceRed: Color(0xFFF44336),
  red: Color(0xFFBB1614),
  onRed: Color(0xFFFFFFFF),
  redContainer: Color(0xFFFFDAD5),
  onRedContainer: Color(0xFF410001),
);

CustomColors darkCustomColors = const CustomColors(
  sourceGreen: Color(0xFF4CAF50),
  green: Color(0xFF78DC77),
  onGreen: Color(0xFF00390A),
  greenContainer: Color(0xFF005313),
  onGreenContainer: Color(0xFF94F990),
  sourceOrange: Color(0xFFFF9800),
  orange: Color(0xFFFFB870),
  onOrange: Color(0xFF4A2800),
  orangeContainer: Color(0xFF693C00),
  onOrangeContainer: Color(0xFFFFDCBE),
  sourceRed: Color(0xFFF44336),
  red: Color(0xFFFFB4A9),
  onRed: Color(0xFF690002),
  redContainer: Color(0xFF930005),
  onRedContainer: Color(0xFFFFDAD5),
);



/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceGreen,
    required this.green,
    required this.onGreen,
    required this.greenContainer,
    required this.onGreenContainer,
    required this.sourceOrange,
    required this.orange,
    required this.onOrange,
    required this.orangeContainer,
    required this.onOrangeContainer,
    required this.sourceRed,
    required this.red,
    required this.onRed,
    required this.redContainer,
    required this.onRedContainer,
  });

  final Color? sourceGreen;
  final Color? green;
  final Color? onGreen;
  final Color? greenContainer;
  final Color? onGreenContainer;
  final Color? sourceOrange;
  final Color? orange;
  final Color? onOrange;
  final Color? orangeContainer;
  final Color? onOrangeContainer;
  final Color? sourceRed;
  final Color? red;
  final Color? onRed;
  final Color? redContainer;
  final Color? onRedContainer;

  @override
  CustomColors copyWith({
    Color? sourceGreen,
    Color? green,
    Color? onGreen,
    Color? greenContainer,
    Color? onGreenContainer,
    Color? sourceOrange,
    Color? orange,
    Color? onOrange,
    Color? orangeContainer,
    Color? onOrangeContainer,
    Color? sourceRed,
    Color? red,
    Color? onRed,
    Color? redContainer,
    Color? onRedContainer,
  }) {
    return CustomColors(
      sourceGreen: sourceGreen ?? this.sourceGreen,
      green: green ?? this.green,
      onGreen: onGreen ?? this.onGreen,
      greenContainer: greenContainer ?? this.greenContainer,
      onGreenContainer: onGreenContainer ?? this.onGreenContainer,
      sourceOrange: sourceOrange ?? this.sourceOrange,
      orange: orange ?? this.orange,
      onOrange: onOrange ?? this.onOrange,
      orangeContainer: orangeContainer ?? this.orangeContainer,
      onOrangeContainer: onOrangeContainer ?? this.onOrangeContainer,
      sourceRed: sourceRed ?? this.sourceRed,
      red: red ?? this.red,
      onRed: onRed ?? this.onRed,
      redContainer: redContainer ?? this.redContainer,
      onRedContainer: onRedContainer ?? this.onRedContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceGreen: Color.lerp(sourceGreen, other.sourceGreen, t),
      green: Color.lerp(green, other.green, t),
      onGreen: Color.lerp(onGreen, other.onGreen, t),
      greenContainer: Color.lerp(greenContainer, other.greenContainer, t),
      onGreenContainer: Color.lerp(onGreenContainer, other.onGreenContainer, t),
      sourceOrange: Color.lerp(sourceOrange, other.sourceOrange, t),
      orange: Color.lerp(orange, other.orange, t),
      onOrange: Color.lerp(onOrange, other.onOrange, t),
      orangeContainer: Color.lerp(orangeContainer, other.orangeContainer, t),
      onOrangeContainer: Color.lerp(onOrangeContainer, other.onOrangeContainer, t),
      sourceRed: Color.lerp(sourceRed, other.sourceRed, t),
      red: Color.lerp(red, other.red, t),
      onRed: Color.lerp(onRed, other.onRed, t),
      redContainer: Color.lerp(redContainer, other.redContainer, t),
      onRedContainer: Color.lerp(onRedContainer, other.onRedContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
}