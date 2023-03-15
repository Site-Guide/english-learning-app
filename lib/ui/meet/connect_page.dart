// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/meet/live_widgets/exts.dart';
import 'package:english/ui/meet/room_page.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class ConnectPage extends StatefulWidget {
  //
  const ConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  ///APIGCEhZQShxedT
  ///93Osfni47JoSXuDo4Y42TpM7FmVxSrRExlL1hmaiDoS
  final _uriCtrl = "//test-app-qw3z9e1f.livekit.cloud";
  final _tokenCtrl = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2Nzg5NzQ0NjYsImlzcyI6IkFQSUNXa1ZYQ2c4SEc1VSIsIm5iZiI6MTY3ODg4NDQ2Niwic3ViIjoiQW1pdCIsInZpZGVvIjp7ImNhblB1Ymxpc2giOnRydWUsImNhblB1Ymxpc2hEYXRhIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWUsInJvb20iOiJ0ZXN0NCIsInJvb21Kb2luIjp0cnVlfX0.VDkE659fuf8t9-ze_aTdByU6cE8Ja4O9QYm_xSFL2PM';
  bool _simulcast = true;
  bool _adaptiveStream = true;
  bool _dynacast = true;
  bool _busy = false;
  bool _fastConnect = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _connect(BuildContext ctx) async {
    //
    try {
      setState(() {
        _busy = true;
      });

      //create new room
      final room = Room();

      // Create a Listener before connecting
      final listener = room.createListener();

      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        _uriCtrl,
        _tokenCtrl,
        roomOptions: RoomOptions(
          adaptiveStream: _adaptiveStream,
          dynacast: _dynacast,
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: _simulcast,
          ),
          defaultScreenShareCaptureOptions:
              const ScreenShareCaptureOptions(useiOSBroadcastExtension: true),
        ),
        fastConnectOptions: _fastConnect
            ? FastConnectOptions(
                microphone: const TrackOption(enabled: true),
                camera: const TrackOption(enabled: true),
              )
            : null,
      );
      await Navigator.push<void>(
        ctx,
        MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
      );
    } catch (error) {
      print('Could not connect $error');
      await ctx.showErrorDialog(error);
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _busy ? null : () => _connect(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_busy)
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        const Text('CONNECT'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
