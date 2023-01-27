// import 'dart:io';

// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class MyFiles {
//   static Future<File?> pickAndCrop([double? aspectRatio]) async {
//     try {
//       final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (file != null) {
//         CroppedFile? croppedFile = await ImageCropper().cropImage(
//           maxHeight: 512,
//           maxWidth: 512,
//           sourcePath: file.path,
//           aspectRatio: CropAspectRatio(
//               ratioX: aspectRatio ?? 1,
//               ratioY: (aspectRatio != null ? 1 : null) ?? 1),
//           uiSettings: [],
//         );
//         return croppedFile != null ? File(croppedFile.path) : null;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return null;
//   }
// }
