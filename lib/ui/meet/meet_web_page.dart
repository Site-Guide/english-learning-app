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

class MeetWebPage extends StatefulHookConsumerWidget {
  final MeetSession session;
  final Topic topic;
  final Purchase purchase;

  const MeetWebPage(
      {super.key,
      required this.session,
      required this.topic,
      required this.purchase});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetWebPageState();
}

class _MeetWebPageState extends ConsumerState<MeetWebPage> {
  late Timer _timer;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final user = ref.read(userProvider).value!;

    ref
        .read(meetRepositoryProvider)
        .createAttempt(
          Attempt(
            meetId: widget.session.id,
            userId: user.$id,
            date: Dates.today.date,
          ),
        )
        .then((value) {
      ref.refresh(myAttemtsTodayProvider);
    });
    ref
        .read(purchasesRepositoryProvider)
        .increamentCallsDone(widget.purchase)
        .then((value) {
      ref.refresh(purchasesProvider);
    });
    _timer = Timer.periodic(const Duration(minutes: 15), (timer) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final url = "https://jitsi.engexpert.in/${widget.session.id}";
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
                final diff = widget.session.createdAt
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
              child: TopicCard(
                topic: widget.topic,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.topic.name,
                              style: style.titleMedium,
                            ),
                          ),
                          CloseButton(),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Text(
                          "Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration. In practice it would be difficult to write literature that drew on just one of the four basic modes. Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration. In practice it would be difficult to write literature that drew on just one of the four basic modes. Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration. In practice it would be difficult to write literature that drew on just one of the four basic modes. Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration. In practice it would be difficult to write literature that drew on just one of the four basic modes.",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(url)
                ),
                androidOnPermissionRequest: (controller, origin, resources) async{
                  return PermissionRequestResponse(
                    action: PermissionRequestResponseAction.GRANT,
                    resources: resources,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
