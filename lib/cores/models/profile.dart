import 'package:appwrite/models.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String phone;
  final String whatsapp;
  final String profession;
  final String purpose;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.profession,
    required this.purpose,
    this.image,
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
    );
  }
}
