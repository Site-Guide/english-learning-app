

import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/repositories/meet_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final meetsProvider = StreamProvider.autoDispose<List<MeetSession>>((ref) {
  return ref.watch(meetRepositoryProvider).streamMeetSessions();
});