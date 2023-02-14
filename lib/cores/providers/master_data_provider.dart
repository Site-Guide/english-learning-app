import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/master_data.dart';
import '../repositories/repository_provider.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref) => ref.read(repositoryProvider).getMasterData(),
);
