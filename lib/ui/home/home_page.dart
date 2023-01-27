// ignore_for_file: unused_result

import 'dart:async';

import 'package:english/ui/home/widgets/home_view.dart';
import 'package:english/utils/extensions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config.dart';
import '../../cores/providers/links_provider.dart';
import '../../cores/providers/master_data_provider.dart';
import '../components/force_update_dialog.dart';
import '../courses/widgets/course_card.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  late StreamSubscription<PendingDynamicLinkData> linkSubscription;

  FirebaseDynamicLinks get _links => ref.read(linksProvider);

  @override
  void initState() {
    checkUpdate();
    // WidgetsBinding.instance.addObserver(this);
    // getInitialLink();
    // linkSubscription = _links.onLink.listen((event) {
    //   handleLink(event);
    // });
    super.initState();
  }

  void getInitialLink() async {
    // final value = await _links.getInitialLink();
    // if (value != null) {
    //   handleLink(value);
    // }
  }

  void handleLink(PendingDynamicLinkData link) {
    final id = link.link.toString().split('/').last;
    if (id.isNotEmpty) {
      // Navigator.pushNamed(context, EventRoot.route, arguments: id);
    }
  }

  @override
  void dispose() {
    linkSubscription.cancel();
    super.dispose();
  }

  void checkUpdate() async {
    // ref.read(masterDataProvider).whenData(
    //   (value) async {
    //     if (value.version != Config.version) {
    //       await Future.delayed(const Duration(milliseconds: 250));
    //       showDialog(
    //         context: context,
    //         builder: (context) => value.force
    //             ? const ForceVersionUpdateDialog()
    //             : const VersionUpdateDialog(),
    //       );
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      bottomNavigationBar: Theme(
        data: theme.copyWith(
          colorScheme: scheme.copyWith(
            secondaryContainer: scheme.primaryContainer,
          ),
        ),
        child: NavigationBar(
          backgroundColor: scheme.surface,
          surfaceTintColor: scheme.surface,
          onDestinationSelected: (v) {
            index.value = v;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.group),
              label: "Practice",
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: "Chat",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              label: "Profile",
            ),
          ],
          selectedIndex: index.value,
        ),
      ),
      body: [
        const HomeView(),
        const Scaffold(),
        const Scaffold(),
        const ProfilePage(),
      ][index.value],
    );
  }
}
