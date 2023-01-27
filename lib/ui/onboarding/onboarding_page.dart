import 'package:english/cores/providers/cache_provider.dart';
import 'package:english/ui/onboarding/data.dart';
import 'package:english/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/utils/constants.dart';
import '../root.dart';



class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    // final lang = ref.watch(langProvider);


    final controller = useTabController(initialLength: OnboardingData.intros.length);

    final index = useState(0);

    controller.addListener(() {
      if (index.value != controller.index) {
        index.value = controller.index;
      }
    });

    void done() async {
      ref.read(cacheProvider).value!.setBool(Constants.seen, true);
      Navigator.pushNamedAndRemoveUntil(context, Root.route,(route) => false,);
    }

    final bool last = index.value == OnboardingData.intros.length - 1;

    return Scaffold(
      backgroundColor:scheme.surface,
      appBar: AppBar(
        actions: [
         if(!last) TextButton(
            onPressed: done,
            child: const Text(
              Labels.skip
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    color: scheme.primary,
                    textColor:  scheme.onPrimary,
                    onPressed: () {
                      if (controller.index < OnboardingData.intros.length - 1) {
                        index.value += 1;
                        controller.animateTo(controller.index + 1);
                      } else {
                        done();
                      }
                    },
                    child: Row(
                      children: [
                        Text(last
                            ? Labels.done
                            : Labels.next.toUpperCase()),
                        const Icon(Icons.keyboard_arrow_right_rounded)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: OnboardingData.intros
            .map(
              (e) => Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: SvgPicture.asset(
                      e.path,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e.title,
                            style: style.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        e.description != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.description!,
                                  style: style.titleLarge!.copyWith(
                                    fontWeight: FontWeight.normal
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const Spacer()
                      ],
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
