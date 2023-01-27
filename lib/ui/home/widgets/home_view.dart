import 'package:english/ui/home/widgets/discussion_topic_card.dart';
import 'package:english/utils/assets.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../courses/widgets/course_card.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        // title: Text("Hi, ${profile.name.split(' ').first}"),
        title: const Text("Hi, Shivkumar"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      bottomSheet: Material(
        color: scheme.secondaryContainer,
        child: ListTile(
          textColor: scheme.onSecondaryContainer,
          trailing:  Icon(
            Icons.play_arrow_rounded,
            size: 36,
            color: scheme.onSecondaryContainer,
          ),
          leading: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              'assets/img.jpg',
              fit: BoxFit.cover,
            ),
          ),
          title: const Text('2.  Choosing a Notebook'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kToolbarHeight + 16),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 5 / 2,
              child: Container(
                decoration: const BoxDecoration().card(scheme),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Discussions',
              style: style.titleMedium,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  DiscussionTopicCard(value: 'Interview'),
                  DiscussionTopicCard(value: 'Career'),
                  DiscussionTopicCard(value: 'Education'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Courses',
              style: style.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Sort by:',
                  style: style.bodyLarge,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      border: Border.all(
                        color: scheme.secondaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton(
                      iconEnabledColor: scheme.secondary,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      underline: const SizedBox(),
                      value: 'Popular',
                      style:
                          style.labelLarge!.copyWith(color: scheme.secondary),
                      items: ['Popular', 'Name', 'Price']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: scheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(
                        color: scheme.secondaryContainer,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text('Filters'),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CourseCard(),
          ),
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CourseCard(),
          ),
        ],
      ),
    );
  }
}
