import 'dart:convert';

import 'package:appwrite/models.dart';

class QuizQuestion {
  final String id;
  final String question;
  final Map<String, String> options;
  final String ans;
  final int index;
  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.ans,
    required this.index,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'question': question,
  //     'options': json.encode(options),
  //     'ans': answer,
  //     'index': index,
  //   };
  // }

  factory QuizQuestion.fromMap(Document doc) {
    final map = doc.data;
    return QuizQuestion(
      id: doc.$id,
      question: map['question'] ?? '',
      options: Map<String, String>.from(
        json.decode(map['options'] ?? '{}'),
      ),
      ans: map['ans'] ?? "0",
      index: map['index'] ?? 0,
    );
  }
}
