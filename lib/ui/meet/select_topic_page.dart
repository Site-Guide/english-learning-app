// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/components/snackbar.dart';
import 'package:english/ui/home/providers/topic_provider.dart';
import 'package:english/ui/meet/meet_init_page.dart';
import 'package:english/ui/meet/providers/handler_provider.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/models/topic.dart';
import '../../cores/providers/master_data_provider.dart';
import '../home/widgets/timing_view.dart';

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
          : StreamBuilder(
              stream: Stream.periodic(
                const Duration(minutes: 1),
              ),
              builder: (context, snapshot) {
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
                return const TopicsView();
              },
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
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
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
                        isElegible: model.isTopicElegible(topic.id),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopicTile extends ConsumerWidget {
  const TopicTile({super.key, required this.topic, this.isElegible = true});

  final Topic topic;
  final bool isElegible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final model = ref.read(meetHandlerProvider);
    final masterData = ref.read(masterDataProvider).value!;

    final style = theme.textTheme.apply(
      bodyColor:
          isElegible ? theme.colorScheme.onSurface : theme.colorScheme.outline,
    );

    final purchases = ref
            .read(purchasesProvider)
            .asData
            ?.value
            .where((element) => element.typeId == topic.courseId) ?? [];
    final purchase = purchases.isNotEmpty ? purchases.first : null;
    final scheme = theme.colorScheme;
    return GestureDetector(
      onTap: () async {
        if (isElegible) {
          final attemts = await ref.read(myAttemtsTodayProvider.future);
          if (attemts.length >= model.dailyLimit) {
            AppSnackbar(context).message(
              "You have reached your daily limit of ${model.dailyLimit} practice calls. Please try again tomorrow.",
            );
            return;
          } else {
            model.selectedTopic = topic;
            Navigator.pushNamed(context, MeetInitPage.route);
          }
        } else {
          if (purchase != null && purchase.isExpired) {
            AppSnackbar(context).message(
              "You have used all call credits for this course",
            );
            return;
          }
          print(purchase?.isExpired);
          if (topic.courseId != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: scheme.surface,
                surfaceTintColor: scheme.surface,
                title: const Text(
                  "You haven't purchased this course",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: scheme.primaryContainer,
                    textColor: scheme.onPrimaryContainer,
                    onPressed: () async {},
                    child: const Text("Purchase Now"),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: scheme.surface,
                surfaceTintColor: scheme.surface,
                title: const Text(
                  "You haven't call credits for this topic",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: scheme.primaryContainer,
                    textColor: scheme.onPrimaryContainer,
                    onPressed: () async {},
                    child: const Text("Purchase Credits"),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isElegible ? scheme.outline : scheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topic.name,
                style: style.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (topic.courseName != null) ...[
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By",
                    style: style.bodySmall,
                    children: [
                      TextSpan(
                        text: " ${topic.courseName}",
                        style: style.bodySmall!.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const TextSpan(
                        text: " course",
                      ),
                    ],
                  ),
                ),
              ],
              if (purchase != null) ...[
                const SizedBox(height: 8),
                Text(
                  "${purchase.callsDone}/${purchase.calls}",
                  style: style.titleMedium!.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "calls done",
                  style: style.bodySmall,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
