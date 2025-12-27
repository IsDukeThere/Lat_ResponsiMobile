import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latihan_responsi/models/alldata.dart';
import 'package:latihan_responsi/models/detail_model.dart';
import 'package:latihan_responsi/services/nintendo_data_services.dart';

String formatDate(String dateString) {
  if (dateString == "-" || dateString.isEmpty) return "Unknown Release";
  
  try {
    final date = DateTime.parse(dateString);
    return DateFormat("dd MMMM yyyy").format(date); 
  } catch (e) {
    return "Invalid Date";
  }
}

class GameDetail extends StatefulWidget {
  final String name;
  final String head;
  final String username;
  const GameDetail({
    super.key,
    required this.head,
    required this.name,
    required this.username,
  });

  @override
  State<GameDetail> createState() => _DetailState();
}

class _DetailState extends State<GameDetail> {
  Box<Data>? DataBox;
  bool isSaved = false;
  bool boxReady = false;
  late Future<DataDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = NintendoData().getNintendoDetail(widget.head);
    _openUserBox();
  }

  Future<void> _openUserBox() async {
    DataBox = await Hive.openBox<Data>('Favorit_${widget.username}');
    _checkIfSaved();
    setState(() {});
  }

  void _checkIfSaved() {
    setState(() {
      isSaved = DataBox!.containsKey(widget.head);
    });
  }

  void _toggleWatchlist(DataDetail detail) async {
    if (isSaved) {
      DataBox!.delete(widget.head);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.name} dihapus dari Favorit")),
      );
    } else {
      final dataToSave = Data(
        head: detail.head,
        name: detail.name,
        image: detail.image,
        release: detail.release.eu ?? "-",
      );
      await DataBox!.put(widget.head, dataToSave);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.name} ditambahkan ke Favorit")),
      );
    }

    _checkIfSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amiibo Details", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<DataDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final detail = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      detail.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 400,
                    ),
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            detail.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.5),
                        },
                        children: [
                          _buildTableRow("Amiibo Series", detail.amiiboSeries),
                          _buildTableRow("Character", detail.character),
                          _buildTableRow("Game Series", detail.gameSeries),
                          _buildTableRow("Type", detail.type),
                          _buildTableRow("Head", detail.head),
                          _buildTableRow("Tail", detail.tail),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      const Text(
                        "Release Dates",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Divider(thickness: 1),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.5),
                        },
                        children: [
                          _buildTableRow("Australia", formatDate(detail.release.au ?? "-")),
                          _buildTableRow("Europe", formatDate(detail.release.eu ?? "-")),
                          _buildTableRow("Japan", formatDate(detail.release.jp ?? "-")),
                          _buildTableRow("North America", formatDate(detail.release.na ?? "-")),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(height: 30),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<DataDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final detailData = snapshot.data!;
          return FloatingActionButton.extended(
            onPressed: () => _toggleWatchlist(detailData),
            label: Text(isSaved ? "Hapus Favorit" : "Tambah Favorit"),
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
    );
  }
}

TableRow _buildTableRow(String label, String value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          value,
          textAlign: TextAlign.right, // Nilai rata kanan sesuai gambar
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    ],
  );
}