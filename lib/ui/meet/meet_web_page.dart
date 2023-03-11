import 'dart:async';

import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/themes.dart';
import 'package:english/ui/meet/providers/handler_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/topic_card.dart';

class MeetWebPage extends ConsumerWidget {
  final MeetSession session;
  final Topic topic;

  const MeetWebPage({super.key, required this.session, required this.topic});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return Theme(
      data: Themes.dark,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                final diff = session.createdAt
                    .add(const Duration(minutes: 2))
                    .difference(DateTime.now());
                return Text(_printDuration(diff));
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
