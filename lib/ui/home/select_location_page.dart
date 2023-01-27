// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meetups/core/providers/master_data_provider.dart';
// import 'package:meetups/core/repositories/repository_provider.dart';
// import 'package:meetups/ui/home/providers/location_provider.dart';

// class SelectLocationPage extends ConsumerWidget {
//   const SelectLocationPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Location"),
//       ),
//       body: ListView(
//         children: (ref.read(masterDataProvider).asData?.value.locations ?? [])
//             .map(
//               (e) => ListTile(
//                 onTap: (){
//                   ref.read(repositoryProvider).saveLocation(e);
//                   ref.read(locationProvider.notifier).state = e;
//                   if(Navigator.canPop(context)){
//                     Navigator.pop(context);
//                   }
//                 },
//                 title: Text(e),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
