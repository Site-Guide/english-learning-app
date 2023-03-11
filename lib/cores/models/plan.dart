import 'package:appwrite/models.dart';

class Plan {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int duration;
  final int calls;
  Plan({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    required this.calls,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //     'duration': duration,
  //     'calls': calls,
  //   };
  // }

  factory Plan.fromMap(Document doc) {
    final map = doc.data;
    return Plan(
      id: doc.$id,
      name: map['name'] ?? '',
      description: map['description'],
      price: map['price']?.toInt() ?? 0,
      duration: map['duration']?.toInt() ?? 0,
      calls: map['calls']?.toInt() ?? 0,
    );
  }
}
