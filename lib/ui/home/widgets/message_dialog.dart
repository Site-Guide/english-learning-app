import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../meet/providers/handler_provider.dart';

class MessageDialog extends ConsumerWidget {
  const MessageDialog({super.key, required this.title, required this.body});

  final String title;
  final String body;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final model = ref.watch(meetHandlerProvider);
    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(body),
          const SizedBox(height: 16),
          ElevatedButton(
            // color: scheme.secondaryContainer,
            // textColor: scheme.onSecondaryContainer,
            // padding: const EdgeInsets.all(12),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12)
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
