import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../cores/models/profile.dart';
import '../../../cores/providers/loading_provider.dart';
import '../../../cores/repositories/repository_provider.dart';
import '../../auth/providers/user_provider.dart';

final writeProfileNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => WriteProfileNotifier(ref));

class WriteProfileNotifier extends ChangeNotifier {
  final Ref _ref;

  WriteProfileNotifier(this._ref);

  Profile? initial;

  static const List<String> options = [
    "Working Professional",
    "Student",
    "Homemaker",
    "Business Owner",
  ];

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String _whatsapp = '';
  String get whatsapp => _whatsapp;
  set whatsapp(String whatsapp) {
    _whatsapp = whatsapp;
    notifyListeners();
  }

  String _profession = '';
  String get profession => _profession;
  set profession(String profession) {
    _profession = profession;
    if(options.contains(profession)){
      _other = false;
    }
    notifyListeners();
  }

  bool _other = false;
  bool get other => _other;
  set other(bool other) {
    _other = other;
    _profession = '';
    notifyListeners();
  }

  String _purpose = '';
  String get purpose => _purpose;
  set purpose(String purpose) {
    _purpose = purpose;
    notifyListeners();
  }

  void init(Profile profile) {
    if (initial == null) {
      initial = profile;
      _phone = profile.phone;
      _whatsapp = profile.whatsapp;
      _profession = profile.profession;
      _purpose = profile.purpose;
      _other = !options.contains(profession);
    }
  }

  bool get enabled =>
      _phone.isNotEmpty &&
      _whatsapp.isNotEmpty &&
      _profession.isNotEmpty &&
      _purpose.isNotEmpty;

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void clear() {
    initial = null;
  }

  Repository get _repository => _ref.read(repositoryProvider);

  Loading get _loading => _ref.read(loadingProvider);

  Future<void> write({bool skip = false}) async {
    _loading.start();
    final user = _ref.read(userProvider).value!;
    final updated = (initial ?? Profile.empty()).copyWith(
      name: user.name,
      email: user.email,
      id: user.$id,
      phone: phone,
      whatsapp: whatsapp,
      profession: profession,
      purpose: purpose,
    );
    try {
      await _repository.writeProfile(updated, file: skip ? null : file);
      _loading.end();
    } catch (e) {
      _loading.stop();
      return Future.error(e is FirebaseException ? e.message ?? e : e);
    }
  }
}
