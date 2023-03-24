import 'package:appwrite/models.dart';
import 'package:english/cores/models/call_request.dart';
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

extension OnCallRequests on List<CallRequest> {
  List<CallRequest> get pending => where(
        (element) =>
            !element.connected &&
            element.createdAt.isAfter(
              DateTime.now().subtract(
                const Duration(minutes: 2),
              ),
            ),
      ).toList();

  bool get hasPending => pending.isNotEmpty;

  CallRequest? get joineReady => where((element) =>
          element.connected &&
          element.token != null &&
          element.createdAt.isAfter(
            DateTime.now().subtract(
              const Duration(minutes: 3),
            ),
          ) && !element.joined)
      .cast<CallRequest?>()
      .firstWhere((element) => element != null, orElse: () => null);
}
