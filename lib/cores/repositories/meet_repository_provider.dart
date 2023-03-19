// ignore_for_file: unused_result

import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:english/cores/models/attempt.dart';
import 'package:english/cores/models/feedback.dart';
import 'package:english/cores/models/meet_session.dart';
import 'package:english/cores/models/purchase.dart';
import 'package:english/cores/repositories/purchases_repository_provider.dart';
import 'package:english/cores/utils/ids.dart';
import 'package:english/ui/purchases/providers/purchases_provider.dart';
import 'package:english/utils/dates.dart';
import 'package:english/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/client_provider.dart';
import '../providers/db_provider.dart';
import '../providers/functions_provider.dart';

final meetRepositoryProvider = Provider((ref) => MeetRepsitory(ref));

class MeetRepsitory {
  final Ref _ref;

  MeetRepsitory(this._ref);

  Databases get _db => _ref.read(dbProvider);

  Realtime get _realTime => Realtime(_ref.read(clientProvider));

  Functions get _functions => _ref.read(functionsProvider);

  Future<void> writeMeetSession(MeetSession meetSession) async {
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
            print("event: ${event.events.length}");
            if (event.events.isNotEmpty &&
                event.events.first.contains(channel)) {
              final filtered =
                  event.events.where((element) => element.contains(channel));
              if (filtered.isNotEmpty) {
                final e = filtered.first;
                print(e);
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
                print("meets: ${meets.length}");
                print(meets.where((element) => !element.expired).toList().length);
                controller
                    .add(meets.where((element) => !element.expired).toList());
              }
            }
          },
        );
    return controller.stream;
  }

  Future<String> createLivekitToken(
      {required String roomId,
      required String identity,
      required String name}) async {
    try {
      final res = await _functions.createExecution(
        functionId: functionIds.createLivekitToken,
        data: jsonEncode({
          'roomId': roomId,
          'identity': identity,
          'name': name,
        }),
      );
      final data = jsonDecode(res.response);
      return data['token'];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> saveAttempt(MeetSession session, Purchase purchase) async {
    try {
      await createAttempt(
        Attempt(
            meetId: session.id, userId: purchase.uid, date: Dates.today.date),
      );
      await _ref.read(purchasesRepositoryProvider).increamentCallsDone(purchase);
       _ref.refresh(purchasesProvider);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> createFeedback(Feedback feedback){
    return _db.createDocument(
      databaseId: DBs.main,
      collectionId: Collections.feedbacks,
      documentId: ID.unique(),
      data: feedback.toMap(),
    );
  }
}
