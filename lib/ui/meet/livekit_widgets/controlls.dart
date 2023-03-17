// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:english/custom_color.g.dart';
import 'package:english/ui/meet/livekit_widgets/exts.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class ControlsWidget extends StatefulWidget {
  //
  final Room room;
  final LocalParticipant participant;

  const ControlsWidget(
    this.room,
    this.participant, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  //
  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });

    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    participant.removeListener(_onChange);
    super.dispose();
  }

  LocalParticipant get participant => widget.participant;

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  // void _unpublishAll() async {
  //   final result = await context.showUnPublishDialog();
  //   if (result == true) await participant.unpublishAllTracks();
  // }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(false);
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(true);
  }

  // void _selectAudioOutput(MediaDevice device) async {
  //   await widget.room.setAudioOutputDevice(device);
  //   setState(() {});
  // }

  // void _selectAudioInput(MediaDevice device) async {
  //   await widget.room.setAudioInputDevice(device);
  //   setState(() {});
  // }

  // void _selectVideoInput(MediaDevice device) async {
  //   await widget.room.setVideoInputDevice(device);
  //   setState(() {});
  // }

  // void _toggleCamera() async {
  //   //
  //   final track = participant.videoTracks.firstOrNull?.track;
  //   if (track == null) return;

  //   try {
  //     final newPosition = position.switched();
  //     await track.setCameraPosition(newPosition);
  //     setState(() {
  //       position = newPosition;
  //     });
  //   } catch (error) {
  //     print('could not restart track: $error');
  //     return;
  //   }
  // }

  // void _enableScreenShare() async {
  //   if (WebRTC.platformIsDesktop) {
  //     try {
  //       final source = await showDialog<DesktopCapturerSource>(
  //         context: context,
  //         builder: (context) => ScreenSelectDialog(),
  //       );
  //       if (source == null) {
  //         print('cancelled screenshare');
  //         return;
  //       }
  //       print('DesktopCapturerSource: ${source.id}');
  //       var track = await LocalVideoTrack.createScreenShareTrack(
  //         ScreenShareCaptureOptions(
  //           sourceId: source.id,
  //           maxFrameRate: 15.0,
  //         ),
  //       );
  //       await participant.publishVideoTrack(track);
  //     } catch (e) {
  //       print('could not publish video: $e');
  //     }
  //     return;
  //   }
  //   if (WebRTC.platformIsAndroid) {
  //     // Android specific
  //     requestBackgroundPermission([bool isRetry = false]) async {
  //       // Required for android screenshare.
  //       try {
  //         bool hasPermissions = await FlutterBackground.hasPermissions;
  //         if (!isRetry) {
  //           const androidConfig = FlutterBackgroundAndroidConfig(
  //             notificationTitle: 'Screen Sharing',
  //             notificationText: 'LiveKit Example is sharing the screen.',
  //             notificationImportance: AndroidNotificationImportance.Default,
  //             notificationIcon: AndroidResource(
  //                 name: 'livekit_ic_launcher', defType: 'mipmap'),
  //           );
  //           hasPermissions = await FlutterBackground.initialize(
  //               androidConfig: androidConfig);
  //         }
  //         if (hasPermissions &&
  //             !FlutterBackground.isBackgroundExecutionEnabled) {
  //           await FlutterBackground.enableBackgroundExecution();
  //         }
  //       } catch (e) {
  //         if (!isRetry) {
  //           return await Future<void>.delayed(const Duration(seconds: 1),
  //               () => requestBackgroundPermission(true));
  //         }
  //         print('could not publish video: $e');
  //       }
  //     }

  //     await requestBackgroundPermission();
  //   }
  //   if (WebRTC.platformIsIOS) {
  //     var track = await LocalVideoTrack.createScreenShareTrack(
  //       const ScreenShareCaptureOptions(
  //         useiOSBroadcastExtension: true,
  //         maxFrameRate: 15.0,
  //       ),
  //     );
  //     await participant.publishVideoTrack(track);
  //     return;
  //   }
  //   await participant.setScreenShareEnabled(true, captureScreenAudio: true);
  // }

  // void _disableScreenShare() async {
  //   await participant.setScreenShareEnabled(false);
  //   if (Platform.isAndroid) {
  //     // Android specific
  //     try {
  //       //   await FlutterBackground.disableBackgroundExecution();
  //     } catch (error) {
  //       print('error disabling screen share: $error');
  //     }
  //   }
  // }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  // void _onTapUpdateSubscribePermission() async {
  //   final result = await context.showSubscribePermissionDialog();
  //   if (result != null) {
  //     try {
  //       widget.room.localParticipant?.setTrackSubscriptionPermissions(
  //         allParticipantsAllowed: result,
  //       );
  //     } catch (error) {
  //       await context.showErrorDialog(error);
  //     }
  //   }
  // }

  // void _onTapSimulateScenario() async {
  //   final result = await context.showSimulateScenarioDialog();
  //   if (result != null) {
  //     await widget.room.sendSimulateScenario(
  //       signalReconnect:
  //           result == SimulateScenarioResult.signalReconnect ? true : null,
  //       nodeFailure: result == SimulateScenarioResult.nodeFailure ? true : null,
  //       migration: result == SimulateScenarioResult.migration ? true : null,
  //       serverLeave: result == SimulateScenarioResult.serverLeave ? true : null,
  //       switchCandidate:
  //           result == SimulateScenarioResult.switchCandidate ? true : null,
  //     );
  //   }
  // }

  void _onTapSendData() async {
    final result = await context.showSendDataDialog();
    if (result == true) {
      await widget.participant.publishData(
        utf8.encode('This is a sample data message'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          IconButton(
            iconSize: 32,
            color: colors.sourceRed,
            onPressed: _onTapDisconnect,
            icon: const Icon(EvaIcons.closeCircle),
            tooltip: 'Disconnect',
          ),
          const SizedBox(width: 16),

          if (participant.isMicrophoneEnabled())
            IconButton(
              iconSize: 32,
              onPressed: _disableAudio,
              icon: const Icon(EvaIcons.mic),
              tooltip: 'mute audio',
            )
          else
            IconButton(
              iconSize: 32,
              onPressed: _enableAudio,
              icon: const Icon(EvaIcons.micOff),
              tooltip: 'un-mute audio',
            ),
          const SizedBox(width: 16),
          if (participant.isCameraEnabled())
            IconButton(
              iconSize: 32,
              onPressed: _disableVideo,
              icon: const Icon(EvaIcons.video),
              tooltip: 'mute video',
            )
          else
            IconButton(
              iconSize: 32,
              onPressed: _enableVideo,
              icon: const Icon(EvaIcons.videoOff),
              tooltip: 'un-mute video',
            ),
          // IconButton(
          //   onPressed: _onTapSendData,
          //   icon: const Icon(EvaIcons.paperPlane),
          //   tooltip: 'send demo data',
          // ),
        ],
      ),
    );
  }
}
