import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../cores/enums/payment_status.dart';
import '../../../cores/providers/loading_provider.dart';

/// rzp_test_bKZQVJWiOVcrR3
/// RkeKKFZKFzCmm7GNEJ4bp47o

final paymentViewModelProvider = Provider(
  (ref) => PaymentViewModel(ref),
);

class PaymentViewModel {
  final Ref _ref;
  PaymentViewModel(this._ref);

  Loading get _loading => _ref.read(loadingProvider);

  final _razorpay = Razorpay();


  PurchasesRepository get _repository => _ref.read(purchasesRepositoryProvider);

  void pay({
    required String oId,
    required int amount,
    required String email,
    required String name,
    required String phone,
    required Function(MapEntry<PaymentStatus, String> message) onDone,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse res) {
      _razorpay.clear();
      onDone(const MapEntry(PaymentStatus.success, "Payment Successful!"));
      _loading.end();
      _repository.updatePurchase(oId, {
        "paymentStatus": PaymentStatus.success.name,
        'paymentId': res.paymentId,
      });
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse res) {
      _razorpay.clear();
      onDone(const MapEntry(PaymentStatus.failed, "Payment Failed!"));
      _loading.end();
      _repository.updatePurchase(oId, {
        "paymentStatus": PaymentStatus.failed.name,
      });
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse res) {
      _repository.updatePurchase(oId, {
        "paymentMethod": res.walletName,
      });
    });

    var options = {
      'key': 'rzp_test_bKZQVJWiOVcrR3',
      'amount': amount * 100,
      'name': name,
      'description': '',
      'prefill': {
        'contact': phone,
        'email': email,
      }
    };
    _razorpay.open(options);
  }
}
