import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/home/widgets/timing_view.dart';
import 'package:english/ui/meet/providers/meets_provider.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
import '../home/providers/topic_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Practice Call'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: AppButton(
            label: "Join",
            onPressed: () {},
          ),
        ),
      ),
      body: 1 == 1
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimingView(
                  timing: masterData.activeSlots,
                ),
                Padding(
                  padding: const EdgeInsets.all(16).copyWith(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Topic'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.topic,
                              style: style.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topic.description,
                            ),
                          ],
                        ),
                      ),
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
              ],
            )
          : AsyncWidget(
              value: ref.watch(meetsProvider),
              data: (data) {
                final ready = data
                    .where((element) =>
                        element.limit == 2 && element.participants.length == 2)
                    .where((element) => element.participants.contains(user.$id))
                    .toList();

                if (ready.isNotEmpty) {
                  handler.start(ready.first.id);
                } else {
                  final filtered = data.where((element) =>
                      element.limit == 2 && element.participants.length < 2);
                  if (filtered.isEmpty) {
                    if (!handler.busy) {
                      handler.createMeet();
                    }
                  } else {
                    if (!filtered.first.participants.contains(user.$id)) {
                      handler.joinMeet(filtered.first);
                    }
                  }
                }

                return ListView(
                  children: data
                      .map(
                        (e) => ListTile(
                          trailing: (e.limit ?? 2) == e.participants.length
                              ? const Text('Ready')
                              : null,
                          title: Text(e.subject),
                          subtitle: Text(e.createdAt.toString()),
                        ),
                      )
                      .toList(),
                );
              }),
    );
  }
}
