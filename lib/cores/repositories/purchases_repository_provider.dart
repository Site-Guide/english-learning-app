import 'package:appwrite/appwrite.dart';
import 'package:english/cores/enums/payment_status.dart';
import 'package:english/cores/enums/purchase_type.dart';
import 'package:english/cores/models/razorpay_purchase.dart';
import 'package:english/ui/auth/providers/user_provider.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/dates.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/course.dart';
import '../models/purchase.dart';
import '../providers/db_provider.dart';
import '../utils/ids.dart';

final purchasesRepositoryProvider =
    Provider.autoDispose<PurchasesRepository>((ref) {
  return PurchasesRepository(ref);
});

class PurchasesRepository {
  final Ref _ref;

  PurchasesRepository(this._ref);

  Databases get _db => _ref.read(dbProvider);

  Future<String> createPurchase(Purchase purchase) async {
    return (await _db.createDocument(
      databaseId: DBs.main,
      documentId: ID.unique(),
      collectionId: Collections.purchases,
      data: purchase.toMap(),
    ))
        .$id;
  }

  Future<void> updatePurchase(String id, Map<String, dynamic> map) async {
    await _db.updateDocument(
      databaseId: DBs.main,
      documentId: id,
      collectionId: Collections.purchases,
      data: map,
    );
  }

  Future<List<Purchase>> listPurchases(String uid) async {
    final response = await _db.listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.purchases,
        queries: [
          Query.equal('uid', uid),
          Query.equal('expired', false),
        ]);

    return response.documents
        .map(
          (e) => Purchase.fromMap(e),
        )
        .toList();
  }

  Future<void> increamentCallsDone(String id) async {
    try {
      final purchases = await _ref.read(purchasesProvider.future);
      final filtered = purchases.where((element) => element.id == id).toList();
      late Purchase purchase;
      if (filtered.isNotEmpty) {
        purchase = filtered.first;
      } else {
        final response = await _db.getDocument(
          databaseId: DBs.main,
          documentId: id,
          collectionId: Collections.purchases,
        );
        purchase = Purchase.fromMap(response);
      }
      print('purchase: ${purchase.toMap()}');
      purchase.callsDone++;
      await _db.updateDocument(
          databaseId: DBs.main,
          documentId: purchase.id,
          collectionId: Collections.purchases,
          data: {
            'callsDone': purchase.callsDone,
          });
      _ref.refresh(purchasesProvider);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteRazorpayPurchase(String id) async {
    await _db.deleteDocument(
      databaseId: DBs.main,
      documentId: id,
      collectionId: Collections.razorpayPurchases,
    );
  }

  Future<void> initPurchases() async {
    final user = await _ref.read(userProvider.future);
    final response = await _db.listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.razorpayPurchases,
        queries: [
          Query.equal('email', user.email),
        ]);
    print('razorpay purchases: ${response.documents.length}');
    final puchases = response.documents
        .map(
          (e) => RazorpayPurchase.fromMap(e),
        )
        .toList();

    for (final purchase in puchases) {
      try {
        final courses = await _db.listDocuments(
          databaseId: DBs.main,
          collectionId: Collections.courses,
          queries: [
            Query.equal('price', purchase.amount),
          ],
        );
        print('courses: ${courses.documents.length}');
        if (courses.documents.isEmpty) {
          continue;
        }

        final course = Course.fromMap(courses.documents.first);
        final updated = Purchase(
          id: '',
          type: PurchaseType.course,
          typeId: course.id,
          start: Dates.now,
          end: Dates.now.add(Duration(days: course.duration)),
          calls: course.calls,
          callsDone: 0,
          amount: course.price,
          paymentStatus: PaymentStatus.success,
          uid: user.$id,
        );
        await createPurchase(updated);
        print('purchase created: ${updated.id}');
        await deleteRazorpayPurchase(purchase.id);
        print('razorpay purchase deleted: ${purchase.id}');
      } catch (e) {
        print('sync error: $e');
      }
    }
    if (puchases.isNotEmpty) {
      _ref.refresh(purchasesProvider);
    }
  }
}
