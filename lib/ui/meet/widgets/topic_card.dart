import 'package:english/cores/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class TopicCard extends StatelessWidget {
  const TopicCard(
      {super.key,
      required this.topic,
      this.selected = false,
      this.onTap,
      this.noTap = false});
  final Topic topic;
  final bool selected;
  final VoidCallback? onTap;
  final bool noTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : null,
          border: selected
              ? null
              : Border.all(
                  color: scheme.outline,
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: noTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onTap != null && !noTap) ...[
                    selected
                        ? Icon(
                            Icons.radio_button_checked_rounded,
                            color: scheme.primary,
                          )
                        : Icon(
                            Icons.radio_button_off_rounded,
                            color: scheme.outline,
                          ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    topic.name,
                    style: style.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ReadMoreText(
                topic.description,
                trimLines: 2,
                style: style.bodySmall,
                trimLength: 100,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                lessStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
                moreStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
