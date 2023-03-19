import 'dart:convert';

import 'package:appwrite/models.dart';

class Feedback {
  final String id;
  final int rating;
  final String comment;
  final String by;
  Feedback({
    required this.id,
    required this.rating,
    required this.comment,
    required this.by,
  });

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'comment': comment,
      'by': by,
    };
  }

  factory Feedback.fromMap(Document doc) {
   final Map<String, dynamic> map = doc.data;
    return Feedback(
      id: doc.$id,
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      by: map['by'] ?? '',
    );
  }
}
