// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class MeetWebPage extends StatefulWidget {
//   const MeetWebPage({super.key});

//   @override
//   State<MeetWebPage> createState() => _MeetWebPageState();
// }

// class _MeetWebPageState extends State<MeetWebPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Join Practice Call'),
//       ),
//       body: InAppWebView(
        
//         initialUrlRequest: URLRequest(
//           url: Uri.parse('https://jitsi.engexpert.in/shiv'),
//         ),
//         androidOnPermissionRequest: (controller, origin, resources) async {
//           return PermissionRequestResponse(
//             resources: resources,
//             action: PermissionRequestResponseAction.GRANT,
//           );
//         },
//       ),
//     );
//   }
// }
