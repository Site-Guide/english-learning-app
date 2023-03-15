import 'package:english/ui/auth/get_started_page.dart';
import 'package:english/ui/auth/login_page.dart';
import 'package:english/ui/auth/register_page.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/app_outline_button.dart';
import 'package:english/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../onboarding/data.dart';

class WelcomePage extends HookWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;

    final controller =
        useTabController(initialLength: OnboardingData.intros.length);

    final index = useState(0);

    controller.addListener(() {
      if (index.value != controller.index) {
        index.value = controller.index;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 40 + 16 + 8,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(3000),
                child: SvgPicture.asset(
                  Assets.logo,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        title: const Text('ENGEXPERT'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TabBarView(
                controller: controller,
                children: OnboardingData.intros
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e.title,
                                style: style.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                            e.description != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e.description!,
                                      style: style.titleMedium!.copyWith(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )
                                : const SizedBox(),
                            Expanded(
                              flex: 6,
                              child: SvgPicture.asset(
                                e.path,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: OnboardingData.intros
                    .map(
                      (e) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.value == OnboardingData.intros.indexOf(e)
                              ? scheme.primary
                              : scheme.outline,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    onPressed: () {
                      Navigator.pushNamed(context, GetsStartedPage.route);
                    },
                    label: 'Sign up',
                  ),
                  const SizedBox(height: 16),
                  AppOutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.route);
                    },
                    label: 'Login',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
