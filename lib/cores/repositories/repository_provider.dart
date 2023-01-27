import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io' as io;
import '../models/profile.dart';
import '../providers/db_provider.dart';
import '../providers/functions_provider.dart';
import '../providers/master_data.dart';
import '../providers/storage_provider.dart';
import '../utils/ids.dart';

final repositoryProvider = Provider((ref) => Repository(ref));

class Repository {
  final Ref _ref;

  Repository(this._ref);

  Databases get _db => _ref.read(dbProvider);
  Functions get _functions => _ref.read(functionsProvider);
  Storage get _storage => _ref.read(storageProvider);

  Future<void> writeProfile(Profile profile, {io.File? file}) async {
    String? image = file != null
        ? (await uploadImage(
            file,
            Collections.profiles,
            profile.id,
          ))
        : null;
    await _db.createDocument(
      databaseId: DBs.main,
      collectionId: Collections.profiles,
      documentId: profile.id,
      data: profile.copyWith(image: image).toMap(),
    );
  }

  // Future<void> write(Event event, {io.File? file}) async {
  //   String? image;
  //   if (file != null) {
  //     image = await uploadImage(file, Buckets.events);
  //   }

  //   for (var guest in event.guests) {
  //     if (guest.file != null) {
  //       final url = await uploadImage(guest.file!, Buckets.guests);
  //       event.guests[event.guests.indexOf(guest)].image = url;
  //     }
  //   }

  //   event = event.copyWith(
  //     image: image,
  //   );
  //   if (event.id.isEmpty) {
  //     await _db.createDocument(
  //       databaseId: DBs.main,
  //       collectionId: "events",
  //       documentId: ID.unique(),
  //       data: event.toMap(),
  //     );
  //   } else {
  //     await _db.updateDocument(
  //       databaseId: DBs.main,
  //       collectionId: "events",
  //       documentId: event.id,
  //       data: event.toMap(),
  //     );
  //   }
  // }

  Future<String> uploadImage(
    io.File file,
    String bucketId, [
    String? id,
  ]) async {
    return (await _storage.createFile(
      bucketId: bucketId,
      fileId: id ?? ID.unique(),
      file: InputFile(
        filename: id,
        path: file.path,
      ),
    ))
        .$id;
  }

  // Future<List<Document>> eventsFuture(
  //     {required int limit,
  //     Document? lastDocument,
  //     String? searchKey,
  //     String? date,
  //     required String location,
  //     String? type}) async {
  //   return await _db.listDocuments(
  //     databaseId: DBs.main,
  //     collectionId: "events",
  //     queries: [
  //       Query.equal('status', 'verified'),
  //       Query.equal('location', location),
  //       if (type != null) Query.equal('type', type),
  //       if (date != null) Query.equal('date', date),
  //       if (searchKey != null && searchKey.isNotEmpty)
  //         Query.search('name', searchKey)
  //       else ...[
  //         Query.orderAsc("dateTime"),
  //         Query.greaterThan(
  //           "dateTime",
  //           DateTime.now()
  //               .subtract(
  //                 const Duration(hours: 1),
  //               )
  //               .millisecondsSinceEpoch,
  //         ),
  //       ],
  //       Query.limit(limit),
  //       if (lastDocument != null) Query.cursorAfter(lastDocument.$id)
  //     ],
  //   ).then((value) => value.documents);
  // }

  //   Future<List<Document>> panIndiaEventsFuture(
  //     ) async {
  //   return await _db.listDocuments(
  //     databaseId: DBs.main,
  //     collectionId: "events",
  //     queries: [
  //       Query.equal('status', 'verified'),
  //       Query.equal('location', MasterData.panIndia),
  //       Query.orderAsc("dateTime"),
  //         Query.greaterThan(
  //           "dateTime",
  //           DateTime.now()
  //               .subtract(
  //                 const Duration(hours: 1),
  //               )
  //               .millisecondsSinceEpoch,
  //         ),
  //     ],
  //   ).then((value) => value.documents);
  // }

