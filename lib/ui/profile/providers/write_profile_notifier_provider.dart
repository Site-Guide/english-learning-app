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

  Profile profile = Profile();

  static const List<String> options = [
    "Working Professional",
    "Student",
    "Homemaker",
    "Business Owner",
  ];



  void init(Profile profile) {
    this.profile = profile;
  }


  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void clear() {
    profile = Profile();
  }

  void setAreYou(String value){
    profile.profession = value;
    _other = false;
    notifyListeners();
  }
  

  bool _other = false;
  bool get other => _other;
  set other(bool value) {
    _other = value;
    profile.profession = "";
    notifyListeners();
  }

  Repository get _repository => _ref.read(repositoryProvider);

  Loading get _loading => _ref.read(loadingProvider);

  Future<void> write({bool skip = false}) async {
    _loading.start();
    final user = _ref.read(userProvider).value!;
    final updated = profile.copyWith(
      name: user.name,
      email: user.email,
      id: user.$id,
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
