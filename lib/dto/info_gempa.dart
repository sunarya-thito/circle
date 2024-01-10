import 'package:circle/dto/gempa.dart';

class InfoGempa {
  final List<Gempa> gempa;

  @override
  String toString() {
    return 'InfoGempa{gempa: $gempa}';
  }

  InfoGempa.fromJson(Map<String, dynamic> json)
      : gempa = (json['gempa'] as List).map((i) => Gempa.fromJson(i)).toList();
}
