import 'package:appwrite/appwrite.dart';
import 'package:english/utils/extensions.dart';
import 'package:english/utils/formats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io' as io;
import '../models/master_data.dart';
import '../models/profile.dart';
import '../models/topic.dart';
import '../providers/db_provider.dart';
import '../providers/functions_provider.dart';
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


  Future<MasterData> getMasterData() => _db
      .getDocument(
        databaseId: DBs.main,
        collectionId: "masterData",
        documentId: "v1",
      )
      .then(
        (value) => MasterData.fromMap(value),
      );


  Future<Topic?> getTopic() => _db
      .listDocuments(
        databaseId: DBs.main,
        collectionId: "topics",
        queries: [
          Query.equal('date', DateTime.now().date),
        ],
      ).then(
        (value) => value.documents.isEmpty
            ? null
            : Topic.fromMap(value.documents.first),
      );
}
