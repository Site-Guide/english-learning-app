// import 'package:crypto/crypto.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meetups/ui/events/providers/events_view_model.dart';
// import 'package:meetups/utils/dates.dart';
// import 'package:meetups/utils/formats.dart';

// class SearchBar extends HookConsumerWidget {
//   const SearchBar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final scheme = theme.colorScheme;
//     final style = theme.textTheme;
//     final controller = useTextEditingController();
//     final model = ref.watch(eventsViewModelProvider);
//     final clearable = useState(false);
//     controller.addListener(() {
//       if (controller.text.isEmpty && clearable.value) {
//         clearable.value = false;
//       } else if (controller.text.isNotEmpty && !clearable.value) {
//         clearable.value = true;
//       }
//     });

//     void pickDate() async {
//       final date = await showDatePicker(
//         context: context,
//         initialDate: model.date ?? Dates.today,
//         firstDate: Dates.today,
//         lastDate: Dates.today.add(
//           const Duration(days: 30),
//         ),
//       );
//       if (date != null) {
//         model.date = date;
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   color: theme.cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: scheme.primaryContainer,
//                       // blurRadius: 8,
//                       offset: Offset(4, 4),
//                     ),
//                   ]),
//               child: TextField(
//                 controller: controller,
//                 onTap: () {},
//                 onSubmitted: (v) {},
//                 onChanged: (v) => model.debouncer.value = v,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: const Icon(Icons.search),
//                   hintText: "Search Event, Workshops, Party",
//                   suffixIcon: clearable.value
//                       ? IconButton(
//                           color: scheme.primary,
//                           onPressed: () {
//                             controller.text = '';
//                             model.debouncer.value = '';
//                           },
//                           icon: const Icon(
//                             Icons.clear,
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: model.date != null
//                 ? Row(
//                   children: [
//                     GestureDetector(
//                       onTap: pickDate,
//                       child: Container(
//                         height: 48,
//                         width: 48 * 2,
//                         decoration: BoxDecoration(
//                           color: theme.cardColor,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: scheme.secondaryContainer,
//                               offset: const Offset(4, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     model.date!.monthLabel,
//                                     style: style.bodySmall,
//                                   ),
//                                   Text(
//                                     '${model.date!.day}',
//                                     style: TextStyle(
//                                         color:
//                                             scheme.onSecondaryContainer),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: IconButton(
//                                 color: scheme.secondary.withOpacity(0.75),
//                                 onPressed: () {
//                                   model.date = null;
//                                 },
//                                 icon: const Icon(Icons.clear_rounded),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//                 : SizedBox(
//                     width: 48,
//                     height: 48,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         backgroundColor: scheme.secondaryContainer,
//                         foregroundColor: scheme.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: pickDate,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           const Icon(
//                             Icons.calendar_month_outlined,
//                             size: 28,
//                           ),
//                           Transform.translate(
//                             offset: const Offset(8, 8),
//                             child: Icon(
//                               Icons.filter_alt,
//                               color: scheme.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//           )
//         ],
//       ),
//     );
//   }
// }
