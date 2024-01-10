import 'dart:convert';

import 'package:circle/dto/info_gempa.dart';
import 'package:http/http.dart' as http;

main() async {
  var status = await BMKGStatusGempa.getBMKGStatusGempa();
  print(status);
}

class BMKGStatusGempa {
  final InfoGempa Infogempa;

  BMKGStatusGempa.fromJson(Map<String, dynamic> json)
      : Infogempa = InfoGempa.fromJson(json['Infogempa']);

  @override
  String toString() {
    return 'BMKGStatusGempa{Infogempa: $Infogempa}';
  }

  static Future<BMKGStatusGempa> getBMKGStatusGempa() async {
    var uri =
        Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return BMKGStatusGempa.fromJson(json);
    } else {
      throw Exception('Failed to load BMKGStatusGempa');
    }
  }
}
