import 'package:english/ui/quiz/quiz_page.dart';
import 'package:english/ui/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../cores/providers/cache_provider.dart';
import '../cores/utils/constants.dart';
import 'auth/providers/user_provider.dart';
import 'auth/verify_page.dart';
import 'home/home_page.dart';
import 'profile/providers/my_profile_provider.dart';
import 'profile/write_profile_page.dart';

class Root extends ConsumerWidget {
  const Root({super.key});
  static const route = '/root';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cache = ref.read(cacheProvider).value!;
    return ref.watch(userProvider).when(
          data: (user) => user.emailVerification
              ? ref.watch(profileProvider).when(
                    data: (profile) =>
                        profile.level == null ? QuizPage() : const HomePage(),
                    error: (e, s) => e == Constants.documentNotExists
                        ? const WriteProfilePage()
                        : Scaffold(
                            body: Center(
                              child: Text("$e"),
                            ),
                          ),
                    loading: () => const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              : const EmailVerifyPage(),
          error: (e, s) => const WelcomePage(),
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
