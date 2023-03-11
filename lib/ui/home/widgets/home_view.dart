import 'package:english/cores/providers/master_data_provider.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/home/providers/topic_provider.dart';
import 'package:english/ui/home/widgets/timing_view.dart';
import 'package:english/ui/meet/meet_init_page.dart';
import 'package:english/ui/packages/package_page.dart';
import 'package:english/utils/extensions.dart';
import 'package:english/utils/formats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: scheme.surfaceVariant,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme
            .onSurfaceVariant, // title: Text("Hi, ${profile.name.split(' ').first}"),
        title: const Text("Hi, Shivkumar"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kToolbarHeight + 16),
        children: [
          AsyncWidget(
            value: ref.watch(masterDataProvider),
            data: (data) {
              return AsyncWidget(
                value: ref.watch(topicsProvider),
                data: (topic) => topic.isNotEmpty && data.activeSlots.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.all(16).copyWith(bottom: 8),
                            child: Text(
                              'English Speaking Practice Call',
                              style: style.titleMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, MeetInitPage.route);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16)
                                  .copyWith(bottom: 0),
                              decoration: const BoxDecoration().card(scheme),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12)
                                            .copyWith(bottom: 4),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'On',
                                            style: TextStyle(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: ' ${topic.first.name}',
                                                  style: style.titleMedium),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TimingView(
                                        timing: data.activeSlots,
                                        small: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 8),
            child: Text(
              'Continue Learning',
              style: style.titleMedium,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            height: 72,
            decoration: const BoxDecoration().card(scheme),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/image1.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'How to speak fluently?',
                            style: style.titleMedium,
                          ),
                          Text(
                            '1 hours, 30 min',
                            style: style.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: scheme.primaryContainer,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 32,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            value: 0.5,
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search courses',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.clear),
                      // ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Text(
          //     'Discussions',
          //     style: style.titleMedium,
          //   ),
          // ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     child: Row(
          //       children: const [
          //         DiscussionTopicCard(value: 'Interview'),
          //         DiscussionTopicCard(value: 'Career'),
          //         DiscussionTopicCard(value: 'Education'),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Courses',
                  style: style.titleMedium,
                ),
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  child: Text('See All'),
                  onPressed: () {},
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                CourseCard2(),
                CourseCard2(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Best Course Packages for you',
                  style: style.titleMedium,
                ),
                // CupertinoButton(
                //   padding: EdgeInsets.all(0),
                //   child: Text('See All'),
                //   onPressed: () {},
                // )
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            childAspectRatio: 0.75,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              PackageCard(),
              PackageCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PackagePage()));
      },
      child: Container(
        decoration: const BoxDecoration().card(scheme).copyWith(
              image: const DecorationImage(
                image: AssetImage('assets/image1.webp'),
                fit: BoxFit.cover,
              ),
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration().card(scheme).copyWith(),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Text(
                'How to speak fluently?',
                style: style.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard2 extends StatelessWidget {
  const CourseCard2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PackagePage(),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: media.size.width * 3 / 4,
        decoration: const BoxDecoration().card(scheme),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/image1.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ultimate Fluancy Masterclass',
                          style: style.titleMedium,
                        ),
                        Text(
                          '12 Courses',
                          style: style.bodySmall,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.tertiary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'PACKAGE',
                  style: style.labelMedium!.copyWith(color: scheme.onTertiary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
