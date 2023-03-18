import 'package:appwrite/models.dart';
import 'package:english/cores/enums/level.dart';

class Profile {
  final String id;
   String name;
   String email;
   String? image;
   String phone;
   String whatsapp;
   String profession;
   String purpose;
   Level? level;
   int quizTimeSpend;
   String experience;
   String haveYou;
   String lookingFor;
   final bool isAdmin;

  Profile({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.whatsapp = '',
    this.profession = '',
    this.purpose = '',
    this.image,
    this.level,
    this.quizTimeSpend = 0,
    this.experience = '',
    this.haveYou = '',
    this.lookingFor = '',
    this.isAdmin = false,
  });

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
    String? experience,
    String? haveYou,
    String? lookingFor,
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
      experience: experience ?? this.experience,
      haveYou: haveYou ?? this.haveYou,
      lookingFor: lookingFor ?? this.lookingFor,
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
      'experience': experience,
      'haveYou': haveYou,
      'lookingFor': lookingFor,
      'isAdmin': isAdmin,
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
      experience: map['experience'] ?? '',
      haveYou: map['haveYou'] ?? '',
      lookingFor: map['lookingFor'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
