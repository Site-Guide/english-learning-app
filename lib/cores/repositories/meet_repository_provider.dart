import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:english/cores/models/attempt.dart';
import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/repositories/doc_repository_provider.dart';
import 'package:english/cores/utils/ids.dart';
import 'package:english/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/client_provider.dart';
import '../providers/db_provider.dart';

final meetRepositoryProvider = Provider((ref) => MeetRepsitory(ref));

class MeetRepsitory {
  final Ref _ref;

  MeetRepsitory(this._ref);

  Databases get _db => _ref.read(dbProvider);

  Realtime get _realTime => Realtime(_ref.read(clientProvider));

  // Stream<List<MeetSession>> streamMeetSessions() {
  //   return _ref.read(docRepositoryProvider).streamDocuments(
  //     databaseId: DBs.main,
  //     collectionId: Collections.meetSessions,
  //     queries: [
  //       Query.greaterThan(
  //         'createdAt',
  //         DateTime.now()
  //             .subtract(
  //               const Duration(minutes: 1),
  //             )
  //             .millisecondsSinceEpoch,
  //       ),
  //     ],
  //   ).map((docs) => docs
  //       .map(
  //         (doc) => MeetSession.fromMap(doc),
  //       )
  //       .toList());
  // }

  Future<void> writeMeetSession(MeetSession meetSession) async {
    print('Errrrrrrrrrr');
    if (meetSession.id.isEmpty) {
      await _db.createDocument(
        databaseId: DBs.main,
        collectionId: Collections.meetSessions,
        documentId: ID.unique(),
        data: meetSession.toMap(),
      );
    } else {
      await _db.updateDocument(
        databaseId: DBs.main,
        collectionId: Collections.meetSessions,
        documentId: meetSession.id,
        data: meetSession.toMap(),
      );
    }
  }

  Future<List<Attempt>> listMyAttemtsToday(String uid) {
    return _db.listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.attempts,
        queries: [
          Query.equal('userId', uid),
          Query.equal('date', DateTime.now().date),
        ]).then(
      (value) => value.documents.map((e) => Attempt.fromMap(e)).toList(),
    );
  }

  Future<void> createAttempt(Attempt attempt) async {
    await _db.createDocument(
      databaseId: DBs.main,
      collectionId: Collections.attempts,
      documentId: ID.unique(),
      data: attempt.toMap(),
    );
  }

  Stream<List<MeetSession>> streamMeetSessions() {
    List<Document> list = [];
    final controller = StreamController<List<MeetSession>>();

    _db.listDocuments(
        databaseId: DBs.main,
        collectionId: Collections.meetSessions,
        queries: [
          Query.greaterThan(
            'createdAt',
            DateTime.now()
                .subtract(
                  const Duration(minutes: 1),
                )
                .millisecondsSinceEpoch,
          ),
        ]).then((value) {
      list.addAll(value.documents);
      controller.add(
        list
            .map(
              (doc) => MeetSession.fromMap(doc),
            )
            .toList(),
      );
    });

    const channel =
        'databases.${DBs.main}.collections.${Collections.meetSessions}.documents';
    _realTime.subscribe([channel]).stream.listen(
          (event) {
            if (event.events.isNotEmpty &&
                event.events.first.contains(channel)) {
              print('new event: ${event.events.first}');
              final filtered =
                  event.events.where((element) => element.contains(channel));
              if (filtered.isNotEmpty) {
                final e = filtered.first;
                switch (e.split('.').last) {
                  case "create":
                    Document? doc = Document.fromMap(event.payload);
                    list.add(doc);
                    break;
                  case "update":
                    final doc = Document.fromMap(event.payload);
                    list.removeWhere((element) => element.$id == doc.$id);
                    list.add(doc);
                    break;
                  case "delete":
                    list.removeWhere(
                      (element) =>
                          element.$id == Document.fromMap(event.payload).$id,
                    );
                    break;
                  default:
                }
                final meets = list
                    .map(
                      (doc) => MeetSession.fromMap(doc),
                    )
                    .toList();
                controller.add(meets
                    .where(
                      (element) => !element.expired
                    )
                    .toList());
              }
            }
          },
        );
    return controller.stream;
  }
}
