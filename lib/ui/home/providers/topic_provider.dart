import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/topic.dart';
import '../../../cores/repositories/repository_provider.dart';

final topicsProvider = FutureProvider<List<Topic>>(
  (ref) => ref.read(repositoryProvider).listTopics(),
);
