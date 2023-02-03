import 'package:english/ui/auth/register_page.dart';
import 'package:english/ui/auth/widgets/google_button.dart';
import 'package:english/ui/components/app_outline_button.dart';
import 'package:english/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GetsStartedPage extends StatelessWidget {
  const GetsStartedPage({super.key});

  static const route = '/get-started';
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s get started'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/english.svg',
              width: media.size.width,
            ),
            const SizedBox(height: 16),
            GoogleButton(),
            const SizedBox(height: 16),
            Text(
              'OR',
              style: style.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppOutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RegisterPage.route);
              },
              icon: const Icon(Icons.email_outlined),
              label: "Continue with Email",
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: style.bodySmall,
                text: 'By continuing, you agree to our ',
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: scheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(
                    text: ' and ',
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: scheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
