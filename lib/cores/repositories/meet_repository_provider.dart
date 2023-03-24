// ignore_for_file: unused_result

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:english/cores/models/call_request.dart';
import 'package:english/cores/models/feedback.dart';
import 'package:english/cores/utils/ids.dart';
import 'package:english/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/db_provider.dart';

final meetRepositoryProvider = Provider((ref) => MeetRepsitory(ref));

class MeetRepsitory {
  final Ref _ref;

  MeetRepsitory(this._ref);

  Databases get _db => _ref.read(dbProvider);

  // Realtime get _realTime => Realtime(_ref.read(clientProvider));

  // Functions get _functions => _ref.read(functionsProvider);

  Future<void> writeRequest(CallRequest request) async {
    if (request.id.isEmpty) {
      await _db.createDocument(
        databaseId: DBs.main,
        collectionId: Collections.callRequests,
        documentId: ID.unique(),
        data: request.toMap(),
      );
    } else {
      await _db.updateDocument(
        databaseId: DBs.main,
        collectionId: Collections.callRequests,
        documentId: request.id,
        data: request.toMap(),
      );
    }
  }

  Future<List<CallRequest>> listMyAttemtsToday(String uid) {
    return _db.listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.callRequests,
        queries: [
          Query.equal('uid', uid),
          Query.equal('date', DateTime.now().date),
        ]).then(
      (value) => value.documents.map((e) => CallRequest.fromMap(e)).toList(),
    );
  }

  Future<void> joined(String id) async {
    await _db.updateDocument(
        databaseId: DBs.main,
        collectionId: Collections.callRequests,
        documentId: id,
        data: {
          'joined': true,
        });
  }

  Future<void> shown(String id) async {
    await _db.updateDocument(
        databaseId: DBs.main,
        collectionId: Collections.callRequests,
        documentId: id,
        data: {
          'shown': true,
        });
  }

  Future<void> createFeedback(Feedback feedback) {
    return _db.createDocument(
      databaseId: DBs.main,
      collectionId: Collections.feedbacks,
      documentId: ID.unique(),
      data: feedback.toMap(),
    );
  }
}
