import 'package:latihan_responsi/models/detail_model.dart';
import 'package:latihan_responsi/services/nintendo_data_services.dart';

class DetailController {
  final NintendoData nintendoData;

  DetailController({required this.nintendoData});

  Future<DataDetail> getNintendoDetail(int head) async {
    return await nintendoData.getNintendoDetail(head);
  }
}