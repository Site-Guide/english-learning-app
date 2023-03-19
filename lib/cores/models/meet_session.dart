import 'package:appwrite/models.dart';

enum MeetSessionStatus {
  waiting,
  ready,
  active,
  ended,
}

class MeetSession {
  final String id;
  final String topicId;
  final int? limit;
  final DateTime createdAt;
  final List<String> participants;

  bool get isFull => participants.length >= (limit ?? 5);

  bool isJoinReady(int? limit,String topicId) => !isFull && !expired && this.limit == limit && topicId == this.topicId;

  bool get expired =>
      createdAt.isBefore(DateTime.now().subtract(const Duration(minutes: 1)));


//TODO: update this
  bool isReadyForMeet(String id) =>
      !expired &&
      (participants.length >= (limit ?? 1)) &&
      participants.contains(id);

//TODO: update this
  bool needToWait(String id) =>
      !expired &&
      (participants.length < (limit ?? 1)) &&
      participants.contains(id);

  MeetSession({
    required this.id,
    required this.topicId,
    this.limit,
    required this.createdAt,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'participants': participants,
      'topicId': topicId,
    };
  }

  factory MeetSession.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return MeetSession(
      id: doc.$id,
      limit: map['limit']?.toInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      participants: List<String>.from(map['participants']),
      topicId: map['topicId'] ?? '',
    );
  }

  MeetSession copyWith({
    String? id,
    String? topic,
    int? limit,
    DateTime? createdAt,
    List<String>? participants,
    String? topicId,
  }) {
    return MeetSession(
      id: id ?? this.id,
      limit: limit ?? this.limit,
      createdAt: createdAt ?? this.createdAt,
      participants: participants ?? this.participants,
      topicId: topicId ?? this.topicId,
    );
  }
}
