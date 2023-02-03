import 'package:flutter/material.dart';

extension Crim on String? {
  String? crim() {
    if (this == null || this!.trim().isEmpty) {
      return null;
    } else {
      return this;
    }
  }
}

extension Typee on String {
  String get types => split('-').first;
  String get type => split('-').last;
}

extension BoxDeco on BoxDecoration {
  BoxDecoration card(ColorScheme scheme) => copyWith(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // BoxShadow(
          //   color: scheme.onSurface.withOpacity(0.1),
          //   blurRadius: 8,
          //   offset: const Offset(0, 4),
          // ),
        ],
      );
}
