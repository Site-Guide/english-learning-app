import 'package:english/cores/models/meet_session.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/home/widgets/timing_view.dart';
import 'package:english/ui/meet/providers/my_todays_completed_meets_provider.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    final audio = useState<PermissionStatus?>(null);
    final camera = useState<PermissionStatus?>(null);

    bool askable(PermissionStatus status) {
      return ![
        PermissionStatus.granted,
        PermissionStatus.permanentlyDenied,
      ].contains(status);
    }

    void init() async {
      audio.value = await Permission.microphone.status;
      camera.value = await Permission.camera.status;
    }

    void request() async {
      List<Permission> list = [];
      if (askable(camera.value!)) {
        list.add(Permission.camera);
      }
      if (askable(audio.value!)) {
        list.add(Permission.microphone);
      }
      if (list.isNotEmpty) {
        final map = await list.request();
        map.forEach((key, value) {
          if (key == Permission.camera) {
            camera.value = value;
          } else if (key == Permission.microphone) {
            audio.value = value;
          }
        });
      }
    }

    useEffect(() {
      init();
      return () {};
    });

    final model = ref.watch(meetHandlerProvider);
    final user = ref.read(userProvider).value!;
    final masterData = ref.watch(masterDataProvider).value!;
    final topic = ref.watch(topicsProvider).value!;

    void join(MeetSession session) async {
      await Future.delayed(
        Duration(microseconds: 200),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetWebPage(
            session: session,
            topic: model.selectedTopic!,
          ),
        ),
      );
    }

    Widget _buildBody() {
      if (audio.value == null || camera.value == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (audio.value == PermissionStatus.permanentlyDenied ||
          camera.value == PermissionStatus.permanentlyDenied) {
        return const Center(
          child: Text('Please allow permissions'),
        );
      }
      return model.subscription != null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Stream.periodic(
                const Duration(minutes: 1),
              ),
              builder: (context, snapshot) {
                return SafeArea(
                  child: model.elegiblePurchases.isEmpty
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
                          value: ref.watch(myTodaysCompletedMeetsProvider),
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
                            }
                             else if(!masterData.now){
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
                                        padding: const EdgeInsets.all(8.0),
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
                                    onPressed: model.selectedTopic != null? () {
                                      model.startRandomJoin(onJoin: (v) {
                                        join(v);
                                      }, onEnd: () {
                                        Navigator.pop(context);
                                      });
                                    }: null,
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
      body: _buildBody(),
    );
  }
}
