import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/Cart/order_page.dart';
import 'package:arthub/Home/Images_prueba.dart';

import 'package:arthub/Home/apiprueba.dart' as ApiPageFile;
import 'package:arthub/Like/page_favorities.dart';
import 'package:arthub/authentication/login_page.dart';
import 'package:arthub/profile/ProfilePrueba.dart';
import 'package:arthub/profile/profileNew.dart';
import 'package:arthub/profile/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arthub/Home/images_page.dart';
import 'package:provider/provider.dart';
import 'package:arthub/Cart/cart_Item.dart';

// Importa la nueva página de buscador

class SimpleBottomNavigation extends StatefulWidget {
  final String username;
  final String password;
  final int idUsuario;
  final bool
      isLoggedIn; // Variable para verificar si el usuario ha iniciado sesión

  const SimpleBottomNavigation({
    Key? key,
    required this.username,
    required this.password,
    required this.idUsuario,
    required this.isLoggedIn, // Incluye la variable en el constructor
  }) : super(key: key);

  @override
  State<SimpleBottomNavigation> createState() => _SimpleBottomNavigationState();
}

class _SimpleBottomNavigationState extends State<SimpleBottomNavigation> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Verifica si el usuario ha iniciado sesión
    bool userLoggedIn = widget.isLoggedIn;

    var cartItems = Provider.of<CartModel>(context, listen: false).items;
    final List<Widget> _pages = [
      HomePagePrueba(
        username: widget.username,
        password: widget.password,
        idUsuario: widget.idUsuario,
      ),
      OrderPage(
        cartItems: cartItems,
        frameType: 'Tipo de marco',
        printType: 'Tipo de impresión',
        size: 'Tamaño',
      ),
      FavoritesPage(userId: widget.idUsuario),
      ProfilePage3(
        username: widget.username,
        password: widget.password,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 47, 60, 79),
        icons: const [
          CupertinoIcons.home,
          CupertinoIcons.cart,
          CupertinoIcons.heart,
          CupertinoIcons.person,
        ],
        activeIndex: pageIndex,
        inactiveColor: const Color.fromARGB(255, 255, 255, 255),
        activeColor: const Color.fromARGB(255, 255, 178, 63),
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        iconSize: 25,
        elevation: 0,
        onTap: (index) {
          if (userLoggedIn) {
            setState(() {
              pageIndex = index;
            });
          } else {
            // Si el usuario no ha iniciado sesión, muestra un modal
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
  backgroundColor: Color.fromARGB(255, 255, 255, 255), // Cambia el color de fondo a blanco
  title: Row(
    children: [
      Text('Advertencia'),
      SizedBox(width: 20),
      Icon(CupertinoIcons.exclamationmark_triangle_fill),
    ],
  ),
  content: const Text('Debes iniciar sesión para acceder aquí.'),
  actions: <Widget>[
    TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cerrar', style: TextStyle(color: Colors.black),),
    ),
  ],
);

              },
            );
          }
        },
      ),
    );
  }
}
