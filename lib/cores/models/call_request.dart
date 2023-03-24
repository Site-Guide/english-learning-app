import 'package:appwrite/models.dart';
import 'package:english/utils/extensions.dart';

class CallRequest {
  final String id;
  final String uid;
  final String topicId;
  final int limit;
  final bool connected;
  final DateTime createdAt;
  final String fcmToken;
  final String name;
  final String purchaseId;
  final bool joined;
  final bool shown;
  final String? token;

  CallRequest({
    this.id = '',
    required this.uid,
    required this.topicId,
    required this.limit,
    this.connected = false,
    required this.createdAt,
    required this.fcmToken,
    required this.name,
    required this.purchaseId,
    this.joined = false,
    this.shown = false,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'topicId': topicId,
      'limit': limit,
      'connected': connected,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'date': createdAt.date,
      'fcmToken': fcmToken,
      'name': name,
      'purchaseId': purchaseId,
      'joined': joined,
      'shown': shown,
      'token': token
    };
  }

  factory CallRequest.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return CallRequest(
      id: doc.$id,
      uid: map['uid'] ?? '',
      topicId: map['topicId'] ?? '',
      limit: map['limit']?.toInt() ?? 0,
      connected: map['connected'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      fcmToken: map['fcmToken'] ?? '',
      name: map['name'] ?? '',
      purchaseId: map['purchaseId'] ?? '',
      joined: map['joined'],
      shown: map['shown'],
      token: map['token'],
    );
  }

  static fromJson(Map<String, dynamic> data) {}
}
