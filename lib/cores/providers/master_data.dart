import 'package:appwrite/models.dart';

class MasterData {
  final List<String> types;
  final int version;
  final bool force;

  MasterData({
    required this.types,
    required this.force,
    required this.version,
  });




  factory MasterData.fromMap(Document doc) {
    final Map<String, dynamic> map = doc.data;
    return MasterData(
      types: List<String>.from(
        map['types']??[],
      ),
      force: map['force'] ?? false,
      version: map['version'] ?? 0,
    );
  }
}
