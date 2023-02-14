import 'package:appwrite/appwrite.dart';
import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/repositories/doc_repository_provider.dart';
import 'package:english/cores/utils/ids.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/db_provider.dart';

final meetRepositoryProvider = Provider((ref) => MeetRepsitory(ref));

class MeetRepsitory {
  final Ref _ref;

  MeetRepsitory(this._ref);

  Databases get db => _ref.read(dbProvider);

  Stream<List<MeetSession>> streamMeetSessions() {
    return _ref.read(docRepositoryProvider).streamDocuments(
      databaseId: DBs.main,
      collectionId: Collections.meetSessions,
      queries: [
        Query.greaterThan(
          'createdAt',
          DateTime.now()
              .subtract(
                const Duration(minutes: 2),
              )
              .millisecondsSinceEpoch,
        ),
      ],
    ).map((docs) => docs
        .map(
          (doc) => MeetSession.fromMap(doc),
        )
        .toList());
  }

  Future<void> writeMeetSession(MeetSession meetSession) async {
    if (meetSession.id.isEmpty) {
      await db.createDocument(
        databaseId: DBs.main,
        collectionId: Collections.meetSessions,
        documentId: ID.unique(),
        data: meetSession.toMap(),
      );
    } else {
      await db.updateDocument(
        databaseId: DBs.main,
        collectionId: Collections.meetSessions,
        documentId: meetSession.id,
        data: meetSession.toMap(),
      );
    }
  }
}
