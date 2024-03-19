import 'package:flutter/material.dart';

class DetailProfile extends StatelessWidget {
  const DetailProfile({
    Key? key,
    required this.authorName,
    required this.fotoPerfil,
    required this.totalPosts,
    required this.totalImages,
    required this.images,
  }) : super(key: key);

  final String authorName;
  final String fotoPerfil;
  final int totalPosts;
  final int totalImages;
  final List<String> images;

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
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xff0043ba), Color(0xff006df1)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            height: 120, // Altura del contenedor
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
  padding: const EdgeInsets.only(top: 20),
  child: ClipOval(
    child: Image.asset(
      "assets/sinfoto.jpg",
      fit: BoxFit.cover,
      height: 100, // ajusta el tamaño de la imagen según tus necesidades
      width: 100,
    ),
  ),
),

            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              authorName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _ProfileInfoRow(items: [
                    
                    
                    ProfileInfoItem("Publicaciones", totalPosts),
                    ProfileInfoItem("Ventas", 2),
                    
                  ]),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[300],
                          child: Image.network(images[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key, required this.items}) : super(key: key);

  final List<ProfileInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map((item) => Expanded(
                  child: Row(
                    children: [
                      if (items.indexOf(item) != 0) const VerticalDivider(),
                      Expanded(child: _singleItem(context, item)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(), // Cambiar este valor estático
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}


