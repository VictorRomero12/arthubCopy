import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/Cart/order_page.dart';
import 'package:arthub/profile/detail_profile.dart';

class ApiDetailPage2 extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double randomPrice;
  final String artistName;
  final String fotoPerfil;

  ApiDetailPage2({
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

class _ApiDetailPageState extends State<ApiDetailPage2> {
   Future<Map<String, dynamic>?> fetchArtistProfile() async {
    final response = await http.get(Uri.parse('http://arthub.somee.com/api/Publicacion'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final artistPublications = data.where((publication) => publication['nombreArtista'] == widget.artistName).toList();
      return {
        'authorName': widget.artistName,
        'fotoPerfil': widget.fotoPerfil,
        'totalPosts': artistPublications.length,
        'images': artistPublications.map((publication) => publication['archivo']).toList(),
      };
    } else {
      throw Exception('Failed to load artist profile');
    }
  }
  String selectedFrame = 'Sin Marco';
  String selectedSize = 'Tamaño Predeterminado';
  String selectedPrintType = 'Tipo Predeterminado';
  bool isLiked = false;

  int cartItemCount = 0;

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

  double calculateTotalPrice() {
    double totalPrice =
        sizePrices[selectedSize]! + framePrices[selectedFrame]! + printTypePrices[selectedPrintType]! + widget.randomPrice;
    return totalPrice;
  }

  void _updateSelectedSize(String newSize) {
    setState(() {
      selectedSize = newSize;
    });
  }

  void _updateSelectedFrame(String newFrame) {
    setState(() {
      selectedFrame = newFrame;
    });
  }

  void _updateSelectedPrintType(String newPrintType) {
    setState(() {
      selectedPrintType = newPrintType;
    });
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
  height: 180,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      image: NetworkImage(item['imageUrl'] ?? ''),
      fit: BoxFit.contain, // Usar BoxFit.contain para mostrar la imagen completa
    ),
  ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
      title: Text('Detalle de Producto'),
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2, // Cambiar a 1/3
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '\$${widget.randomPrice.toStringAsFixed(2)}',
                    // '\$${calculateTotalPrice().toStringAsFixed(2)}', // Actualizar precio total
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
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
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: _openAuthorProfile,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/sinfoto.jpg',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.artistName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Opciones de tamaño",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sizePrices.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 15);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    String sizeOption = sizePrices.keys.toList()[index];
                    return ElevatedButton(
                      onPressed: () {
                        _updateSelectedSize(sizeOption);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedSize == sizeOption
                            ? Colors.red
                            : Colors.white,
                        onPrimary: selectedSize == sizeOption
                            ? Colors.white
                            : Colors.black,
                        side: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        sizeOption,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Opciones de Marco",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: framePrices.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 15);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    String frameOption = framePrices.keys.toList()[index];
                    return ElevatedButton(
                      onPressed: () {
                        _updateSelectedFrame(frameOption);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedFrame == frameOption
                            ? Colors.red
                            : Colors.white,
                        onPrimary: selectedFrame == frameOption
                            ? Colors.white
                            : Colors.black,
                        side: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        frameOption,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Opciones de Impresion",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: printTypePrices.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 15);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    String printTypeOption = printTypePrices.keys.toList()[index];
                    return ElevatedButton(
                      onPressed: () {
                        _updateSelectedPrintType(printTypeOption);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedPrintType == printTypeOption
                            ? Colors.red
                            : Colors.white,
                        onPrimary: selectedPrintType == printTypeOption
                            ? Colors.white
                            : Colors.black,
                        side: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        printTypeOption,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomNarbar(totalPrice: calculateTotalPrice(), onAddToCartPressed: _addToCart,),
    );
  }
}

class ItemBottomNarbar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCartPressed; // Nuevo

  ItemBottomNarbar({required this.totalPrice, required this.onAddToCartPressed}); // Actualizado

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total:",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "\$${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: onAddToCartPressed, // Cambiado
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red,
                ),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.cart_fill_badge_plus,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10), // Espacio entre el icono y el texto
                  Text(
                    "Add Cart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


