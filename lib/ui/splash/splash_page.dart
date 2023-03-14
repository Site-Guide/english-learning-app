import 'package:english/utils/assets.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../cores/providers/cache_provider.dart';
import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
import '../purchases/providers/purchases_provider.dart';
import '../root.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String route = "/";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      await ref.read(cacheProvider.future);
      await ref.read(masterDataProvider.future);
      await ref.read(userProvider.future);
      await ref.read(purchasesProvider.future);
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint("$e");
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Root.route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      // backgroundColor: scheme.primary,
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3000),
            child: SvgPicture.asset(
              Assets.logo,
              height: 200,
              width: 200,
            ),
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     // Padding(
          //     //   padding: const EdgeInsets.only(left: 32),
          //     //   child: SizedBox(
          //     //     height: 240,
          //     //     width: 240,
          //     //     child: Image.asset(Assets.logo),
          //     //   ),
          //     // ),
          //     // Text(Labels.appName.toUpperCase(),
          //     //     style: style.headlineMedium!.copyWith(
          //     //       fontWeight: FontWeight.w800,
          //     //       color: scheme.onPrimary,
          //     //     )),
          //   ],
          // ),
        ),
      ),
    );
  }
}
