import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key,  this.label = ''});
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Coming Soon",
            style: style.headlineSmall,
          ),
        ),
      ),
    );
  }
}
