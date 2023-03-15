import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionsStreamProvider = StreamProvider<List<MeetSession>>(
  (ref) => ref.read(meetRepositoryProvider).streamMeetSessions(),
);
