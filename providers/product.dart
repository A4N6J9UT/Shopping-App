import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    this.id = '0',
    this.title = '0',
    this.description = '0',
    this.price = 0.00,
    this.imageUrl = '0',
    this.isFavorite = false,
  });
  void toggleFavoriteStatus() {
    isFavorite != isFavorite;
    notifyListeners();
  }
}
