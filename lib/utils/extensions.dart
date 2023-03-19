import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension Crim on String? {
  String? crim() {
    if (this == null || this!.trim().isEmpty) {
      return null;
    } else {
      return this;
    }
  }
}

extension IntNull on int {
  int? get crim => this == 0 ? null : this;
  String get asRupee => '₹$this';
}

extension Typee on String {
  String get types => split('-').first;
  String get type => split('-').last;
}

extension Date on DateTime {
  String get date => DateFormat('dd-MM-yyyy').format(this);
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

extension OnDuration on Duration {
  String get data {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    final seconds = inSeconds - hours * 3600 - minutes * 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get format {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    final seconds = inSeconds - hours * 3600 - minutes * 60;
    return '${hours != 0 ? "${hours.toString().padLeft(2, '0')} hours" : ""}${minutes != 0 ? " ${minutes.toString().padLeft(2, '0')} minutes" : ''} ${seconds != 0 ? " ${seconds.toString().padLeft(2, '0')} seconds" : ''}'
        .trim();
  }
}
