import 'package:arthub/Cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.read<CartModel>(); // Utiliza context.read aquí
    return Text('Items en el carrito: ${cart.items.length}');
  }
}