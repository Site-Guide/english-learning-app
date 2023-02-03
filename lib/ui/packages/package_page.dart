import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/courses/course_page.dart';
import 'package:english/utils/extensions.dart';
import 'package:english/utils/labels.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatelessWidget {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Package'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Image.asset(
              'assets/image1.webp',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ulitmate Fuancy Masterclass',
                  style:
                      style.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Effective cross-cultural communication, both verbal and non-verbal, is a powerful tool for career growth',
                  style: style.bodySmall,
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(
                    style: style.bodyLarge,
                    children: [
                      const TextSpan(
                        text: 'by',
                      ),
                      TextSpan(
                        text: ' Fancy Master',
                        style: style.titleMedium!.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text('16 Courses'),
                    Spacer(),
                    Icon(
                      Icons.watch_later_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text('52 Hours')
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '${Labels.rs}3,499',
                  style: style.headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                AppButton(
                  label: 'ENROLL',
                  onPressed: () {},
                ),
               
                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 0,bottom: 0),
                  child: Text(
                    'Courses Included',
                    style: style.titleMedium,
                  ),
                ),
                CourseCard3(),
                CourseCard3(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard3 extends StatelessWidget {
  const CourseCard3({super.key});

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
            builder: (context) => const CoursePage(),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        // width: media.size.width * 3 / 4,
        // decoration: const BoxDecoration().card(scheme),
        margin: const EdgeInsets.all(8),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'image1',
                      child: Image.asset(
                        'assets/image1.webp',
                        fit: BoxFit.cover,
                      ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '18 Sections',
                              style: style.bodySmall,
                            ),
                            Text('20 Hours')
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
