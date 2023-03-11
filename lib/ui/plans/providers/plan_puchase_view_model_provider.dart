import 'package:english/cores/enums/payment_status.dart';
import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/plan.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/providers/loading_provider.dart';
import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:english/ui/plans/providers/payment_view_model_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../profile/providers/my_profile_provider.dart';

final planPurchaseViewModelProvider =
    ChangeNotifierProvider<PlanPurchaseViewModel>((ref) {
  return PlanPurchaseViewModel(ref);
});

class PlanPurchaseViewModel extends ChangeNotifier {
  final Ref _ref;
  PlanPurchaseViewModel(this._ref);

  Plan? _plan;
  Plan? get plan => _plan;
  set plan(Plan? value) {
    _plan = value;
    notifyListeners();
  }

  Loading get _loading => _ref.read(loadingProvider);

  Future<void> purchase(
      {required Function(MapEntry<PaymentStatus, String> message)
          onDone}) async {
    _loading.start();
    try {
      final profile = await _ref.read(profileProvider.future);
      final purchase = Purchase(
        id: '',
        type: PurchaseType.plan,
        typeId: plan!.id,
        start: DateTime.now(),
        end: DateTime.now().add(
          Duration(days: plan!.duration),
        ),
        calls: plan!.calls,
        callsDone: 0,
        amount: plan!.price,
        paymentStatus: PaymentStatus.pending,
        uid: profile.id,
      );
      final String id =
          await _ref.read(purchasesRepositoryProvider).createPurchase(purchase);

      _ref.read(paymentViewModelProvider).pay(
            oId: id,
            amount: plan!.price,
            email: profile.email,
            name: "${plan!.name} plan",
            phone: profile.phone,
            onDone: onDone,
          );
    } catch (e) {
      print(e);
      _loading.stop();
    }
  }
}
