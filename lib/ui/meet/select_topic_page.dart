// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/meet/providers/topics_provider.dart';
import 'package:english/ui/meet/providers/handler_provider.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/providers/master_data_provider.dart';
import '../home/widgets/timing_view.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Practice Call'),
      ),
      body: model.camera == null || model.audio == null
          ? const LogoLoading()
          : TopicsView(),
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
    return StreamBuilder(
        stream: Stream.periodic(
          const Duration(seconds: 1),
        ),
        builder: (context, snapshot) {
          return AsyncWidget(
            logoLoading: true,
            value: ref.watch(requestsProvider),
            data: (requests) {
              final pending = requests.where(
                (element) =>
                    !element.connected &&
                    element.createdAt.isAfter(
                      DateTime.now().subtract(
                        const Duration(minutes: 2),
                      ),
                    ),
              );
              if (pending.isNotEmpty) {
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
                        Text(pending.first.createdAt
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
                              padding:
                                  const EdgeInsets.all(16).copyWith(bottom: 0),
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
