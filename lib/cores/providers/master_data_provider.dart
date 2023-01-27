import 'package:english/cores/providers/master_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/repository_provider.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref) => ref.read(repositoryProvider).getMasterData(),
);
