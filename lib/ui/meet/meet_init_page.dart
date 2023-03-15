import 'package:english/cores/models/meet_session.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/components/snackbar.dart';
import 'package:english/ui/meet/providers/sessions_stream_provider.dart';
import 'package:english/ui/meet/widgets/topic_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cores/providers/master_data_provider.dart';
import '../auth/providers/user_provider.dart';
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
    ref.read(sessionsStreamProvider);
    final model = ref.watch(meetHandlerProvider);
    final user = ref.read(userProvider).value!;
    final masterData = ref.read(masterDataProvider).value!;

    void join(MeetSession session) async {
      await Future.delayed(
        const Duration(microseconds: 200),
      );
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
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
      return model.subscription != null
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
                      ...{2: "2 Members", 5: "5 Members", null: "Group"}
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
                  child: AppButton(
                    label: "Join",
                    onPressed: model.selectedTopic != null
                        ? () {
                            model.startRandomJoin(
                              onJoin: (v) {
                                join(v);
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
                )
              ],
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Practice Call'),
      ),
      body: SafeArea(child: buildBody()),
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

    Widget? trailing() {
      if (status == PermissionStatus.granted) {
        return const Icon(Icons.check_circle_rounded, color: Colors.green);
      } else {
        return const Icon(Icons.keyboard_arrow_right_rounded);
      }
    }

    return ListTile(
        onTap: status != PermissionStatus.granted
            ? () async {
                if (status == PermissionStatus.denied) {
                  onRequest();
                } else {
                  await openAppSettings();
                }
              }
            : null,
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
        trailing: trailing());
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
