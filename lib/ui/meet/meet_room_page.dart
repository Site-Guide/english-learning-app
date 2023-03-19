import 'dart:async';

import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/models/topic.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:english/ui/meet/widgets/room_view.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:wakelock/wakelock.dart';

class MeetRoomPage extends StatefulHookConsumerWidget {
  final MeetSession session;
  final Topic topic;
  final Purchase purchase;
  final Room room;
  final EventsListener<RoomEvent> listener;

  const MeetRoomPage({
    super.key,
    required this.session,
    required this.topic,
    required this.purchase,
    required this.room,
    required this.listener,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetWebPageState();
}

class _MeetWebPageState extends ConsumerState<MeetRoomPage> {
  late Timer _timer;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    Wakelock.enable();
    ref
        .read(meetRepositoryProvider)
        .saveAttempt(widget.session, widget.purchase);
    _timer = Timer.periodic(const Duration(minutes: 15), (timer) {
      widget.room.disconnect().then((value) {
        Wakelock.disable();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  final diff = widget.session.createdAt
                      .add(const Duration(minutes: 15))
                      .difference(DateTime.now());
                  final completed = diff.isNegative;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      completed ? "00:00:00" : diff.data,
                      style: style.labelMedium!.copyWith(
                        color: completed ? scheme.error : scheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                'Note: The meeting is being recorded. Please maintenance the decorum.',
                style: style.bodySmall!.copyWith(
                  color: scheme.error,
                ),
              ),
            ),
            TopicCard(
              topic: widget.topic,
              noTap: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.topic.name,
                            style: style.titleLarge,
                          ),
                        ),
                        const CloseButton(),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Text(
                        widget.topic.description,
                        style: style.bodyLarge,
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: RoomView(widget.room, widget.listener),
            ),
          ],
        ),
      ),
    );
  }
}
