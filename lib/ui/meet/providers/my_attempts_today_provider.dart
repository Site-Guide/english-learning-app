import 'package:english/cores/models/call_request.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/repositories/meet_repository_provider.dart';
import '../../auth/providers/user_provider.dart';

final requestsProvider = FutureProvider.autoDispose<List<CallRequest>>(
  (ref) => ref.read(meetRepositoryProvider).listMyAttemtsToday(
        ref.read(userProvider).value!.$id,
      ),
);
