import 'package:appwrite/models.dart';
import 'package:english/cores/enums/payment_status.dart';
import 'package:english/cores/enums/purchase_type.dart';

class Purchase {
  final String id;
  final PurchaseType type;
  final String typeId;
  final DateTime start;
  final DateTime? end;
  final int calls;
  final int callsDone;
  final int amount;
  final String? paymentId;
  final PaymentStatus paymentStatus;
  final String uid;
  final bool expired;

  bool get isExpired => (end?.isBefore(DateTime.now()) ?? false) && (callsDone >= calls);

  Purchase({
    required this.id,
    required this.type,
    required this.typeId,
    required this.start,
    required this.end,
    required this.calls,
    required this.callsDone,
    required this.amount,
     this.paymentId,
    required this.paymentStatus,
     this.expired = false,
      required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'typeId': typeId,
      'start': start.toString(),
      'end': end.toString(),
      'calls': calls,
      'callsDone': callsDone,
      'amount': amount,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus.name,
      'expired': expired,
      'uid': uid,
    };
  }

  factory Purchase.fromMap(Document doc) {
    final map = doc.data;
    return Purchase(
      id: doc.$id,
      type: PurchaseType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PurchaseType.plan,
      ),
      typeId: map['typeId'] ?? '',
      start: DateTime.parse(map['start']),
      end: map['end']!= null? DateTime.parse(map['end']): null,
      calls: map['calls']?.toInt() ?? 0,
      callsDone: map['callsDone']?.toInt() ?? 0,
      amount: map['amount']?.toInt() ?? 0,
      paymentId: map['paymentId'] ?? '',
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == map['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      expired: map['expired'] ?? false,
      uid: map['uid'] ?? '',
    );
  }
}
