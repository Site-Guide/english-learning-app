import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  const BigButton(
      {Key? key,
      this.child,
      this.label,
      // this.arrow = false,
      this.onPressed,
      this.bottomFlat = false,
      this.color,
      this.textColor})
      : super(key: key);
  final Widget? child;
  // final bool arrow;
  final Function()? onPressed;
  final bool bottomFlat;
  final Color? color;
  final Color? textColor;
  final String? label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final backgroundColor = color ?? scheme.primary;
    return MaterialButton(
      minWidth: double.infinity,
      color: backgroundColor,
      onPressed: onPressed,
      textColor: textColor ?? scheme.onPrimary,
      disabledColor: backgroundColor.withOpacity(0.5),
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: bottomFlat
            ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )
            : BorderRadius.circular(12),
      ),
      child: child ?? Text(label ?? ""),
    );
  }
}
