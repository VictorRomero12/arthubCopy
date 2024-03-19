import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/Cart/order_page.dart';
import 'package:arthub/profile/detail_profile.dart';

class ApiDetailPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double randomPrice;
  final String artistName;
  final String fotoPerfil;

  ApiDetailPage({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.randomPrice,
    required this.artistName,
    required this.fotoPerfil,
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
    final response =
        await http.get(Uri.parse('http://arthub.somee.com/api/Publicacion'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final artistPublications = data
          .where((publication) =>
              publication['nombreArtista'] == widget.artistName)
          .toList();
      return {
        'authorName': widget.artistName,
        'fotoPerfil': widget.fotoPerfil,
        'totalPosts': artistPublications.length,
        'images': artistPublications
            .map((publication) => publication['archivo'])
            .toList(),
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
    BuildContext? contextRef = context;

    final artistProfileData = await fetchArtistProfile();
    if (artistProfileData != null && contextRef != null) {
      if (widget.fotoPerfil != null) {
        // Verificar si fotoPerfil no es null
        Navigator.push(
          contextRef,
          MaterialPageRoute(
            builder: (_) => DetailProfile(
              authorName: artistProfileData['authorName'],
              fotoPerfil:
                  widget.fotoPerfil, // Solo usar fotoPerfil si no es null
              totalPosts: artistProfileData['totalPosts'],
              totalImages: artistProfileData['images'].length,
              images: List<String>.from(artistProfileData['images']),
            ),
          ),
        );
      } else {
        print('fotoPerfil es null');
      }
    } else {
      print('Failed to get artist profile data');
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este artículo del carrito?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Aceptar
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        _removeFromCart(item);
      }
    });
  }

  void _showFullScreenImage() {
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
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Consumer<CartModel>(
                      builder: (context, cart, child) {
                        return cart.items.isNotEmpty
                            ? _buildCartItemInfo(cart)
                            : _buildEmptyCartInfo();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderPage(
                                cartItems: Provider.of<CartModel>(context,
                                        listen: false)
                                    .items,
                                frameType: selectedFrame,
                                printType: selectedPrintType,
                                size: selectedSize),
                          ),
                        );
                      },
                      child: const Text('Comprar ahora'),
                    ),
                  ],
                ),
              ),
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
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), 
  
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180,
                height: 100,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   image: DecorationImage(
                //     image: NetworkImage(item['imageUrl'] ?? ''),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Image.network(item['imageUrl'] ?? '', fit: BoxFit.cover,),
                
                
              ),
              
              Expanded(
                child: Padding(padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['name'] ?? ''}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    
                    
                    
                    Text(
                      '\$${(item['price'] as double?)?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item['frameType'] ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item['printType'] ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item['size'] ?? ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),),
                
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(item);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _removeFromCart(Map<String, dynamic> item) {
    var cartModel = Provider.of<CartModel>(context, listen: false);
    int index = cartModel.items.indexOf(item);
    if (index != -1) {
      cartModel.removeItem(index);
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
      'imageUrl': widget.imageUrl,
      'frameType': selectedFrame,
      'printType': selectedPrintType,
      'size': selectedSize,
    };

    var cartModel = Provider.of<CartModel>(context, listen: false);

    // Verificar si el producto ya está en el carrito
    bool isAlreadyInCart = cartModel.items.any((cartItem) =>
        cartItem['name'] == item['name'] &&
        cartItem['0imageUrl'] == item['imageUrl']);

    if (isAlreadyInCart) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Producto ya en el carrito'),
            content: const Text(
                'Este producto ya está en tu carrito. ¿Deseas agregar otro?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      _addToCartConfirmed(
          item); // Solo agregar si el producto no está en el carrito
    }
  }

  void _addToCartConfirmed(Map<String, dynamic> item) {
    Provider.of<CartModel>(context, listen: false).addItem(item);

    setState(() {
      cartItemCount++;
    });
  }

void _buildFullScreenImage() {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen principal (galería)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Superponer las imágenes de los marcos
              if (selectedFrame != 'Sin Marco')
                Image.asset(
                  'assets/${selectedFrame.toLowerCase()}.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      );
    },
  );
}


Widget _buildFrameImage() {
  switch (selectedFrame) {
    case 'Sin Marco':
      return SizedBox.shrink(); // No mostrar ninguna imagen si no hay marco
    case 'Madera':
      return Image.asset(
        'assets/madera.webp',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    case 'Metal':
      return Image.asset(
        'assets/cobre.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    case 'Aluminio':
      return Image.asset(
        'assets/aluminio.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    case 'Plastico':
      return Image.asset(
        'assets/plastico.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      );
    default:
      return SizedBox.shrink(); // No mostrar ninguna imagen por defecto
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 55, 66, 103),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart,
                      color: Color.fromARGB(255, 253, 192, 84)),
                  onPressed: _showCartDialog,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
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
                      fontSize: 22, color: Color.fromARGB(255, 253, 192, 84)),
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
                        ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/sinfoto.jpg',
                              fit: BoxFit.cover,
                              width:
                                  50, // Ajusta el tamaño de la imagen según sea necesario
                              height:
                                  50, // Ajusta el tamaño de la imagen según sea necesario
                            ),
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
                      color: Colors.white,
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
                        child: Text(
                          frame,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
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
                      color: Colors.white,
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
                        child: Text(
                          size,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
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
                      color: Colors.white,
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
                        child: Text(
                          printType,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
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
              bottom:
                  16.0), // Ajuste para ubicar el botón en la parte inferior de la pantalla
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_cart,
                      color: Color.fromARGB(255, 38, 48, 63)),
                  label: const Text('Añadir al carrito'),
                  backgroundColor: const Color.fromARGB(255, 253, 192, 84),
                ),
                const SizedBox(height: 16), // Espacio entre los botones
                FloatingActionButton.extended(
                  onPressed: _buildFullScreenImage,
                  icon: const Icon(Icons.fullscreen,
                      color: Color.fromARGB(255, 38, 48, 63)),
                  label: const Text('Mostrar Pantalla Completa'),
                  backgroundColor: const Color.fromARGB(255, 253, 192, 84),
                ),
              ],
            ),
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
