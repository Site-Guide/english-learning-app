// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/auth/reset_password_page.dart';
import 'package:english/ui/auth/widgets/google_button.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/app_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/assets.dart';
import '../../utils/labels.dart';
import '../../utils/validators.dart';
import '../components/loading_layer.dart';
import '../components/snackbar.dart';
import '../root.dart';
import 'providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  static const route = "/login";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final styles = theme.textTheme;
    final provider = authProvider;
    final model = ref.read(authProvider);
    return LoadingLayer(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Welcome back'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Email',
                    style: styles.bodyLarge,
                  ),
                  // const SizedBox(height: 8),
                  TextFormField(
                    initialValue: model.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'you@example.com'),
                    onChanged: (v) => model.email = v,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Password',
                    style: styles.bodyLarge,
                  ),
                  // const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      ref.watch(
                          provider.select((value) => value.obscurePassword));
                      return TextFormField(
                        obscureText: model.obscurePassword,
                        initialValue: model.password,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          hintText: 'at least 6 characters',
                          suffixIcon: IconButton(
                            onPressed: () {
                              model.obscurePassword = !model.obscurePassword;
                            },
                            icon: Icon(model.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                        ),
                        onChanged: (v) => model.password = v,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Consumer(
                    builder: (context, ref, child) {
                      ref.watch(provider);
                      return AppButton(
                        
                        onPressed:
                            model.email.isNotEmpty && model.password.isNotEmpty
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await model.login();
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Root.route,
                                          (route) => false,
                                        );
                                      } catch (e) {
                                        AppSnackbar(context).error(e);
                                      }
                                    }
                                  }
                                : null,
                        label: Labels.signIn.toUpperCase(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Labels.dontHaveAnAccount,
                      style: styles.bodyLarge,
                      children: [
                        TextSpan(
                            text: Labels.signUp,
                            style: styles.bodyLarge!.copyWith(
                              color: scheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, RegisterPage.route);
                              }),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ResetPasswordPage.route);
                    },
                    child: const Text(Labels.forgotPassword),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    Labels.or,
                    style: styles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GoogleButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
