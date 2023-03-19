import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/components/snackbar.dart';
import 'package:english/ui/meet/providers/sessions_stream_provider.dart';
import 'package:english/ui/meet/widgets/feedback_dialog.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
import 'meet_room_page.dart';
import 'providers/handler_provider.dart';
import 'widgets/permissions_view.dart';

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
    print(model.subscription != null);
    Widget buildBody() {
      if (model.camera == null || model.audio == null) {
        return const LogoLoading();
      }
      if ([PermissionStatus.permanentlyDenied, PermissionStatus.denied]
              .contains(model.audio) ||
          [PermissionStatus.permanentlyDenied, PermissionStatus.denied]
              .contains(model.camera)) {
        return const PermissionsPage();
      }
      return model.loading
          ? const LogoLoading(
              message: "Setting up your call...",
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      TopicCard(
                        topic: model.selectedTopic!,
                      ),
                      ...{2: "2 Members", null: "Group call upto 5 members"}
                          .entries
                          .map(
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
                  padding: const EdgeInsets.all(16).copyWith(top: 0),
                  child: AsyncWidget(
                    value: ref.watch(sessionsStreamProvider),
                    data: (data) => AppButton(
                      label: "Join",
                      onPressed: model.selectedTopic != null
                          ? () {
                              model.startRandomJoin(
                                onJoin:
                                    (session, topic, purchase, room, listener)async  {
                                   Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MeetRoomPage(
                                          room: room,
                                          listener: listener,
                                          session: session,
                                          topic: model.selectedTopic!,
                                          purchase: model.appliedPurchase!,
                                        );
                                      },
                                    ),
                                  );
                                },
                                onSearchEnd: () {
                                  AppSnackbar(context).message(
                                    'Sorry, No members available to call for this topic. Please try again or select different topic.',
                                  );
                                },
                              );
                            }
                          : null,
                    ),
                  ),
                )
              ],
            );
    }

    return WillPopScope(
      onWillPop: () async{
        model.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join Practice Call'),
        ),
        body: SafeArea(child: buildBody()),
      ),
    );
  }
}
