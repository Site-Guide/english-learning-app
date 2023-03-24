// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:async';

import 'package:english/cores/models/call.dart';
import 'package:english/cores/utils/extensions.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/components/loading_layer.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/home/providers/notification_settings_provider.dart';
import 'package:english/ui/meet/providers/handler.dart';
import 'package:english/ui/meet/providers/topics_provider.dart';
import 'package:english/ui/meet/providers/handler_provider.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/extensions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/providers/master_data_provider.dart';
import '../home/widgets/timing_view.dart';
import 'meet_room_page.dart';
import 'widgets/topic_tile.dart';

class SelectTopicPage extends ConsumerWidget {
  const SelectTopicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final masterData = ref.read(masterDataProvider).value!;
    final model = ref.watch(meetHandlerProvider);
    return WillPopScope(
      onWillPop: () async {
        if (ref.read(requestsProvider).asData?.value.hasPending ?? false) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join Practice Call'),
        ),
        body: AsyncWidget(
          value: ref.watch(notificationSettingsProvider),
          data: (data) {
            if ([
              AuthorizationStatus.denied,
              AuthorizationStatus.notDetermined
            ].contains(data.authorizationStatus)) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Please enable notifications to receive call requests.",
                        style: style.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () async {
                          ref.refresh(notificationSettingsProvider);
                        },
                        child: const Text("Enable Notifications"),
                      )
                    ],
                  ),
                ),
              );
            }

            return model.camera == null || model.audio == null
                ? const LogoLoading()
                : const TopicsView();
          },
        ),
      ),
    );
  }
}

class TopicsView extends ConsumerWidget {
  const TopicsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final masterData = ref.read(masterDataProvider).value!;

    final scheme = theme.colorScheme;
    final model = ref.read(meetHandlerProvider);
    return HookConsumer(builder: (context, ref, child) {
      useEffect(() {
        print('useEffect');
        final timer = Timer.periodic(const Duration(seconds: 7), (timer) async {
          print('refreshing');
          final calls = await ref.refresh(requestsProvider.future);
          if (calls.joineReady != null) {
            print('joineReady');
            final model = ref.read(meetHandlerProvider);
            final call = calls.joineReady!;
            model.joinRoom(call.token!, (room, listener) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetRoomPage(
                    call: JoinCall(
                      title: '',
                      body: '',
                      token: call.token!,
                      requestId: call.id,
                      topicId: call.topicId,
                      purchaseId: call.purchaseId,
                    ),
                    room: room,
                    listener: listener,
                  ),
                ),
              );
            });
          }
        });
        return () {
          timer.cancel();
        };
      }, const []);
      return StreamBuilder(
          stream: Stream.periodic(
            const Duration(seconds: 1),
          ),
          builder: (context, snapshot) {
            return AsyncWidget(
              logoLoading: true,
              value: ref.watch(requestsProvider),
              data: (requests) {
                if (requests.joineReady != null) {
                  return const LogoLoading();
                } else if (requests.pending.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You have a pending call request. Please wait a while. It usually takes 1-2 minutes.",
                            style: style.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(requests.pending.first.createdAt
                              .add(const Duration(minutes: 2))
                              .difference(DateTime.now())
                              .miniData),
                        ],
                      ),
                    ),
                  );
                } else if (requests
                        .where((element) => element.connected)
                        .length >=
                    model.dailyLimit) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "You have reached your daily limit of ${model.dailyLimit} calls. Please try again tomorrow.",
                        style: style.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Builder(
                  builder: (context) {
                    if (!masterData.now) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Practice room available from \n${masterData.slots.map((e) => e.label).join(',\n')}",
                                style: style.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return AsyncWidget(
                      value: ref.watch(purchasesProvider),
                      data: (_) => AsyncWidget(
                        value: ref.watch(topicsProvider),
                        data: (data) {
                          if (data.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  "You don't have any topics to join. Please wait for your teacher to add topics for you.",
                                  style: style.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: TimingView(
                                  timing: masterData.activeSlots,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16)
                                    .copyWith(bottom: 0),
                                child: Text(
                                  'Select topic to join practice call',
                                  style: style.titleSmall,
                                ),
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                children: [
                                  ...data.where((element) =>
                                      element.courseId == null &&
                                      model.isTopicElegible(element.id)),
                                  ...data.where((element) =>
                                      element.courseId != null &&
                                      model.isTopicElegible(element.id)),
                                  ...data.where((element) =>
                                      element.courseId == null &&
                                      !model.isTopicElegible(element.id)),
                                  ...data.where((element) =>
                                      element.courseId != null &&
                                      !model.isTopicElegible(element.id)),
                                ]
                                    .map(
                                      (topic) => TopicTile(
                                        topic: topic,
                                        isElegible:
                                            model.isTopicElegible(topic.id),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          });
    });
  }
}

// Padding(
//   padding: const EdgeInsets.all(8),
//   child: Column(
//     children: [
//       ...data.where((element) =>
//           element.courseId == null &&
//           model.isTopicElegible(element.id)),
//       ...data.where((element) =>
//           element.courseId != null &&
//           model.isTopicElegible(element.id)),
//       ...data.where((element) =>
//           element.courseId == null &&
//           !model.isTopicElegible(element.id)),
//       ...data.where((element) =>
//           element.courseId != null &&
//           !model.isTopicElegible(element.id)),
//     ]
//         .map(
//           (topic) => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TopicTile(
//               topic: topic,
//               isElegible: model.isTopicElegible(topic.id),
//             ),
//           ),
//         )
//         .toList(),
//   ),
// ),
