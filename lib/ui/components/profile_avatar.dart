// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meetups/core/models/key_value.dart';
// import 'package:meetups/core/providers/image_provider.dart';
// import 'package:meetups/core/utils/buckets.dart';
// import 'package:meetups/core/utils/extensions.dart';

// import '../../core/models/profile.dart';

// class ProfileAvatar extends ConsumerWidget {
//   const ProfileAvatar({super.key, required this.profile, this.radius});
//   final Profile profile;
//   final double? radius;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final scheme = Theme.of(context).colorScheme;
//     final image = profile.image != null
//         ? ref
//             .watch(previewProvider(KeyValue(Buckets.profiles, profile.image!)))
//             .asData
//             ?.value
//         : null;
//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: scheme.tertiaryContainer,
//       backgroundImage: image,
//       child: image == null
//           ? Text(
//               profile.name.initial,
//               style: TextStyle(
//                 color: scheme.onTertiaryContainer,
//                 fontSize: radius,
//               ),
//             )
//           : null,
//     );
//   }
// }

// class ImageAvatar extends ConsumerWidget {
//   const ImageAvatar(
//       {super.key, required this.image, this.radius, this.name = ''});
//   final String image;
//   final double? radius;
//   final String name;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final scheme = Theme.of(context).colorScheme;
//     final memoryImage = ref
//         .watch(previewProvider(KeyValue(Buckets.profiles, image)))
//         .asData
//         ?.value;
//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: scheme.tertiaryContainer,
//       backgroundImage: memoryImage,
//       child: memoryImage == null
//           ? Text(
//               name.initial,
//               style: TextStyle(
//                 color: scheme.onTertiaryContainer,
//               ),
//             )
//           : null,
//     );
//   }
// }
