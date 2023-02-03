// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/assets.dart';
import '../../components/app_outline_button.dart';
import '../../root.dart';
import '../providers/auth_provider.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(authProvider);
    return AppOutlinedButton(
      onPressed: () async {
        await model.signInWithGoogle();
        Navigator.pushNamedAndRemoveUntil(
          context,
          Root.route,
          (route) => false,
        );
      },
      icon: Image.asset(
        Assets.google,
        height: 24,
        width: 24,
      ),
      label: "Continue with Google",
    );
  }
}
