import 'package:arthub/Like/Likeapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/Cart/order_page.dart';
import 'package:arthub/profile/detail_profile.dart';

class ApiDetailPage3 extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double randomPrice;
  final String artistName;
  final String fotoPerfil;
  final int idUsuario; // Nuevo parámetro
  final int publicationId; // Nuevo parámetro

  ApiDetailPage3({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.randomPrice,
    required this.artistName,
    required this.fotoPerfil,
    required this.idUsuario, // Agregar userId al constructor
    required this.publicationId, // Agregar publicationId al constructor
  });

  @override
  _ApiDetailPageState createState() => _ApiDetailPageState();
}

class _ApiDetailPageState extends State<ApiDetailPage3> {
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

  String selectedFrame = 'Poster';
  String selectedSize = 'Predeterminado';
  String selectedPrintType = 'Predeterminado';
  bool isLiked = false;
  ColorFilter selectedPrintTypeColor =
      const ColorFilter.mode(Colors.transparent, BlendMode.color);
  String frameImage = '';

  // Color por defecto

  int cartItemCount = 0;

  final Map<String, double> framePrices = {
    'Poster': 0.0,
    'Madera - \$10': 10.0,
    'Metal - \$15': 15.0,
    'Aluminio - \$20': 20.0,
    //Aluminio.svg
    //Madera.svg
    //Metal.svg
  };

  final Map<String, double> sizePrices = {
    'Predeterminado': 0.0,
    '20 x 25 - \$5': 5.0,
    '28 x 35 - \$10': 10.0,
    '40 x 35 - \$15': 15.0,
    '46 x 51 - \$20': 20.0,
    '61 x 91 - \$25': 25.0,
  };

  final Map<String, double> printTypePrices = {
    'Predeterminado': 0.0,
    'Monocromatico - \$8': 8.0,
    'Sepa - \$12': 12.0,
  };

  double calculateTotalPrice() {
    double totalPrice = sizePrices[selectedSize]! +
        framePrices[selectedFrame]! +
        printTypePrices[selectedPrintType]! +
        widget.randomPrice;
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

    // Actualizar la imagen del marco según la opción seleccionada
    if (newFrame == 'Madera - \$10') {
      frameImage = 'assets/madera1.png';
    } else if (newFrame == 'Metal -\$15') {
      frameImage = 'assets/metal1.png'; // Corregir extensión de imagen
    } else if (newFrame == 'Aluminio - \$20') {
      frameImage = 'assets/aluminio1jpg.jpg';
    } else {
      frameImage = ''; // Otra lógica si es necesario
    }
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

  void _handleLikeInteraction() async {
    // Obtén userId y publicationId de tu widget o de donde provengan
    int? idUsuario = widget.idUsuario;
    int? publicationId = widget.publicationId;

    if (idUsuario != null && publicationId != null) {
      // Llama al método saveLike solo si userId y publicationId son válidos
      LikeService likeService = LikeService();
      await likeService.saveLike(idUsuario, publicationId, isLiked);

      // Actualiza el estado local si el like se guarda exitosamente según la respuesta de la API
      setState(() {
        isLiked = true; // Actualiza la variable isLiked a true
      });
    } else {
      print('Error: userId o publicationId es nulo.');
    }
  }

  void _updateColorPrint(String filterType) {
    Color filterColor =
        Colors.transparent; // Filtro transparente para eliminar el color

    if (filterType == 'Monocromatico - \$8') {
      filterColor =
          Colors.red; // Cambiar a rojo cuando se seleccione Monocromatico
    } else if (filterType == 'Sepa - \$12') {
      filterColor = Colors.brown; // Cambiar a azul cuando se seleccione Sepa
    }

    setState(() {
      selectedPrintType = filterType;
      selectedPrintTypeColor = ColorFilter.mode(filterColor,
          BlendMode.color); // Aplicar el filtro de color o filtro transparente
    });
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
                    fit: BoxFit
                        .contain, // Usar BoxFit.contain para mostrar la imagen completa
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item['name'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(item['price'] as double?)?.toStringAsFixed(2) ?? ''}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
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
                  ),
                ),
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
    print(
        'Usuario: ${widget.idUsuario} dentro de la publicacion con el ID  ${widget.publicationId}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.cart_fill, color: Colors.black),
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
                        _handleLikeInteraction();
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 20), // Agrega el margen izquierdo deseado aquí
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tipo de Marco:',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedFrame,
                    onChanged: (value) {
                      setState(() {
                        selectedFrame = value!;
                        _updateSelectedFrame(
                            value); // Cambia frameImage por value
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
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20), // Agrega el margen izquierdo deseado aquí
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tamaño de la Imagen:',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
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
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20), // Agrega el margen izquierdo deseado aquí
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtro:',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedPrintType,
                    onChanged: (value) {
                      setState(() {
                        selectedPrintType = value!;
                        _updateColorPrint(
                            value); // Llama al método _updateColorPrint con el valor seleccionado
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
            ),
            const SizedBox(height: 10),
            Container(
  alignment: Alignment.center,
  child: ColorFiltered(
    colorFilter: selectedPrintTypeColor,
    child: Image.network(widget.imageUrl),
  ),
  height: MediaQuery.of(context).size.height * 0.4, // 70% del alto de la pantalla
  width: MediaQuery.of(context).size.width * 0.4, // 70% del ancho de la pantalla
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage(frameImage),
      fit: BoxFit.cover, // Puedes probar otros BoxFit según la situación
      alignment: Alignment.center,
    ),
  ),
),


            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomNarbar(
        totalPrice: calculateTotalPrice(),
        onAddToCartPressed: _addToCart,
      ),
    );
  }
}

class ItemBottomNarbar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCartPressed; // Nuevo

  ItemBottomNarbar(
      {required this.totalPrice,
      required this.onAddToCartPressed}); // Actualizado

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
