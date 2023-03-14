import 'package:appwrite/models.dart';

enum MeetSessionStatus {
  waiting,
  ready,
  active,
  ended,
}

class MeetSession {
  final String id;
  final String topic;
  final String topicId;
  final int? limit;
  final DateTime createdAt;
  final List<String> participants;

  bool get isFull => limit != null && participants.length >= limit!;

  bool isJoinReady(int? limit) => !isFull && !expired && this.limit == limit;

  bool get expired =>
      createdAt.isBefore(DateTime.now().subtract(const Duration(minutes: 1)));

  bool isReadyForMeet(String id) =>
      !expired &&
      (participants.length >= (limit ?? 1)) &&
      participants.contains(id);

  bool needToWait(String id) =>
      !expired &&
      (participants.length < (limit ?? 1)) &&
      participants.contains(id);

  MeetSession({
    required this.id,
    required this.topic,
    required this.topicId,
    this.limit,
    required this.createdAt,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
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
      topic: map['topic'] ?? '',
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
      topic: topic ?? this.topic,
      limit: limit ?? this.limit,
      createdAt: createdAt ?? this.createdAt,
      participants: participants ?? this.participants,
      topicId: topicId ?? this.topicId,
    );
  }
}
