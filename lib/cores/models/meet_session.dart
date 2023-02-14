import 'package:appwrite/models.dart';

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
