import 'package:appwrite/models.dart';

class Topic {
  final String id;
  final String topic;
  final String description;
  final String date;

  Topic({
    required this.id,
    required this.topic,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'description': description,
      'date': date,
    };
  }

  factory Topic.fromMap(Document doc) {
    final map = doc.data;
    return Topic(
      id: doc.$id,
      topic: map['topic'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
