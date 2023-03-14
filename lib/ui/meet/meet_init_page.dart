import 'package:english/cores/models/meet_session.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/home/widgets/timing_view.dart';
import 'package:english/ui/meet/providers/my_attempts_today_provider.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
import '../home/providers/topic_provider.dart';
import 'meet_web_page.dart';
import 'providers/handler_provider.dart';

class MeetInitPage extends HookConsumerWidget {
  const MeetInitPage({super.key});
  static const route = '/meet-init';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final model = ref.watch(meetHandlerProvider);
    final user = ref.read(userProvider).value!;
    final masterData = ref.read(masterDataProvider).value!;

    void join(MeetSession session) async {
      await Future.delayed(
        const Duration(microseconds: 200),
      );
      // ignore: use_build_context_synchronously
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetWebPage(
            session: session,
            topic: model.selectedTopic!,
            purchase: model.appliedPurchase!,
          ),
        ),
      );
    }

    Widget _buildBody() {
      if (model.camera == null || model.audio == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      // if ([PermissionStatus.permanentlyDenied, PermissionStatus.denied]
      //         .contains(model.audio) ||
      //     [PermissionStatus.permanentlyDenied, PermissionStatus.denied]
      //         .contains(model.camera)) {
      //   return const PermissionsPage();
      // }
      return model.subscription != null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Stream.periodic(
                const Duration(minutes: 1),
              ),
              builder: (context, snapshot) {
                return AsyncWidget(
                  value: ref.watch(purchasesProvider),
                  data: (_)=> model.elegiblePurchases.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "You don't have any call credits. Please purchase course or credits to join a call.",
                              style: style.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : AsyncWidget(
                          value: ref.watch(myAttemtsTodayProvider),
                          data: (data) {
                            if (data.length >= model.dailyLimit) {
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
                            } else if (model.elegibleTopics.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    "You don't have any topics to join. Please wait for your teacher to add topics to your course.",
                                    style: style.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else if (!masterData.now) {
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

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.all(8),
                                    children: [
                                      TimingView(
                                        timing: masterData.activeSlots,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                                        child: Text(
                                          "Select a topic",
                                          style: style.titleMedium,
                                        ),
                                      ),
                                      ...model.elegibleTopics.map((e) {
                                        return TopicCard(
                                          topic: e,
                                          selected:
                                              model.selectedTopic?.id == e.id,
                                          onTap: () {
                                            model.selectedTopic = e;
                                          },
                                        );
                                      }),
                                      ...{
                                        2: "2 Members",
                                        5: "5 Members",
                                        null: "Group"
                                      }.entries.map(
                                            (e) => RadioListTile<int?>(
                                              value: e.key,
                                              groupValue: model.limit,
                                              onChanged: (v) {
                                                model.limit = v;
                                              },
                                              title: Text(e.value),
                                            ),
                                          )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(16).copyWith(top: 0),
                                  child: AppButton(
                                    label: "Join",
                                    onPressed: model.selectedTopic != null
                                        ? () {
                                            model.startRandomJoin(onJoin: (v) {
                                              join(v);
                                            });
                                          }
                                        : null,
                                  ),
                                )
                              ],
                            );
                          }),
                );
              },
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Practice Call'),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }
}

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final model = ref.watch(meetHandlerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                child: Text(
                  "Please allow access following permissions to join a call.",
                  style: style.bodyMedium!.copyWith(
                    color: scheme.outline,
                  ),
                ),
              ),
              PermissionTile(
                permission: Permission.camera,
                status: model.camera!,
                onRequest: () {
                  model.requestCamera();
                },
              ),
              PermissionTile(
                permission: Permission.audio,
                status: model.audio!,
                onRequest: () {
                  model.requestAudio();
                },
              ),
            ],
          ),
        ),
        if (model.audio != PermissionStatus.permanentlyDenied &&
            model.camera != PermissionStatus.permanentlyDenied)
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: AppButton(
              label: "Allow",
              onPressed: model.request,
            ),
          ),
      ],
    );
  }
}

class PermissionTile extends HookConsumerWidget {
  const PermissionTile(
      {super.key,
      required this.permission,
      required this.status,
      required this.onRequest});

  final Permission permission;
  final PermissionStatus status;
  final VoidCallback onRequest;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    String name() {
      return permission == Permission.camera ? "Camera" : "Microphone";
    }

    return ListTile(
      onTap: () async {
        if (status == PermissionStatus.denied) {
          onRequest();
        } else {
          await openAppSettings();
        }
      },
      title: Text(name()),
      subtitle: status == PermissionStatus.denied
          ? Text('Tap to allow access to ${name().toLowerCase()}')
          : status == PermissionStatus.permanentlyDenied
              ? RefreshableText(
                  name().toLowerCase(),
                  onRefresh: () {
                    onRequest();
                  },
                )
              : null,
      trailing: isAndroid || status == PermissionStatus.denied
          ? const Icon(Icons.keyboard_arrow_right_rounded)
          : status == PermissionStatus.granted
              ? const Icon(Icons.check_circle_rounded, color: Colors.green)
              : const Icon(CupertinoIcons.settings),
    );
  }
}

class RefreshableText extends StatefulWidget {
  const RefreshableText(this.name, {super.key, this.onRefresh});
  final String name;
  final VoidCallback? onRefresh;
  @override
  State<RefreshableText> createState() => _RefreshableTextState();
}

class _RefreshableTextState extends State<RefreshableText>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final model = ref.read(meetHandlerProvider);
    if (state == AppLifecycleState.resumed) {
      widget.onRefresh?.call();
      // model.checkPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return Text(
      "You have permanently denied access to ${widget.name.toLowerCase()}. ${isAndroid ? "Tap to open settings and allow access to ${widget.name.toLowerCase()}." : "Please allow access to camera manually in settings."}",
    );
  }
}
