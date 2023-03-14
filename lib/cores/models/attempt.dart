import 'package:appwrite/models.dart';

class Attempt {
  final String id;
  final String meetId;
  final String userId;
  final String date;


  Attempt({
     this.id = '',
    required this.meetId,
    required this.userId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'meetId': meetId,
      'userId': userId,
      'date': date,
    };
  }

  factory Attempt.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return Attempt(
      id: doc.$id,
      meetId: map['meetId'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
