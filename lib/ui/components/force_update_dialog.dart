import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../cores/utils/constants.dart';
import '../../utils/labels.dart';

class VersionUpdateDialog extends StatelessWidget {
  const VersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(Labels.heyThere),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(Labels.later),
        ),
        MaterialButton(
          padding: const EdgeInsets.all(16),
          color: scheme.primary,
          textColor: scheme.onPrimary,
          onPressed: () {
            launchUrlString(defaultTargetPlatform == TargetPlatform.iOS
                ? Constants.appLinkIos
                : Constants.appLink);
            Navigator.pop(context);
          },
          child: const Text(Labels.update),
        ),
      ],
    );
  }
}

class ForceVersionUpdateDialog extends StatelessWidget {
  const ForceVersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(Labels.urghhYou),
        content: MaterialButton(
          textColor: scheme.onPrimary,
          padding: const EdgeInsets.all(16),
          color: scheme.primary,
          onPressed: () {
            launchUrlString(defaultTargetPlatform == TargetPlatform.iOS
                ? Constants.appLinkIos
                : Constants.appLink);
          },
          child: const Text(Labels.update),
        ),
      ),
    );
  }
}
