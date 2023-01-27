import 'package:flutter/material.dart';

import '../../utils/labels.dart';

class PickImageLabel extends StatelessWidget {
  const PickImageLabel({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 24,
          color: theme.dividerColor,
          child: Center(
            child: Text(
              Labels.pickImage.toUpperCase(),
              style: style.overline!.copyWith(
                color: theme.cardColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}