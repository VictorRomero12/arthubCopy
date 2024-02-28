import 'package:flutter/material.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({
    Key? key,
    required this.authorName,
    required this.totalPosts,
    required this.totalImages,
    required this.images, // Agregado: lista de imágenes
  }) : super(key: key);

  final String authorName;
  final int totalPosts;
  final int totalImages;
  final List<String> images; // Agregado: lista de imágenes

  static MaterialPageRoute<dynamic> route({
    required String authorName,
    required int totalPosts,
    required int totalImages,
    required List<String> images, // Agregado: lista de imágenes
  }) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => DetailProfile(
        authorName: authorName,
        totalPosts: totalPosts,
        totalImages: totalImages,
        images: images, // Agregado: lista de imágenes
      ),
    );
  }

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del perfil'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Aquí puedes agregar la funcionalidad del menú si es necesario
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  // Puedes agregar la imagen del autor aquí
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Publicaciones: ${widget.totalPosts}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Imágenes: ${widget.totalImages}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
              itemCount: widget.images.length, // Usar el tamaño de la lista de imágenes
              itemBuilder: (context, index) {
                // Construir cada elemento de la cuadrícula de imágenes
                return Container(
                  color: Colors.grey[300],
                  child: Image.network(widget.images[index]), // Mostrar la imagen correspondiente del autor
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
