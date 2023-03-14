import 'package:appwrite/models.dart';

class RazorpayPurchase {
  final String id;
  final String email;
  final String paymentId;
  final int amount;

  
  RazorpayPurchase({
    required this.id,
    required this.email,
    required this.paymentId,
    required this.amount,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'email': email,
  //     'paymentId': paymentId,
  //     'amount': amount,
  //   };
  // }

  factory RazorpayPurchase.fromMap(Document doc) {
    final map = doc.data;
    return RazorpayPurchase(
      id: doc.$id,
      email: map['email'] ?? '',
      paymentId: map['paymentId'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
    );
  }
}
