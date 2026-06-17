import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final IconData icon;
  final String description;
  final String image;
  final String category;

  Product(this.name, this.price, this.icon, this.description, this.image, this.category);

  String get formattedPrice => 'Ksh. ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}';
}
