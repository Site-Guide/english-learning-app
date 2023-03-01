import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_schemes.g.dart';
import 'custom_color.g.dart';

class Themes {
  static TextTheme base = ThemeData.light(useMaterial3: true).textTheme;

  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
        extensions: [darkCustomColors],
        // cardColor: Colors.black,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        colorScheme: darkColorScheme,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: const CardTheme(clipBehavior: Clip.antiAlias),
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
        ),
        textTheme: base
            .copyWith(
              displayMedium: const TextStyle(fontWeight: FontWeight.bold),
              headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
              titleLarge: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
            .apply(
              displayColor: darkColorScheme.onSurface,
              bodyColor: darkColorScheme.onSurface,
            )
            .copyWith(
              bodySmall:
                  TextStyle(color: darkColorScheme.onSurface.withOpacity(0.75)),
            ),
      );
}
