import 'package:english/cores/models/meet_session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';

final myTodaysCompletedMeetsProvider = FutureProvider.autoDispose<List<MeetSession>>(
  (ref) => ref.read(meetRepositoryProvider).listMyTodaysCompletedMeets(
        ref.read(userProvider).value!.$id,
      ),
);
