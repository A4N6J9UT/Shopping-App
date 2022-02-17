import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red shirt',
    //     description: 'A red shirt id pretty red',
    //     price: 299.0,
    //     imageUrl:
    //         'https://images.bewakoof.com/t540/bold-red-boyfriend-t-shirt-170465-1637134046-1.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'yellow shirt',
    //     description: 'A yellow shirt is goldish yellow',
    //     price: 299.0,
    //     imageUrl:
    //         'https://images.bewakoof.com/t540/pineapple-yellow-half-sleeve-t-shirt-men-s-plain-t-shirts-231522-1585315740.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'green shirt',
    //     description: 'this gren shirt is pretty long',
    //     price: 299.0,
    //     imageUrl:
    //         'https://images.bewakoof.com/t540/alpha-green-round-neck-t-shirt-women-s-half-sleeve-plain-t-shirt-283930-1601446913.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'black shirt',
    //     description: 'black shirt is greyish black',
    //     price: 299.0,
    //     imageUrl:
    //         'https://images.bewakoof.com/t540/jet-black-longline-t-shirt-men-s-plain-half-sleeve-longline-t-shirts-146097-1623150013.jpg',
    //   ),
  ];
  //var _showFavoritesOnly = false;
  // List<Product> get items {
  //   // if (showFavoritesOnly) {
  //   //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  //   // }
  //   return [..._items];
  // }

  // List<Product> get facoriteItems {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }

  // Product findbyId(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        '<https://flutter-7ddec-default-rtdb.firebaseio.com/products.json>');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) {
    // _items.add(value);
    final url = Uri.parse(
        '<https://flutter-7ddec-default-rtdb.firebaseio.com/products.json>');
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }))
        .then((respose) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(respose.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex > 0) {
      _items[prodIndex] == newProduct;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        '<https://flutter-7ddec-default-rtdb.firebaseio.com/products.json>');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    http.delete(url).then((_) {
      existingProduct = null;
      notifyListeners();
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }
}
