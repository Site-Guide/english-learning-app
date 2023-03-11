import 'package:english/cores/models/plan.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    this.selected = false,
    this.onTap,
  });

  final Plan plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme.apply(
      bodyColor: selected ? scheme.onPrimaryContainer : scheme.onSurface,
    );

    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name,
            style: style.titleMedium!.copyWith(
              color: scheme.primary,
            ),
          ),
          if (plan.description != null) ...[
            const SizedBox(height: 4),
            Text(
              plan.description!,
              style: style.bodySmall,
            ),
          ],
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: plan.price.asRupee,
              style: style.headlineLarge,
              children: [
                TextSpan(
                  text: '/ ${plan.calls} call',
                  style: style.titleMedium!.copyWith(
                    color: scheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Valid upto ${plan.duration} days",
            style: style.bodyMedium,
          ),
        ],
      ),
    );
    return Theme(
      data: theme.copyWith(
        textTheme: style,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? scheme.primaryContainer : scheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? scheme.primaryContainer : scheme.outline,
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
