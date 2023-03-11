

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/plan.dart';
import '../../../cores/repositories/app_repository_provider.dart';

final plansProvider = FutureProvider<List<Plan>>((ref) => ref.watch(appRepositoryProvider).listPlans());