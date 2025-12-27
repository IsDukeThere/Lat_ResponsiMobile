import 'package:flutter/material.dart';
import 'package:latihan_responsi/controllers/alldata_controller.dart';
import 'package:latihan_responsi/models/alldata.dart';
import 'package:latihan_responsi/services/nintendo_data_services.dart';
import 'package:latihan_responsi/views/detail.dart';
import 'package:latihan_responsi/views/login.dart';
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  if (dateString == "-" || dateString.isEmpty) return "TBA";
  try {
    final date = DateTime.parse(dateString);
    return DateFormat("dd MMM yyyy").format(date);
  } catch (e) {
    return "Invalid Date";
  }
}

class Home extends StatefulWidget {
  final String username;
  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<Home> {
  late NintendoDataController controller;
  List<Data> news = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = NintendoDataController(nintendoData: NintendoData());
    _data();
  }

  Future<void> _data() async {
    setState(() {
      currentPage = 1;
    });

    final data = await controller.getData(page: currentPage);
    setState(() {
      news = data;
    });
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    currentPage++;
    final data = await controller.getData(page: currentPage);

    setState(() {
      news.addAll(data);
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 120,
        leading: Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            "Halo, ${widget.username}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          "Nintendo Amiibo List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child
                  : GridView.builder(
                      padding: EdgeInsets.all(15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        final m = news[index];
                        return MovieCard(
                          name: m.name,
                          image: m.image,
                          release: m.release,
                          head: m.head,
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
                        );
                      },
                    ),
            ),
            if (isLoadingMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String head;
  final String name;
  final String image;
  final String release;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.head,
    required this.name,
    required this.image,
    required this.release,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 280,
                    color: Colors.grey.shade800,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, StackTrace) => Container(
                  height: 280,
                  color: Colors.grey.shade700,
                  child: const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Release"
                          ),
                        SizedBox(width: 5),
                        Spacer(),
                        Text(
                          formatDate(release),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}