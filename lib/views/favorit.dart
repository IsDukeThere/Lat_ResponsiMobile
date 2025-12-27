import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/models/alldata.dart';
import 'package:latihan_responsi/views/detail.dart';

class Favorit extends StatefulWidget {
  final String username;
  const Favorit({super.key, required this.username});

  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  late Future<Box<Data>> favoritBox;

  @override
  void initState() {
    super.initState();
    favoritBox = Hive.openBox<Data>('Favorit_${widget.username}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
            )
          ),
        centerTitle: true,
      ),
      body: FutureBuilder<Box<Data>>(
        future: favoritBox,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final box = snapshot.data!;
          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<Data> box, _) {
              if (box.isEmpty) {
                return const Center(child: Text("Belum ada item di Favorit"));
              }

              final data = box.values.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final m = data[index];

                  return Dismissible(
                    key: Key(m.head),
                    direction: DismissDirection.horizontal,
                    background: _buildSwipeBackground(Alignment.centerLeft),
                    secondaryBackground: _buildSwipeBackground(Alignment.centerRight),
                    onDismissed: (direction) {
                      box.delete(m.head);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${m.name} dihapus")),
                      );
                    },
                    child: _buildFavoriteCard(m),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(Data m) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetail(
                head: m.head,
                name: m.name,
                username: widget.username,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  m.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.head,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(Alignment alignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}