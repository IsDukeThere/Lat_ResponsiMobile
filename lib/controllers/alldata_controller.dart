import 'package:latihan_responsi/models/alldata.dart';
import 'package:latihan_responsi/services/nintendo_data_services.dart';

class NintendoDataController {
  final NintendoData nintendoData;

  NintendoDataController({
    required this.nintendoData
  });

  Future<List<Data>> getData({int page = 1}) async {
    final data = await nintendoData.getALlData(page: page);
    return data.map((data) {
      return Data(
        head: data.head,
        name: data.name,
        image: data.image,
        release: data.release,
      );
    }).toList();
  }
}