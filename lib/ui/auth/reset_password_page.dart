// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/auth/providers/auth_provider.dart';
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
        appBar: AppBar(
          title: const Text(Labels.forgotYourPassword),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Spacer(),
                Expanded(
                  flex: 4,
                  child: SvgPicture.asset(
                    Assets.forgotPassword,
                  ),
                ),
                const Spacer(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          Labels.enterYourRegisteredEmail,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
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
                          height: 16,
                        ),
                        BigButton(
                          onPressed: () async {
                            if (formKey.value.currentState!.validate()) {
                              formKey.value.currentState!.save();
                              try {
                                await model.sendResetLink();
                                AppSnackbar(context).message(
                                    "Reset link sent to ${model.email}");
                                Navigator.pop(context);
                              } catch (e) {
                                AppSnackbar(context).error(e);
                              }
                            }
                          },
                          label: Labels.sendResetLink,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${Labels.rememberPassword} ",
                    style: style.bodyMedium,
                    children: [
                      TextSpan(
                        text: Labels.login,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: scheme.primary),
                        recognizer: TapGestureRecognizer()..onTap = () {
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
