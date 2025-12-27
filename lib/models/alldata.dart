import 'package:hive/hive.dart';

part "alldata.g.dart";

@HiveType(typeId: 0)
class Data {
  @HiveField(0)
  final String head;

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
    String releaseDate = "-";
    if (json['release'] != null && json['release']['eu'] != null) {
      releaseDate = json['release']['eu'];
    }
    return Data(
      head: json['head'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      release: releaseDate,
    );
  }

  static Future? getALlData() async {}
}