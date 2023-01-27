// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'my_files.dart';
// import 'pick_image_label.dart';

// class ImagePickerView extends StatelessWidget {
//   const ImagePickerView({
//     Key? key,
//     this.file,
//     this.image,
//     required this.onPick,
//     this.stretch = false,
//     this.fit,
//     this.flex,
//     this.expanded = true,
//     this.aspectRatio,
//   }) : super(key: key);

//   final ValueChanged<File> onPick;
//   final MemoryImage? image;
//   final File? file;
//   final bool stretch;
//   final BoxFit? fit;
//   final int? flex;
//   final bool expanded;
//   final double? aspectRatio;
//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     final picker = Row(
//         children: [
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: aspectRatio?? 1,
//               child: GestureDetector(
//                 onTap: () async {
//                   final File? pickedFile = await MyFiles.pickAndCrop(aspectRatio);
//                   if (pickedFile != null) {
//                     onPick(pickedFile);
//                   }
//                 },
//                 child: Container(
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: scheme.tertiaryContainer,
//                     borderRadius: BorderRadius.circular(12),
//                     image: file != null || image != null
//                         ? DecorationImage(
//                             image: file != null
//                                 ? FileImage(file!)
//                                 : image as ImageProvider,
//                             fit: fit ?? BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       PickImageLabel(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     final child = Expanded(
//       flex: flex??1,
//       child: picker
//     );
//     return expanded? child:picker;
//   }
// }
