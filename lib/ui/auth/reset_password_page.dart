// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/auth/providers/auth_provider.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/loading_layer.dart';
import 'package:english/ui/components/snackbar.dart';
import 'package:english/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/assets.dart';
import '../../utils/labels.dart';
import '../components/big_button.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key});

  static const route = "/reset_password";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final model = ref.watch(authProvider);
    final formKey = useRef(GlobalKey<FormState>());
    return LoadingLayer(
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          title: const Text(Labels.forgotYourPassword),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  Labels.enterYourRegisteredEmail,
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: formKey.value,
                  child: TextFormField(
                    initialValue: model.email,
                    decoration: const InputDecoration(
                      hintText: Labels.email,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: Validators.email,
                    onChanged: (v) => model.email = v,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                AppButton(
                  onPressed: () async {
                    if (formKey.value.currentState!.validate()) {
                      formKey.value.currentState!.save();
                      try {
                        await model.sendResetLink();
                        AppSnackbar(context).message(
                          "Reset link sent to ${model.email}",
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        AppSnackbar(context).error(e);
                      }
                    }
                  },
                  label: Labels.sendResetLink,
                ),
                const SizedBox(
                  height: 32,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${Labels.rememberPassword} ",
                    style: style.bodyLarge,
                    children: [
                      TextSpan(
                        text: Labels.login,
                        style: TextStyle(
                          color: scheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
