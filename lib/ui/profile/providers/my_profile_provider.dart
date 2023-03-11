import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/repositories/repository_provider.dart';
import '../../auth/providers/user_provider.dart';

final profileProvider = FutureProvider((ref) async {
  final repository = ref.read(repositoryProvider);
  final account = await ref.watch(userProvider.future);
  return repository.getProfile(account.$id);
});
