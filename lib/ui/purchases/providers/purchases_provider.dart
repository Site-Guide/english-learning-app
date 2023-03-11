


import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:english/ui/auth/providers/user_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../cores/models/purchase.dart';

final purchasesProvider = FutureProvider<List<Purchase>>((ref) async {
  final user = await  ref.watch(userProvider.future);
  final repo = ref.read(purchasesRepositoryProvider);
  return repo.listPurchases(user.$id);
});