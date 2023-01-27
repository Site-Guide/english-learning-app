// ignore_for_file: unused_result

import 'package:english/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/labels.dart';
import '../components/snackbar.dart';
import '../root.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage>
    with WidgetsBindingObserver {
  final provider = authProvider;

  void onDone() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Root.route);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    WidgetsBinding.instance.addObserver(this);
    if (state == AppLifecycleState.resumed) {
      ref.refresh(userProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final styles = theme.textTheme;
    final model = ref.read(provider);
    final email = ref.read(userProvider).value!.email;
    return Scaffold(
      appBar: AppBar(
        title: Text(Labels.verifyYouEmail),
        actions: [
          IconButton(
            onPressed: () async {
              await model.logout();
              onDone();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(
              Labels.verificationEmailLink(email),
              textAlign: TextAlign.center,
              style: styles.bodyLarge,
            ),
            Spacer(),
            Expanded(
              flex: 4,
              child: SvgPicture.asset(
                Assets.emailVerify,
              ),
            ),
            Spacer(),
            Center(
              child: MaterialButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                color: scheme.primary,
                textColor: scheme.onPrimary,
                onPressed: () async {
                  ref.refresh(userProvider);
                },
                child: const Text(Labels.done),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  try {
                    await model.sendEmail();
                    // ignore: use_build_context_synchronously
                    AppSnackbar(context)
                        .message(Labels.verificationEmailResent);
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text(Labels.resend),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
