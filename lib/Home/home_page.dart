

import 'package:arthub/Cart/cart_page.dart';
import 'package:arthub/Cart/order_page.dart';
import 'package:arthub/Home/apiprueba.dart' as ApiPageFile;
import 'package:arthub/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:arthub/Home/images_page.dart';
import 'package:provider/provider.dart';
import 'package:arthub/Cart/cart_Item.dart';

// Importa la nueva página de buscador

class SimpleBottomNavigation extends StatefulWidget {
  final String username;
  final String password;
  
  const SimpleBottomNavigation({Key? key, required this.username, required this.password}) : super(key: key);

  @override
  State<SimpleBottomNavigation> createState() => _SimpleBottomNavigationState();
}

class _SimpleBottomNavigationState extends State<SimpleBottomNavigation> {
  
  int _selectedIndex = 0;
  BottomNavigationBarType _bottomNavType = BottomNavigationBarType.fixed;

  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<CartModel>(context, listen: false).items;
    final List<Widget> _pages = [
      ApiPage(),
      // SearchPage(), // Reemplaza Container() por la nueva página de buscador
      OrderPage( cartItems: cartItems,
  frameType: 'Tipo de marco',
  printType: 'Tipo de impresión',
  size: 'Tamaño'), // Placeholder para la página del carrito (Cart)
      ProfilePage(
        username: widget.username,
        password: widget.password,
      ), // Placeholder para la página de perfil (Profile)
    ];

    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex], // Muestra la página según el índice seleccionado
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 178, 63), // Color del ícono seleccionado
        unselectedItemColor: const Color.fromARGB(255, 255, 178, 63).withOpacity(0.7), // Color del ícono no seleccionado
        backgroundColor: const Color.fromARGB(255, 47, 60, 79), // Fondo constante
        //  Color.fromARGB(255, 55, 66, 103)
        type: _bottomNavType, // Tipo de barra de navegación
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
        selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 178, 63)), // Color del ícono seleccionado
        unselectedIconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 178, 63).withOpacity(0.7)), // Color del ícono no seleccionado
      ),
    );
  }

  static const _navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_rounded),
      label: 'Inicio',
    ),
  
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag_outlined),
      activeIcon: Icon(Icons.shopping_bag),
      label: 'Carrito',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      activeIcon: Icon(Icons.person_rounded),
      label: 'Perfil',
    ),
  ];
}
