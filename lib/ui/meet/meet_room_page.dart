import 'dart:async';

import 'package:english/cores/models/call.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:english/ui/meet/providers/handler.dart';
import 'package:english/ui/meet/widgets/room_view.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:wakelock/wakelock.dart';

import 'providers/topic_provider.dart';
import 'widgets/topic_card.dart';

class MeetRoomPage extends StatefulHookConsumerWidget {
  final JoinCall call;
  // final Topic topic;
  // final Purchase purchase;
  final Room room;
  final EventsListener<RoomEvent> listener;

  const MeetRoomPage({
    super.key,
    required this.call,
    // required this.topic,
    // required this.purchase,
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

  DateTime startedAt = DateTime.now();

  void init() async {
    // ref.read(callHandlerProvider).inCall = true;
    Wakelock.enable();
    _timer = Timer.periodic(const Duration(minutes: 15), (timer) {
      widget.room.disconnect().then((value) {
        Wakelock.disable();
      });
    });
    ref.read(purchasesRepositoryProvider).increamentCallsDone(widget.call.purchaseId);
    ref.read(meetRepositoryProvider).joined(widget.call.requestId);
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
                  final diff = startedAt
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
            Consumer(
              builder: (context, ref, child) {
                final topic =
                    ref.watch(topicProvider(widget.call.topicId)).asData?.value;
                return topic != null
                    ? TopicCard(
                        topic: topic,
                        noTap: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      topic.name,
                                      style: style.titleLarge,
                                    ),
                                  ),
                                  const CloseButton(),
                                ],
                              ),
                              content: SingleChildScrollView(
                                child: Text(
                                  topic.description,
                                  style: style.bodyLarge,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox();
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
