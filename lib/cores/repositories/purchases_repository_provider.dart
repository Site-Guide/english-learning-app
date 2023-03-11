import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      ]
    );

    return response.documents
        .map(
          (e) => Purchase.fromMap(e),
        )
        .toList();
  }
}
