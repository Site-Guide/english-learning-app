import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:english/cores/enums/level.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/material.dart';

class MasterData {
  final List<Timing> slots;
  final int version;
  final bool force;
  final Map<Level, int> levelToMinMark;

  MasterData({
    required this.slots,
    required this.force,
    required this.version,
    required this.levelToMinMark,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'slots': slots.map((x) => '${x.start.label}-${x.end.label}').toList(),

  //   };
  // }

  bool get now => activeSlots.where((element) => element.now).isNotEmpty;

  List<Timing> get activeSlots {
    slots.sort((a, b) => a.start.hour.compareTo(b.start.hour));

    return slots
        .where((element) => DateTime.now()
            .copyWith(
              hour: element.end.hour,
              minute: element.end.minute,
            )
            .isAfter(DateTime.now()))
        .toList();
  }

  factory MasterData.fromMap(Document doc) {
    final map = doc.data;
    return MasterData(
      slots: List<Timing>.from(
        (map['slots'] as List<dynamic>?)?.cast<String>().map((x) => Timing(
                  start: Formats.parseTime(x.split('-').first),
                  end: Formats.parseTime(x.split('-').last),
                )) ??
            [],
      ),
      force: map['force'] ?? false,
      version: map['version'] ?? 0,
      levelToMinMark: Map<Level, int>.from(
        (json.decode(map['levelToMinMark']))?.map(
              (key, value) => MapEntry(
                  Level.values.firstWhere((element) => element.name == key),
                  value),
            ) ??
            {},
      ),
    );
  }
}

class Timing {
  final TimeOfDay start;
  final TimeOfDay end;
  Timing({
    required this.start,
    required this.end,
  });

  bool get now =>
      DateTime.now()
          .copyWith(
            hour: start.hour,
            minute: start.minute,
          )
          .isBefore(DateTime.now()) &&
      DateTime.now()
          .copyWith(
            hour: end.hour,
            minute: end.minute,
          )
          .isAfter(DateTime.now());
}
