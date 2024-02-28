import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:arthub/Home/apidetail_prueba.dart';

class ApiPage extends StatefulWidget {
  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<String> imageUrls = [];
  late List<dynamic> jsonData; 
  late List<dynamic> filteredData = []; 

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      final response = await http.get(
        Uri.parse('http://arthub.somee.com/api/Publicacion'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.body); 
          filteredData = List.from(jsonData); 
          imageUrls = jsonData.map<String>((json) => json['archivo']).toList();
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void search(String query) {
    setState(() {
      filteredData = jsonData.where((item) => item['titulo'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> _refresh() async {
    await fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 66, 103),
      appBar: AppBar(
        title: const Text('Buscar imagen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate(searchData: jsonData, imageUrls: imageUrls));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApiDetailPage(
                        imageUrl: filteredData[index]['archivo'],
                        name: filteredData[index]['titulo'],
                        description: filteredData[index]['descripcion'],
                        randomPrice: filteredData[index]['precio'].toDouble(),
                        artistName: filteredData[index]['nombreArtista'],
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'imageTag$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      filteredData[index]['archivo'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> searchData;
  final List<String> imageUrls;

  CustomSearchDelegate({required this.searchData, required this.imageUrls});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); 
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? []
        : searchData.where((item) {
            final String itemName = item['titulo'].toString().toLowerCase();
            final String queryLower = query.toLowerCase();
            return itemName.contains(queryLower);
          }).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final dynamic item = suggestionList[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApiDetailPage(
                  imageUrl: item['archivo'],
                  name: item['titulo'],
                  description: item['descripcion'],
                  randomPrice: item['precio'].toDouble(),
                  artistName: item['nombreArtista'],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item['archivo'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
