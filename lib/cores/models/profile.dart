import 'package:appwrite/models.dart';
import 'package:english/cores/enums/level.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String phone;
  final String whatsapp;
  final String profession;
  final String purpose;
  final Level? level;
  final int quizTimeSpend;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.profession,
    required this.purpose,
    this.image,
    this.level,
    this.quizTimeSpend = 0,
  });

  factory Profile.empty() {
    return Profile(
      id: '',
      name: '',
      email: '',
      phone: '',
      whatsapp: '',
      profession: '',
      purpose: '',
      quizTimeSpend: 0,
    );
  }

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? image,
    String? phone,
    String? whatsapp,
    String? profession,
    String? purpose,
    Level? level,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      profession: profession ?? this.profession,
      purpose: purpose ?? this.purpose,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'phone': phone,
      'whatsapp': whatsapp,
      'profession': profession,
      'purpose': purpose,
      "level": level?.name,
      'quizTimeSpend': quizTimeSpend,
    };
  }

  factory Profile.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return Profile(
      id: doc.$id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      image: map['image'],
      phone: map['phone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      profession: map['profession'] ?? '',
      purpose: map['purpose'] ?? '',
      level: Level.values.cast<Level?>().firstWhere(
        (e) => e?.name == map['level'],
        orElse: () => null,
      ),
      quizTimeSpend: map['quizTimeSpend'] ?? 0,
    );
  }
}
