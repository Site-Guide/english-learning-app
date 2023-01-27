import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/profile.dart';
import '../../../cores/repositories/repository_provider.dart';



final profileInfoProvider = FutureProvider.family<Profile,String>((ref,id) async {
  return ref.read(repositoryProvider).getProfile(id);
});