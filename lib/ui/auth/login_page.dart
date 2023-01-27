// ignore_for_file: use_build_context_synchronously

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
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      Labels.signIn,
                      style: styles.headlineLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: model.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: Labels.email,
                      ),
                      onChanged: (v) => model.email = v,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(
                            provider.select((value) => value.obscurePassword));
                        return TextFormField(
                          obscureText: model.obscurePassword,
                          initialValue: model.password,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            labelText: Labels.password,
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
                    const SizedBox(height: 24),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(provider);
                        return MaterialButton(
                          disabledColor: scheme.surfaceVariant,
                          textColor: scheme.onPrimary,
                          color: scheme.primary,
                          // padding: const EdgeInsets.all(16),
                          onPressed: model.email.isNotEmpty &&
                                  model.password.isNotEmpty
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await model.login();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Root.route,
                                      );
                                    } catch (e) {
                                      AppSnackbar(context).error(e);
                                    }
                                  }
                                }
                              : null,
                          child: Text(Labels.signIn.toUpperCase()),
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
                              style: styles.button!.copyWith(
                                  fontSize: styles.bodyLarge!.fontSize,
                                  color: scheme.primary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterPage.route);
                                }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      Labels.or,
                      style: styles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.onPrimary,
                        foregroundColor: scheme.primary,
                      ),
                      onPressed: () async {
                        await model.signInWithGoogle();
                        Navigator.pushNamedAndRemoveUntil(
                            context, Root.route, (route) => false);
                      },
                      label: const Text(
                      Labels.signInWithGoogle
                      ),
                      icon: Image.asset(
                        Assets.google,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
