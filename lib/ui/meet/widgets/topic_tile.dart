import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/topic.dart';
import '../../../cores/providers/master_data_provider.dart';
import '../../components/snackbar.dart';
import '../../purchases/providers/purchases_provider.dart';
import '../meet_init_page.dart';
import '../providers/handler_provider.dart';
import '../providers/my_attempts_today_provider.dart';

class TopicTile extends ConsumerWidget {
  const TopicTile({super.key, required this.topic, this.isElegible = true});

  final Topic topic;
  final bool isElegible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final model = ref.read(meetHandlerProvider);
    final masterData = ref.read(masterDataProvider).value!;

    final style = theme.textTheme.apply(
      bodyColor:
          isElegible ? theme.colorScheme.onSurface : theme.colorScheme.outline,
    );

    final purchases = ref
            .read(purchasesProvider)
            .asData
            ?.value
            .where((element) => element.typeId == topic.courseId) ??
        [];
    final purchase = purchases.isNotEmpty ? purchases.first : null;
    final scheme = theme.colorScheme;
    return GestureDetector(
      onTap: () async {
        if (isElegible) {
          final attemts = await ref.read(requestsProvider.future);
          if (attemts.length >= model.dailyLimit) {
            AppSnackbar(context).message(
              "You have reached your daily limit of ${model.dailyLimit} practice calls. Please try again tomorrow.",
            );
            return;
          } else {
            model.selectedTopic = topic;
            Navigator.pushNamed(context, MeetInitPage.route);
          }
        } else {
          if (purchase != null && purchase.isExpired) {
            AppSnackbar(context).message(
              "You have used all call credits for this course",
            );
            return;
          }
          print(purchase?.isExpired);
          if (topic.courseId != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: scheme.surface,
                surfaceTintColor: scheme.surface,
                title: const Text(
                  "You haven't purchased this course",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: scheme.primaryContainer,
                    textColor: scheme.onPrimaryContainer,
                    onPressed: () async {},
                    child: const Text("Purchase Now"),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: scheme.surface,
                surfaceTintColor: scheme.surface,
                title: const Text(
                  "You haven't call credits for this topic",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: scheme.primaryContainer,
                    textColor: scheme.onPrimaryContainer,
                    onPressed: () async {},
                    child: const Text("Purchase Credits"),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isElegible ? scheme.outline : scheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topic.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: style.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (topic.courseName != null) ...[
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "By",
                    style: style.bodySmall,
                    children: [
                      TextSpan(
                        text: " ${topic.courseName}",
                        style: style.bodySmall!.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const TextSpan(
                        text: " course",
                      ),
                    ],
                  ),
                ),
              ],
              if (purchase != null) ...[
                const SizedBox(height: 8),
                Text(
                  "${purchase.callsDone}/${purchase.calls}",
                  style: style.titleMedium!.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "calls done",
                  style: style.bodySmall,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}




// class TopicTile extends ConsumerWidget {
//   const TopicTile({super.key, required this.topic, this.isElegible = true});

//   final Topic topic;
//   final bool isElegible;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final model = ref.read(meetHandlerProvider);
//     final masterData = ref.read(masterDataProvider).value!;

//     final style = theme.textTheme.apply(
//       bodyColor:
//           isElegible ? theme.colorScheme.onSurface : theme.colorScheme.outline,
//     );

//     final purchases = ref
//             .read(purchasesProvider)
//             .asData
//             ?.value
//             .where((element) => element.typeId == topic.courseId) ??
//         [];
//     final purchase = purchases.isNotEmpty ? purchases.first : null;
//     final scheme = theme.colorScheme;
//     return GestureDetector(
//       onTap: () async {
//         if (isElegible) {
//           final attemts = await ref.read(myAttemtsTodayProvider.future);
//           if (attemts.length >= model.dailyLimit) {
//             AppSnackbar(context).message(
//               "You have reached your daily limit of ${model.dailyLimit} practice calls. Please try again tomorrow.",
//             );
//             return;
//           } else {
//             model.selectedTopic = topic;
//             Navigator.pushNamed(context, MeetInitPage.route);
//           }
//         } else {
//           if (purchase != null && purchase.isExpired) {
//             AppSnackbar(context).message(
//               "You have used all call credits for this course",
//             );
//             return;
//           }
//           print(purchase?.isExpired);
//           if (topic.courseId != null) {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 backgroundColor: scheme.surface,
//                 surfaceTintColor: scheme.surface,
//                 title: const Text(
//                   "You haven't purchased this course",
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Cancel"),
//                   ),
//                   MaterialButton(
//                     color: scheme.primaryContainer,
//                     textColor: scheme.onPrimaryContainer,
//                     onPressed: () async {},
//                     child: const Text("Purchase Now"),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 backgroundColor: scheme.surface,
//                 surfaceTintColor: scheme.surface,
//                 title: const Text(
//                   "You haven't call credits for this topic",
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Cancel"),
//                   ),
//                   MaterialButton(
//                     color: scheme.primaryContainer,
//                     textColor: scheme.onPrimaryContainer,
//                     onPressed: () async {},
//                     child: const Text("Purchase Credits"),
//                   ),
//                 ],
//               ),
//             );
//           }
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: isElegible ? scheme.outline : scheme.outlineVariant,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: EdgeInsets.zero,
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               topic.name,
//               style: style.titleMedium,
//             ),
//             if (topic.courseName != null) ...[
//               const SizedBox(height: 8),
//               RichText(
//                 text: TextSpan(
//                   text: "By",
//                   style: style.bodySmall,
//                   children: [
//                     TextSpan(
//                       text: " ${topic.courseName}",
//                       style: style.bodySmall!.copyWith(
//                         color: scheme.primary,
//                       ),
//                     ),
//                     const TextSpan(
//                       text: " course",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             if (purchase != null) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Text(
//                     "${purchase.callsDone}/${purchase.calls}",
//                     style: style.titleMedium!.copyWith(
//                       color: scheme.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "calls done",
//                     style: style.bodySmall,
//                   ),
//                 ],
//               )
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }

