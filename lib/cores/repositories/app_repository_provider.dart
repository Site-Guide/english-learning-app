import 'package:appwrite/appwrite.dart';
import 'package:english/cores/models/plan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/master_data.dart';
import '../providers/db_provider.dart';
import '../utils/ids.dart';

final appRepositoryProvider = Provider((ref) => AppRepository(ref));

class AppRepository {
  final Ref _ref;

  AppRepository(this._ref);
  Databases get _db => _ref.read(dbProvider);

  Future<MasterData> getMasterData() => _db
      .getDocument(
        databaseId: DBs.main,
        collectionId: "masterData",
        documentId: "v1",
      )
      .then(
        (value) => MasterData.fromMap(value),
      );

  Future<List<Plan>> listPlans() => _db
      .listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.plans,
      )
      .then(
        (value) => value.documents
            .map(
              (e) => Plan.fromMap(e),
            )
            .toList(),
      );
}
