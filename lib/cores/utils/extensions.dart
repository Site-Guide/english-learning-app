import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

extension OnUser on Account {
  String get initial => name.initial;
}

extension OnString on String {
  String get initial {
    final chars = split(' ')
        .where((element) => element.isNotEmpty)
        .map((e) => e.characters.first)
        .join();

    return chars.length > 2 ? "${chars[0]}${chars[2]}" : chars;
  }
}
