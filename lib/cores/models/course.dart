import 'package:appwrite/models.dart';

class Course {
  final String id;
  final String title;
  final String? description;
  final int price;
  final String image;
  final List<String> bunchOf;
  final int duration;
  final int calls;
  
  Course({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.image,
    required this.bunchOf,
    required this.duration,
    required this.calls,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'bunchOf': bunchOf,
      'duration': duration,
      'calls': calls,
    };
  }

  factory Course.fromMap(Document doc) {
    final map = doc.data;
    return Course(
      id: doc.$id,
      title: map['title'] ?? '',
      description: map['description'],
      price: map['price']?.toInt() ?? 0,
      image: map['image'] ?? '',
      bunchOf: List<String>.from(map['bunchOf']),
      duration: map['duration']?.toInt() ?? 0,
      calls: map['calls']?.toInt() ?? 0,
    );
  }
}
