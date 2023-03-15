import 'package:english/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoLoading extends StatelessWidget {
  const LogoLoading({super.key, this.message});
  final String? message;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.logo, width: 100, height: 100),
            const SizedBox(height: 16),
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: kToolbarHeight),
          ],
        ),
      ),
    );
  }
}
