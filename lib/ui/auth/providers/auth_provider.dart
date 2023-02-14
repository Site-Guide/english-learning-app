// ignore_for_file: unused_result

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/providers/client_provider.dart';
import '../../../cores/providers/loading_provider.dart';
import 'user_provider.dart';

final authProvider = ChangeNotifierProvider((ref) => Auth(ref));

class Auth extends ChangeNotifier {
  final Ref _ref;
  Auth(this._ref);

  Loading get _loading => _ref.read(loadingProvider);

  Account get _auth => Account(_ref.read(clientProvider));

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _name = "";
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassord = '';
  String get confirmPassord => _confirmPassord;
  set confirmPassord(String confirmPassord) {
    _confirmPassord = confirmPassord;
    notifyListeners();
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmPassword) {
    _obscureConfirmPassword = obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> login() async {
    _loading.start();
    try {
      await _auth.createEmailSession(
        email: email,
        password: password,
      );
      await _ref.refresh(userProvider.future);
      _loading.end();
    } on AppwriteException catch (e) {
      print(e.code);
      _loading.stop();
      return Future.error(e.message ?? "${e.code}");
    } catch (e) {
      _loading.stop();
      debugPrint("$e");
    }
  }

  Future<void> register() async {
    _loading.start();
    try {
      await _auth.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await _auth.createEmailSession(
        email: email,
        password: password,
      );
      sendEmail();

      await _ref.refresh(userProvider.future);
      _loading.end();
    } on AppwriteException catch (e) {
      _loading.stop();
      return Future.error(e.message ?? "${e.code}");
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> sendEmail() async {
    try {
      await _auth.createVerification(url: "https://engexpert.vercel.app");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // void writeProfile(models.Account account) async {
  //   try {
  //    await _ref.read(repositoryProvider).writeProfile(
  //         Profile(
  //           id: account.$id,
  //           name: account.name,
  //           email: account.email,
  //         ),
  //       );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> logout() async {
    await _auth.deleteSessions();
    _ref.refresh(userProvider);
  }

  Future<void> signInWithGoogle() async {
    try {
      await _auth.createOAuth2Session(provider: 'google');
      await Future.delayed(const Duration(milliseconds: 500));
      await _ref.refresh(userProvider.future);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  Future<void> sendResetLink() async {
    try {
      await _auth.createRecovery(
        email: email,
        url: "https://engexpert.vercel.app/reset-password",
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final result = await GoogleSignIn(
  //       clientId: "444132166193-23v5blj01bt9i95ie6q01ptmgp9lcv7j.apps.googleusercontent.com"
  //     )
  //         .signIn();
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     _ref.refresh(userProvider);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
