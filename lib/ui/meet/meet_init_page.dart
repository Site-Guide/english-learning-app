// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/components/loading_layer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/app_button.dart';
import '../components/logo_loading.dart';
import 'providers/handler_provider.dart';
import 'widgets/permissions_view.dart';
import 'widgets/topic_card.dart';

class MeetInitPage extends StatefulHookConsumerWidget {
  const MeetInitPage({super.key});
  static const route = '/meet-init';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetInitPageState();
}

class _MeetInitPageState extends ConsumerState<MeetInitPage> {
  @override
  void initState() {
    // init();
    super.initState();
  }

  // void init() {
  //   final model = ref.read(meetHandlerProvider);
  //   model.initMessaging((requestId, topic, purchase, room, listener) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return MeetRoomPage(
  //             room: room,
  //             listener: listener,
  //             requestId: requestId,
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }

  // @override
  // void dispose() {
  //   ref.read(meetHandlerProvider).dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = ref.watch(meetHandlerProvider);
    Widget buildBody() {
      if (model.camera == null || model.audio == null) {
        return const LogoLoading();
      }
      if ([PermissionStatus.permanentlyDenied, PermissionStatus.denied]
              .contains(model.audio) ||
          [PermissionStatus.permanentlyDenied, PermissionStatus.denied]
              .contains(model.camera)) {
        return const PermissionsView();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                TopicCard(
                  topic: model.selectedTopic!,
                ),
                ...{2: "2 Members", 5: "Group call upto 5 members"}.entries.map(
                      (e) => RadioListTile<int>(
                        value: e.key,
                        groupValue: model.limit,
                        onChanged: (v) {
                          model.limit = v!;
                        },
                        title: Text(e.value),
                      ),
                    )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: AppButton(
              label: "Request",
              onPressed: model.selectedTopic != null
                  ? () async {
                      await model.request();
                      Navigator.pop(context);
                    }
                  : null,
            ),
          )
        ],
      );
    }

    return LoadingLayer(
      logo: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join Practice Call'),
        ),
        body: SafeArea(child: buildBody()),
      ),
    );
  }
}
