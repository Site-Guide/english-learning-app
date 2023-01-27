import 'dart:math';

import 'package:english/ui/components/big_button.dart';
import 'package:english/utils/extensions.dart';
import 'package:english/utils/labels.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('30 Day Journal Challenge...'),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16).copyWith(
      //       top: 0,
      //     ),
      //     child: BigButton(
      //       label: '${Labels.rs}999 ~ Buy now',
      //       onPressed: () {},
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(
            top: 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${Labels.rs}999',
                  style: style.headlineMedium,
                ),
              ),
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.all(16),
                  color: scheme.primary,
                  textColor: scheme.onPrimary,
                  child: Text('Buy now'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/img.jpg', fit: BoxFit.cover),
                    Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.play_circle_outline_outlined,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration().card(scheme),
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '30 Day Journal Challenge - Establish a Habit of Daily Journaling',
                    style: style.titleMedium,
                  ),
                ),
                const Divider(height: 0.5),
                const ListTile(
                  title: Text('37 Lessons (2h 41m)'),
                ),
                const Divider(height: 0.5),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  trailing: Text(
                    '2:16',
                    style: style.bodySmall!.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  leading: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    '1. Introduction',
                    style: style.bodyLarge,
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  trailing: Text(
                    '2:16',
                    style: style.bodySmall!.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  leading: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    '2.  Choosing a Notebook',
                    style: style.bodyLarge,
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  trailing: Text(
                    '2:16',
                    style: style.bodySmall!.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  leading: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    '3.  Adopting Prompts to Covid-19',
                    style: style.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // ClipPath(
              //   clipper: Half(),
              //   child: Container(
              //     height: 50,
              //     width: 50,
              //     color: scheme.primary,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
