import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Data {
  @HiveField(0)
  final int head;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String release;

  Data({
    required this.head,
    required this.name,
    required this.image,
    required this.release,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      head: json['head'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      release: json['release'] ?? '',
    );
  }

  static Future? getALlData() async {}
}