  // Stream<List<Joinee>> listJoiners(String id) =>
  //     _ref.read(docRepositoryProvider).streamDocuments(
  //         databaseId: DBs.main,
  //         collectionId: "joinees",
  //         queries: [
  //           Query.equal("eId", id),
  //         ],
  //         match: {
  //           "eId": id
  //         }).map(
  //       (value) => value
  //           .map(
  //             (e) => Joinee.fromMap(e),
  //           )
  //           .toList(),
  //     );

  // Future<Joinee> join(Joinee joinee, [bool? first]) async {
  //   if (first??false) {
  //     _db.updateDocument(
  //       databaseId: 'main',
  //       collectionId: "events",
  //       documentId: joinee.eId,
  //       data: {
  //         "firstJoinee": joinee.uId,
  //       }
  //     );
  //   }
  //   return Joinee.fromMap((await _db.createDocument(
  //     databaseId: DBs.main,
  //     collectionId: "joinees",
  //     documentId: ID.unique(),
  //     data: joinee.toMap(),
  //   )));
  // }

  // void updateJoinersCount(String id, int count) async {
  //   _db.updateDocument(
  //     databaseId: DBs.main,
  //     collectionId: "events",
  //     documentId: id,
  //     data: {"joiners": count},
  //   );
  // }

  // Future<void> cancelJoining(String id) async {
  //   await _db.deleteDocument(
  //     databaseId: DBs.main,
  //     collectionId: "joinees",
  //     documentId: id,
  //   );
  // }

  // Future<Profile> getProfile(String id) => _functions
  //     .createExecution(
  //       functionId: "63aeeed416300d0432bf",
  //       data: jsonEncode(
  //         {"id": id},
  //       ),
  //     )
  //     .then(
  //       (value) => Profile.fromJson(value.response),
  //     );

  Future<Profile> getProfile(String id) async {
    try {
      return await _db
          .getDocument(
            databaseId: DBs.main,
            collectionId: "profiles",
            documentId: id,
          )
          .then(
            (value) => Profile.fromMap(value),
          );
    } on AppwriteException catch (e) {
      print(e.type);

      return Future.error(e.type ?? e.code!);
    } catch (e) {
      print(e);

      return Future.error(e);
    }
  }

  Future<void> deleteMeetup(String id) async {
    await _db.deleteDocument(
      databaseId: DBs.main,
      collectionId: "meetups",
      documentId: id,
    );
  }

  void markJoined(String id) {
    _db.updateDocument(
      databaseId: DBs.main,
      collectionId: "joinees",
      documentId: id,
      data: {
        'joined': true,
      },
    );
  }

  // Future<Meetup> getMeetup(String id) => _db
  //     .getDocument(databaseId: DBs.main, collectionId: "meetups", documentId: id)
  //     .then((value) => Meetup.fromMap(value));

  // Future<Event> getEvent(String id) => _db
  //     .getDocument(databaseId: DBs.main, collectionId: "events", documentId: id)
  //     .then((value) => Event.fromMap(value));

  Future<MasterData> getMasterData() => _db
      .getDocument(
        databaseId: DBs.main,
        collectionId: "masterData",
        documentId: "v1",
      )
      .then(
        (value) => MasterData.fromMap(value),
      );

  // void saveLocation(String v) async {
  //   final cache = await _ref.read(cacheProvider.future);
  //   cache.setString(Constants.location, v);
  // }

  // Future<List<String>> getEventIds(String uId) => _db.listDocuments(
  //       databaseId: DBs.main,
  //       collectionId: "joinees",
  //       queries: [
  //         Query.equal('uId', uId),
  //       ],
  //     ).then(
  //       (value) => value.documents
  //           .map(
  //             (e) => e.data['eId'] as String,
  //           )
  //           .toList(),
  //     );

  // Future<List<Event>> getMyEvents(String id) => _db.listDocuments(
  //       databaseId: DBs.main,
  //       collectionId: "events",
  //       queries: [
  //         Query.equal('createdBy', id),
  //       ],
  //     ).then(
  //       (value) => value.documents
  //           .map(
  //             (e) => Event.fromMap(e),
  //           )
  //           .toList(),
  //     );
}
