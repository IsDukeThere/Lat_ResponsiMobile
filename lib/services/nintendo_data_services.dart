import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihan_responsi/models/alldata.dart';
import 'package:latihan_responsi/models/detail_model.dart';

class NintendoData {
  final String baseUrl = "https://www.amiiboapi.com";

  Future<List<Data>> getALlData({int page = 1}) async {
    final url = "$baseUrl/api/amiibo";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final alldata = jsonDecode(response.body);
      final List data = alldata['result'];
      return data.map(
        (json) => Data.fromJson(json)
      ).toList();
    } else {
      throw Exception("Gagal mengambil Data");
    }
  }

  Future<DataDetail> getNintendoDetail(int head) async {
    final String detail = "$baseUrl/api/amiibo/?head=$head";
    final response = await http.get(Uri.parse(detail));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengambil Data");
    }
  }
}