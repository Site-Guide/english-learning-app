import 'package:appwrite/models.dart';

class Topic {
  final String id;
  final String name;
  final String description;
  final String date;
  final String? courseId;
  final String? courseName;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.courseId,
    this.courseName,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'topic': name,
  //     'description': description,
  //     'name': date,

  //   };
  // }

  factory Topic.fromMap(Document doc) {
    final map = doc.data;
    return Topic(
      id: doc.$id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      courseId: map['courseId'] == ""? null : map['courseId'],
      courseName: map['courseName'] == ""? null : map['courseName'],
    );
  }
}
