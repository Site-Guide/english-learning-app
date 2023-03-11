import 'package:english/cores/repositories/app_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/master_data.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref) => ref.read(appRepositoryProvider).getMasterData(),
);
