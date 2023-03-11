import 'package:english/cores/models/master_data.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/material.dart';

class TimingView extends StatelessWidget {
  const TimingView({super.key, required this.timing, this.small = false});

  final List<Timing> timing;
  final bool small;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return SingleChildScrollView(
      padding: small
          ? const EdgeInsets.all(12).copyWith(top: 4)
          : const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 0,
            ),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (small)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'At',
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ...timing
              .map(
                (e) => Container(
                  margin: const EdgeInsets.all(4),
                  padding: small
                      ? const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                  decoration: ShapeDecoration(
                    color: e.now ? scheme.primary : null,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: e.now ? scheme.primary : scheme.outline,
                      ),
                    ),
                  ),
                  child: Text(
                    e.label,
                    style:
                        (small ? style.bodySmall : style.bodyMedium)!.copyWith(
                      color: e.now ? scheme.onPrimary : null,
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
