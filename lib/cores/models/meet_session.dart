import 'package:appwrite/models.dart';
import 'package:english/utils/extensions.dart';

enum MeetSessionStatus {
  waiting,
  ready,
  active,
  ended,
}

class MeetSession {
  final String id;
  final String subject;
  final int? limit;
  final DateTime createdAt;
  final List<String> participants;
  // final MeetSessionStatus status;

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
    required this.subject,
    this.limit,
    required this.createdAt,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'limit': limit,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'participants': participants,
      'date': createdAt.date,
    };
  }

  factory MeetSession.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return MeetSession(
      id: doc.$id,
      subject: map['subject'] ?? '',
      limit: map['limit']?.toInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      participants: List<String>.from(map['participants']),
    );
  }

  MeetSession copyWith({
    String? id,
    String? subject,
    int? limit,
    DateTime? createdAt,
    List<String>? participants,
  }) {
    return MeetSession(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      limit: limit ?? this.limit,
      createdAt: createdAt ?? this.createdAt,
      participants: participants ?? this.participants,
    );
  }
}
