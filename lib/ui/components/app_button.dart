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
      color: scheme.primary,
      textColor: onPressed != null? scheme.onPrimary: null,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed:onPressed,
      disabledTextColor:  scheme.outline,
      child: Text(
        label,
        style: style.titleMedium!.copyWith(
          color: onPressed!=null? scheme.onPrimary: scheme.outline,
        ),
      ),
    );
  }
}
