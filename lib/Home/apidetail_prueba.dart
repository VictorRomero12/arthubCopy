import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/profile/detail_profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class ApiDetailPage extends StatefulWidget {
  
  final String imageUrl;
  final String name;
  final String description;
  final double randomPrice;
  final String artistName;

  ApiDetailPage({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.randomPrice,
    required this.artistName,
  });

  @override
  _ApiDetailPageState createState() => _ApiDetailPageState();
}


class _ApiDetailPageState extends State<ApiDetailPage> {
 String selectedFrame = 'Sin Marco';
  String selectedSize = 'Tamaño Predeterminado';
  String selectedPrintType = 'Tipo Predeterminado';
  bool isLiked = false;

  int cartItemCount = 0;

  Future<Map<String, dynamic>?> fetchArtistProfile() async {
    final response = await http.get(Uri.parse('http://arthub.somee.com/api/Publicacion'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Filtrar las publicaciones del artista específico
      final artistPublications = data.where((publication) => publication['nombreArtista'] == widget.artistName).toList();
      return {
        'authorName': widget.artistName,
        'totalPosts': artistPublications.length,
        'images': artistPublications.map((publication) => publication['archivo']).toList(),
      };
    } else {
      throw Exception('Failed to load artist profile');
    }
  }
  void _showLikeSnackBar() {
    final snackBar = const SnackBar(
      content: Text('Te gusta esta imagen'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

void _openAuthorProfile() async {
  // Almacenar el BuildContext antes de la llamada asíncrona
  BuildContext? contextRef = context;

  final artistProfileData = await fetchArtistProfile();
  if (artistProfileData != null && contextRef != null) {
    Navigator.push(
      contextRef, // Usar el contexto almacenado
      MaterialPageRoute(
        builder: (_) => DetailProfile(
          authorName: artistProfileData['authorName'],
          totalPosts: artistProfileData['totalPosts'],
          totalImages: artistProfileData['images'].length, // Agregar totalImages aquí
          images: List<String>.from(artistProfileData['images']),
        ),
      ),
    );
  } else {
    print('Failed to get artist profile data');
  }
}
  _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double calculateTotalPrice() {
    double framePrice = framePrices[selectedFrame] ?? 0.0;
    double sizePrice = sizePrices[selectedSize] ?? 0.0;
    double printTypePrice = printTypePrices[selectedPrintType] ?? 0.0;

    double totalPrice =
        framePrice + sizePrice + printTypePrice + widget.randomPrice;

    return totalPrice;
  }

  void _showCartDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Consumer<CartModel>(
            builder: (context, cart, child) {
              return cart.items.isNotEmpty
                  ? _buildCartItemInfo(cart)
                  : _buildEmptyCartInfo();
            },
          ),
        ),
      );
    },
  );
}

Widget _buildCartItemInfo(CartModel cart) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: cart.items.map((item) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenedor para la imagen
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(item['imageUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20), // Espaciado entre la imagen y la información

              // Contenedor para la información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${item['name'] ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Descripción: ${item['description'] ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Precio: \$${(item['price'] as double?)?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removeFromCart(item); // Método para eliminar el elemento del carrito
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      );
    }).toList(),
  );
}
void _removeFromCart(Map<String, dynamic> item) {
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int index = cartModel.items.indexOf(item); // Encuentra el índice del artículo en la lista
  if (index != -1) {
    cartModel.removeItem(index); // Elimina el artículo basado en su índice
    setState(() {
      cartItemCount--;
    });
  }
}




  Widget _buildEmptyCartInfo() {
    return const Center(
      child: Text(
        'No has agregado nada al carrito',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

void _addToCart() {
  double totalPrice = calculateTotalPrice();
  Map<String, dynamic> item = {
    'name': widget.name,
    'description': widget.description,
    'price': totalPrice,
    'imageUrl': widget.imageUrl, // Agregar la URL de la imagen
    // Otros detalles relevantes del artículo aquí...
  };

  // Acceder al CartModel utilizando Provider
  Provider.of<CartModel>(context, listen: false).addItem(item);

  setState(() {
    cartItemCount++;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 66, 103),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCartDialog,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    cartItemCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 38, 48, 63),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
        // Ajuste del margen inferior
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showFullScreenImage,
                child: Hero(
                  tag: 'imageTag',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${calculateTotalPrice().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 192, 84),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      _showLikeSnackBar();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.name,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 192, 84)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.description,
                style: const TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 253, 192, 84)),
              ),
            ),
            const SizedBox(height: 20),
   Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: _openAuthorProfile,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 253, 192, 84),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.account_circle,
              size: 40,
              color: Color.fromARGB(255, 253, 192, 84),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.artistName,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 253, 192, 84),
            ),
          ),
        ],
      ),
    ),
    GestureDetector(
      onTap: _openAuthorProfile,
      child: Text(
        widget.artistName,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 253, 192, 84),
        ),
      ),
    ),
  ],
),



            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tipo de Marco:',
                  style: TextStyle(
                    fontSize: 19,
                    color: Color.fromARGB(255, 253, 192, 84),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedFrame,
                  onChanged: (value) {
                    setState(() {
                      selectedFrame = value!;
                    });
                  },
                  items: framePrices.keys.map((frame) {
                    return DropdownMenuItem<String>(
                      value: frame,
                      child: Text(frame),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tamaño de la Imagen:',
                  style: TextStyle(
                    fontSize: 19,
                    color: Color.fromARGB(255, 253, 192, 84),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedSize,
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value!;
                    });
                  },
                  items: sizePrices.keys.map((size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tipo de Impresión:',
                  style: TextStyle(
                    fontSize: 19,
                    color: Color.fromARGB(255, 253, 192, 84),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedPrintType,
                  onChanged: (value) {
                    setState(() {
                      selectedPrintType = value!;
                    });
                  },
                  items: printTypePrices.keys.map((printType) {
                    return DropdownMenuItem<String>(
                      value: printType,
                      child: Text(printType),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            bottom: 48.0, left: 16.0, right: 16.0), // Padding para el botón
        child: Align(
          alignment: Alignment.bottomCenter,
          // Para alinear el botón al fondo de la pantalla
          child: FloatingActionButton.extended(
            onPressed: _addToCart,
            icon: const Icon(Icons.shopping_cart,
                color: Color.fromARGB(255, 38, 48, 63)),
            label: const Text('Añadir al carrito'),
            backgroundColor: const Color.fromARGB(255, 253, 192, 84),
          ),
        ),
      ),
    );
  }
}
final Map<String, double> framePrices = {
  'Sin Marco': 0.0,
  'Madera - \$10': 10.0,
  'Metal - \$15': 15.0,
  'Aluminio - \$20': 20.0,
  'Plastico - \$5': 5.0,
};

final Map<String, double> sizePrices = {
  'Tamaño Predeterminado': 0.0,
  '20 x 25 - \$5': 5.0,
  '28 x 35 - \$10': 10.0,
  '40 x 35 - \$15': 15.0,
  '46 x 51 - \$20': 20.0,
  '61 x 91 - \$25': 25.0,
};

final Map<String, double> printTypePrices = {
  'Tipo Predeterminado': 0.0,
  'Impresión Cartulina - \$8': 8.0,
  'Impresión Opalina - \$12': 12.0,
  'Impresion Laser - \$15': 15.0,
  'Impresion Fotografica - \$18': 18.0,
};
