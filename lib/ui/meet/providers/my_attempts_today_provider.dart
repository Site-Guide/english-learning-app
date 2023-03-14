import 'package:english/cores/models/attempt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';

final myAttemtsTodayProvider = FutureProvider.autoDispose<List<Attempt>>(
  (ref) => ref.read(meetRepositoryProvider).listMyAttemtsToday(
        ref.read(userProvider).value!.$id,
      ),
);