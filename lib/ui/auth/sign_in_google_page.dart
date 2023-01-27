// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/labels.dart';
import 'providers/auth_provider.dart';

class SignInGooglePage extends ConsumerWidget {
  const SignInGooglePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final model = ref.read(authProvider);

    return Scaffold(
      backgroundColor: scheme.primaryContainer,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Connect with Community",
              style: style.displayMedium,
              textAlign: TextAlign.center,
            ),
            Image.asset("assets/intro.png"),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Labels.description,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MaterialButton(
                color: scheme.onPrimaryContainer,
                onPressed: () async {
                  await model.signInWithGoogle();
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Image.asset("assets/google.png"),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Sign In with Google",
                      style: style.titleMedium!
                          .copyWith(color: scheme.primaryContainer),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
