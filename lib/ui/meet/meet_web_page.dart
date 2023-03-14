import 'dart:async';

import 'package:english/cores/models/attempt.dart';
import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:english/themes.dart';
import 'package:english/utils/dates.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/providers/user_provider.dart';
import '../purchases/providers/purchases_provider.dart';
import 'providers/my_attempts_today_provider.dart';
import 'widgets/topic_card.dart';

class MeetWebPage extends HookConsumerWidget {
  final MeetSession session;
  final Topic topic;
  final Purchase purchase;

  MeetWebPage({super.key, required this.session, required this.topic,required this.purchase});

  late Timer _timer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider).value!;
    useEffect(() {
      print("done      ............");
      ref.read(meetRepositoryProvider).createAttempt(
            Attempt(
              meetId: session.id,
              userId: user.$id,
              date: Dates.today.date,
            ),
          ).then((value) {
            ref.refresh(myAttemtsTodayProvider);
          });
       ref.read(purchasesRepositoryProvider).increamentCallsDone(purchase).then((value) {
        ref.refresh(purchasesProvider);
       });
      _timer = Timer.periodic(const Duration(minutes: 15), (timer) {
        Navigator.pop(context);
      });
      return () {
        _timer.cancel();
      };
    });

    return Theme(
      data: Themes.dark,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                final diff = session.createdAt
                    .add(const Duration(minutes: 15))
                    .difference(DateTime.now());
                return Text(diff.data);
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TopicCard(topic: topic),
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('https://jitsi.engexpert.in/${session.id}'),
                ),
                onPermissionRequest: (controller, permissionRequest) async {
                  return PermissionResponse(
                    resources: permissionRequest.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  print("##############: ${navigationAction.request.url}");
                  Navigator.pop(context);
                  return NavigationActionPolicy.CANCEL;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
