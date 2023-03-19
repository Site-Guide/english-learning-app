import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NoVideoWidget extends StatelessWidget {
  //
  const NoVideoWidget({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
        alignment: Alignment.center,
        color: scheme.surfaceVariant,
        child: LayoutBuilder(
          builder: (ctx, constraints) => name.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.1,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Icon(
                  EvaIcons.videoOffOutline,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  size: math.min(constraints.maxHeight, constraints.maxWidth) *
                      0.3,
                ),
        ),
      );
  }
}
