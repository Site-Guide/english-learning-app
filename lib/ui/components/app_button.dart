import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onPressed, required this.label});
  
  final VoidCallback? onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return MaterialButton(
      disabledColor: scheme.onSurface.withOpacity(0.12),
      color: scheme.primaryContainer,
      textColor: scheme.onPrimaryContainer,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed:onPressed,
      child: Text(
        label,
        style: style.titleMedium!.copyWith(
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
