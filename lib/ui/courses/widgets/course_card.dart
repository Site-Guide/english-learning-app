import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../course_page.dart';



class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoursePage()));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration().card(scheme),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset('assets/img.jpg', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    '30 Day Journal Challenge - Establish a Habit of Daily Journaling',
                    style: style.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2h 41m',
                        style: style.labelMedium,
                      ),
                      Text(
                        '37 Lessons',
                        style: style.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
