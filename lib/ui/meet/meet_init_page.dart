import 'package:english/cores/models/meet_session.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/home/widgets/timing_view.dart';
import 'package:english/ui/meet/providers/meets_provider.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
import '../home/providers/topic_provider.dart';
import 'meet_web_page.dart';
import 'providers/handler_provider.dart';

class MeetInitPage extends ConsumerWidget {
  const MeetInitPage({super.key});

  static const route = '/meet-init';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final handler = ref.watch(meetHandlerProvider);
    final user = ref.read(userProvider).value!;
    final masterData = ref.watch(masterDataProvider).value!;
    final topic = ref.watch(topicProvider).value!;

    void join(MeetSession session) async {
      await Future.delayed(Duration(microseconds: 200));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetWebPage(
            topic: topic,
            id: session.id,
            duration: Duration(minutes: 2),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Practice Call'),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: Stream.periodic(
          const Duration(minutes: 1),
        ),
        builder: (context, snapshot) {
          return masterData.now && handler.status == MeetStatus.init
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    child: StreamBuilder(builder: (context, snapshot) {
                      return AppButton(
                        label: "Join",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetWebPage(
                                topic: topic,
                                id: '111111',
                                duration: Duration(minutes: 2),
                              ),
                            ),
                          );
                          // handler.status = MeetStatus.meet;
                          // handler.start('shiv');
                        },
                      );
                    }),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      body: handler.status == MeetStatus.init
          ? StreamBuilder(
              stream: Stream.periodic(
                const Duration(minutes: 1),
              ),
              builder: (context, snapshot) {
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimingView(
                        timing: masterData.activeSlots,
                      ),
                      if (masterData.now) ...[
                        Padding(
                          padding: const EdgeInsets.all(16).copyWith(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Topic'),
                              const SizedBox(height: 8),
                              TopicCard(topic: topic),
                            ],
                          ),
                        ),
                        RadioListTile<int?>(
                          selected: handler.limit == 2,
                          value: 2,
                          groupValue: handler.limit,
                          onChanged: (v) {
                            handler.limit = v;
                          },
                          title: const Text('2 Members'),
                        ),
                        RadioListTile(
                          value: 5,
                          groupValue: handler.limit,
                          onChanged: (v) {
                            handler.limit = v;
                          },
                          title: const Text('5 Members'),
                        ),
                        RadioListTile(
                          value: null,
                          groupValue: handler.limit,
                          onChanged: (v) {
                            handler.limit = v;
                          },
                          title: const Text('Group'),
                        ),
                      ] else ...[
                        Expanded(
                          child: Center(
                            child: Text(
                              'Join at ${masterData.activeSlots.first.start.label}',
                              style: style.titleLarge,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              })
          : SafeArea(
              child: AsyncWidget(
                  value: ref.watch(meetsProvider),
                  data: (data) {
                    data = data
                        .where((element) => element.createdAt.isAfter(
                            DateTime.now()
                                .subtract(const Duration(minutes: 2))))
                        .toList();
                    final ready = data
                        .where((element) =>
                            element.limit == handler.limit &&
                            (element.participants.length ==
                                (handler.limit ?? 1)))
                        .where((element) =>
                            element.participants.contains(user.$id))
                        .toList();
                    print(ready.length);
                    print(ready.isNotEmpty);
                    if (ready.isNotEmpty) {
                      print('joining');
                      if (!handler.busy) {
                        join(ready.first);
                      }
                    } else {
                      final filtered = data.where((element) =>
                          element.limit == handler.limit &&
                          element.participants.length < (handler.limit ?? 1));
                      if (filtered.isEmpty) {
                        if (!handler.busy) {
                          print('creating');
                          handler.createMeet();
                        }
                      } else {
                        if (!filtered.first.participants.contains(user.$id)) {
                          print('joining meet');
                          handler.joinMeet(filtered.first);
                        }
                      }
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
    );
  }
}
