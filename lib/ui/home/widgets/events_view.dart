// // ignore_for_file: unused_result

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meetups/core/providers/master_data_provider.dart';
// import 'package:meetups/ui/events/widgets/event_card.dart';
// import 'package:meetups/ui/home/widgets/search_bar.dart';
// import 'package:meetups/utils/extensions.dart';

// import '../../events/providers/events_view_model.dart';

// class EventsView extends ConsumerWidget {
//   const EventsView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final scheme = theme.colorScheme;
//     final style = theme.textTheme;
//     final provider = eventsViewModelProvider;
//     final masterData = ref.read(masterDataProvider).value!;
//     final model = ref.watch(provider);

//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         if (!model.busy &&
//             notification.metrics.pixels ==
//                 notification.metrics.maxScrollExtent) {
//           model.loadMore();
//         }
//         return true;
//       },
//       child: RefreshIndicator(
//         onRefresh: () async {
//           model.load();
//         },
//         child: CustomScrollView(
//           slivers: [
//             SliverPadding(
//               padding: EdgeInsets.zero.copyWith(bottom: 8 + kToolbarHeight),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const SearchBar(),
//                   SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Row(
//                       children: ["All", ...masterData.types].map(
//                         (e) {
//                           final selected = (model.type == e.type ||
//                               (model.type == null && e == "All"));
//                           return GestureDetector(
//                             onTap: () {
//                               if (e == "All") {
//                                 model.type = null;
//                               } else {
//                                 model.type = e.type;
//                               }
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 4),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               decoration: ShapeDecoration(
//                                 color: selected
//                                     ? scheme.tertiary
//                                     : scheme.tertiaryContainer
//                                         .withOpacity(0.75),
//                                 shape: const StadiumBorder(),
//                               ),
//                               child: Text(
//                                 e.types,
//                                 style: TextStyle(
//                                   color: selected
//                                       ? scheme.onTertiary
//                                       : scheme.onTertiaryContainer,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ).toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ...model.events.isEmpty
//                       ? [
//                           model.events.isEmpty && model.busy
//                               ? const Center(
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: AspectRatio(
//                                     aspectRatio: 1,
//                                     child: Center(
//                                       child: Text(
//                                         "No events available!",
//                                         textAlign: TextAlign.center,
//                                         style: style.titleMedium,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                         ]
//                       : model.events
//                           .map(
//                             (e) => EventCard(
//                               event: e,
//                             ),
//                           )
//                           .toList(),
//                 ]),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: model.loading && model.events.length >= 8
//                   ? const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : const SizedBox(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
