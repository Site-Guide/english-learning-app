import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';

class DiscussionTopicCard extends StatelessWidget {
  const DiscussionTopicCard({super.key,required this.value});
  
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration().card(scheme),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            value,
            style: style.bodyLarge!.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: scheme.outline.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
