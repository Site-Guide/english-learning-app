// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meetups/core/providers/master_data_provider.dart';
// import 'package:meetups/core/repositories/repository_provider.dart';
// import 'package:meetups/core/utils/constants.dart';
// import 'package:meetups/ui/auth/providers/cache_provider.dart';

// final locationProvider = StateProvider<String?>(
//   (ref) {
//     final location = ref.read(cacheProvider).value!.getString(Constants.location);
//     final locations = ref.read(masterDataProvider).value!.locations;
//     if(locations.length==1 && location == null){
//       ref.read(repositoryProvider).saveLocation(locations.first);
//       return locations.first;
//     }
//     return location;
//   }
// );
