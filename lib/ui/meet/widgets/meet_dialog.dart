import 'package:english/cores/models/call.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:english/ui/meet/meet_room_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/handler_provider.dart';

class MeetDialog extends HookConsumerWidget {
  const MeetDialog({super.key, required this.call});

  final JoinCall call;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    useEffect(() {
      ref.read(meetRepositoryProvider).shown(call.requestId);
      return () {};
    }, const []);
    final model = ref.watch(meetHandlerProvider);
    return AlertDialog(
      // backgroundColor: scheme.surface,
      // surfaceTintColor: scheme.surface,
      title: Text(call.title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(call.body),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            onPressed: model.joinLoading
                ? null
                : () {
                    model.joinRoom(call.token, (room, listener) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetRoomPage(
                            call: call,
                            room: room,
                            listener: listener,
                          ),
                        ),
                      );
                    });
                  },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (model.joinLoading)
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                const Text('CONNECT'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
