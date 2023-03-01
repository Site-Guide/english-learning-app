import 'dart:async';

import 'package:english/cores/models/topic.dart';
import 'package:english/themes.dart';
import 'package:english/ui/meet/providers/handler_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/topic_card.dart';

class MeetWebPage extends StatefulHookConsumerWidget {
  const MeetWebPage(
      {super.key,
      required this.topic,
      required this.duration,
      required this.id});
  final Topic topic;
  final Duration duration;
  final String id;
  @override
  ConsumerState<MeetWebPage> createState() => _MeetWebPageState();
}

class _MeetWebPageState extends ConsumerState<MeetWebPage> {
  late Timer timer;
  late DateTime startedAt;
  @override
  void initState() {
    super.initState();
    timer = Timer(widget.duration, () {
      ref.read(meetHandlerProvider).init();
      Navigator.pop(context);
    });
    startedAt = DateTime.now();
  }

  // @override
  // void dispose() {
  //   ref.read(meetHandlerProvider).init();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    String _printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return Theme(
      data: Themes.dark,
      child: WillPopScope(
        onWillPop: () async {
          ref.read(meetHandlerProvider).init();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [
              StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1)),
                builder: (context, snapshot) {
                  final diff =
                      startedAt.add(widget.duration).difference(DateTime.now());
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
                child: TopicCard(topic: widget.topic),
              ),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse('https://jitsi.engexpert.in/${widget.id}'),
                  ),
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async{
                    print("##############: ${navigationAction.request.url}");
                    return NavigationActionPolicy.ALLOW;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
