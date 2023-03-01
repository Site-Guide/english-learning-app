import 'package:english/cores/models/topic.dart';
import 'package:flutter/material.dart';


class TopicCard extends StatelessWidget {
  const TopicCard({super.key,required this.topic});
  final Topic topic;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Container(
                                decoration: BoxDecoration(
                                  color: scheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      topic.topic,
                                      style: style.titleLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      topic.description,
                                    ),
                                  ],
                                ),
                              );
  }
}