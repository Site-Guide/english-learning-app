import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils/labels.dart';
import '../auth/providers/auth_provider.dart';
import '../auth/providers/user_provider.dart';
import 'providers/my_profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String route = "/profile";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final user = ref.read(userProvider).value!;
    final profile = ref.read(myProfileProvider).value!;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text(Labels.myProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // const SizedBox(height: 8),
          // Center(
          //   child: Column(
          //     children: [
          //       // ProfileAvatar(
          //       //   profile: profile,
          //       //   radius: 32,
          //       // ),
          //       const SizedBox(height: 16),
          //       Text(
          //         user.name,
          //         style: style.titleLarge,
          //       ),
          //       const SizedBox(height: 12),
          //       Text(
          //         user.email,
          //       ),
          //       const SizedBox(height: 8),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 16),

          // ListTile(
          //   title: const Text("Help & Support"),
          //   trailing: Icon(Icons.keyboard_arrow_right_rounded),
          //   onTap: () {
          //     // String? encodeQueryParameters(Map<String, String> params) {
          //     //   return params.entries
          //     //       .map((MapEntry<String, String> e) =>
          //     //           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          //     //       .join('&');
          //     // }

          //     // final Uri emailLaunchUri = Uri(
          //     //   scheme: 'mailto',
          //     //   path: 'lexciofficial@gmail.com',
          //     //   query: encodeQueryParameters(<String, String>{
          //     //     'subject': 'Need Help/Support',
          //     //     'body': 'Hi Lexci Team, I am ${profile.name}, '
          //     //   }),
          //     // );

          //     // launchUrl(emailLaunchUri);
          //   },
          // ),
          // ListTile(
          //   title: const Text("Feedback"),
          //   trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          //   onTap: () {
          //     // launchUrlString(Constants.appLink,mode: LaunchMode.externalApplication);
          //   },
          // ),
          // ListTile(
          //   title: const Text("Share App"),
          //   leading: Icon(
          //     Icons.share,
          //     color: scheme.primary,
          //   ),
          //   trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          //   onTap: () {
          //     // Share.share("${Labels.appShareText} ${Constants.appLink}");
          //   },
          // ),
          // const SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(theme.buttonTheme.padding),
              ),
              onPressed: () async {
                ref.read(authProvider).logout();
              },
              child: const Text("Logout"),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Version 1.0",
            textAlign: TextAlign.center,
            style: TextStyle(color: style.caption!.color),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 300)
        ],
      ),
    );
  }
}
