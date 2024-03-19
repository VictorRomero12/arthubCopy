import 'package:arthub/Home/NewDetailPage.dart';
import 'package:arthub/Home/Widgets/DrawerWidget.dart';
import 'package:arthub/Home/apidetail_prueba.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePagePrueba extends StatefulWidget {
  final String username;
  final String password;

  const HomePagePrueba({Key? key, required this.username, required this.password}) : super(key: key);

  @override
  _HomePagePruebaState createState() => _HomePagePruebaState();
}

class _HomePagePruebaState extends State<HomePagePrueba> {
  late List<dynamic> _allImages = [];
  List<dynamic> _filteredImages = [];
  late String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final response = await http.get(Uri.parse('http://arthub.somee.com/api/Publicacion'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _allImages = jsonData;
        _filteredImages = _allImages;
        _shuffleImages();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  void _shuffleImages() {
    _filteredImages.shuffle();
  }

  void _filterImages(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm.toLowerCase();
      _filteredImages = _allImages.where((image) => image['titulo'].toLowerCase().contains(_searchTerm)).toList();
      _shuffleImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Coloca aquí el AppBarWidget

      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchImages();
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        color: Colors.red,
                      ),
                      Container(
                        height: 50,
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            onChanged: (value) {
                              _filterImages(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.filter_list)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            CategoriesWidget(),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Popular",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ApiPage(images: _filteredImages),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ApiPage extends StatelessWidget {
  final List<dynamic> images;

  ApiPage({required this.images});

  @override
  Widget build(BuildContext context) {
    final bool isImageListEmpty = images.isEmpty;
    return isImageListEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                final dynamic item = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApiDetailPage2(
                          imageUrl: item['archivo'] ?? '',
                          name: item['titulo'] ?? '',
                          description: item['descripcion'] ?? '',
                          randomPrice: item['precio']?.toDouble() ?? 0.0,
                          artistName: item['nombreArtista'] ?? '',
                          fotoPerfil: item['fotoPerfil'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: Image.network(
                          images[index]['archivo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Icon(CupertinoIcons.bars),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Icon(Icons.notifications),
            ),
          )
        ],
      ),
    );
  }
}

