
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


// final clientProvider = Provider<Client>(
//   (ref)  {
//     final channel = Client(
//       endPoint: 'https://appwrite.lexci.in/v1',
//     );
//     channel.setProject('63aed6beb5b9b8f7dc4f');
//     channel.setSelfSigned();
//     return channel;
//   },
// );



final clientProvider = Provider<Client>(
  (ref)  {
    final channel = Client(
      endPoint: "http://appwrite.engexpert.in/v1",
    );
    channel.setProject("63ca393fc7b7f28ab286");
    channel.setSelfSigned();
    return channel;
  },
);