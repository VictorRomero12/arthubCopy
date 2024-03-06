import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  String selectedSize;
  String selectedFrame;
  String selectedPrintType;

  CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.selectedSize,
    required this.selectedFrame,
    required this.selectedPrintType,
  });
}
