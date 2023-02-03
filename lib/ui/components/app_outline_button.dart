import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton(
      {super.key, this.onPressed, required this.label, this.icon});

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final buttonStyle = OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: scheme.primary),
        textStyle: style.titleMedium);

    return icon != null
        ? OutlinedButton.icon(
            onPressed: onPressed,
            style: buttonStyle,
            icon: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: icon!,
            ),
            label: Row(
              children: [
                Text(label),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Text(label),
          );
  }
}
