

import 'package:english/cores/models/topic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/repositories/repository_provider.dart';

final topicProvider = FutureProvider.family<Topic,String>((ref,id) => ref.read(repositoryProvider).getTopic(id),);