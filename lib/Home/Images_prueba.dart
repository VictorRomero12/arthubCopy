import 'package:arthub/Home/NewDetailPage.dart';
import 'package:arthub/Home/Widgets/DrawerWidget.dart';
import 'package:arthub/Home/apidetail_prueba.dart';
import 'package:arthub/Home/otraPrueba.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePagePrueba extends StatefulWidget {
  final String username;
  final String password;
  final int idUsuario;

  const HomePagePrueba(
      {Key? key,
      required this.username,
      required this.password,
      required this.idUsuario})
      : super(key: key);

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
    final response =
        await http.get(Uri.parse('http://arthub.somee.com/api/Publicacion'));
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
      _filteredImages = _allImages
          .where((image) => image['titulo'].toLowerCase().contains(_searchTerm))
          .toList();
      _shuffleImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ID del usuario en HomePagePrueba: ${widget.idUsuario}');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 66, 103),
      // Coloca aquí el AppBarWidget

      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchImages();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: Colors.red,
                      ),
                      Container(
                        height: 50,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            onChanged: (value) {
                              _filterImages(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ApiPage(images: _allImages, idUsuario: widget.idUsuario),
          ],
        ),
      ),
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
  final int idUsuario; // Agrega el campo idUsuario como parte de la clase

  ApiPage(
      {required this.images,
      required this.idUsuario}); // Actualiza el constructor

  @override
  Widget build(BuildContext context) {
    final bool isImageListEmpty = images.isEmpty;
    return isImageListEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                final dynamic item = images[index];
                return GestureDetector(
                  onTap: () {
                    final int publicationId =
                        item['idPublicacion'] as int? ?? 0;
                    print(
                        'Usuario: ${idUsuario} abriendo la imagen con ID de publicación: $publicationId');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApiDetailPage3(
                          imageUrl: item['archivo'] ?? '',
                          name: item['titulo'] ?? '',
                          description: item['descripcion'] ?? '',
                          randomPrice: item['precio']?.toDouble() ?? 0.0,
                          artistName: item['nombreArtista'] ?? '',
                          fotoPerfil: item['fotoPerfil'] ?? '',
                          idUsuario: idUsuario, // Usa widget.idUsuario aquí
                          publicationId: publicationId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
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
