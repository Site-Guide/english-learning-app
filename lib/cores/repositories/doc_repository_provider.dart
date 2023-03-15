import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/client_provider.dart';
import '../providers/db_provider.dart';

final docRepositoryProvider = Provider((ref) => DocRepository(
      ref,
    ));

class DocRepository {
  final Ref _ref;

  DocRepository(this._ref);

  Realtime get realTime => Realtime(_ref.read(clientProvider));
  Databases get db => _ref.read(dbProvider);

  Stream<Document> streamDocument({
    required String id,
    required String collectionId,
  }) {
    final controller = StreamController<Document>();
    db
        .getDocument(
            collectionId: collectionId, documentId: id, databaseId: "main")
        .then((value) {
      controller.add(value);
    }).catchError((e) {
      controller.addError(e);
    });
    final channel = 'databases.main.collections.$collectionId.documents.$id';
    final subscription = realTime.subscribe([channel]);
    subscription.stream.listen((e) {
      final filtered = e.events.where((element) => element.contains(channel));
      if (filtered.isNotEmpty) {
        final event = filtered.first;
        switch (event.split('.').last) {
          case "create":
            controller.add(Document.fromMap(e.payload));
            break;
          case "update":
            controller.add(Document.fromMap(e.payload));
            break;
          case "delete":
            controller.addError(AppwriteException("document_not_found", 404));
            break;
          default:
        }
      }
    });
    return controller.stream;
  }

  Stream<List<Document>> streamDocuments({
    required String databaseId,
    required String collectionId,
    List<String>? queries,
  }) {
    List<Document> list = [];
    final controller = StreamController<List<Document>>();
    db
        .listDocuments(
            databaseId: databaseId,
            collectionId: collectionId,
            queries: queries)
        .then((value) {
      list.addAll(value.documents);
      controller.add(list);
    });
    final channel = 'databases.$databaseId.collections.$collectionId.documents';
    realTime.subscribe([channel]).stream.listen((event) {
          if (event.events.isNotEmpty && event.events.first.contains(channel)) {
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
              controller.add(list);
            }
          }
        },);
    return controller.stream;
  }
}
