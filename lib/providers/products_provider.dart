import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yousofshop/models/http_expctions.dart';
import 'package:yousofshop/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  String _authToken;
  String _userId;

  set auth(token) {
    this._authToken = token;
    notifyListeners();
  }

  set userId(id) {
    this._userId = id;
    notifyListeners();
  }

//  ProductsProvider(this.authToken, this.userId, this._products);

  List<Product> _products = [];

  List<Product> get items {
    return [..._products];
  }

  List<Product> get itemsFavorites {
    return _products.where((product) => product.isFavorite == true).toList();
  }

  Product getProductById(String id) {
    return _products.firstWhere((productId) => productId.id == id);
  }

  Future<void> fetchAndAddProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url =
        'https://shopapp-9eb6f.firebaseio.com/products.json?auth=$_authToken&$filterString';
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        if (extractedData == null) {
          return;
        }
        url =
            'https://shopapp-9eb6f.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
        extractedData.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
                // ?? operator is to check if the value is null
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ));
        });
        _products = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/products.json?auth=$_authToken';
    final data = {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'creatorId': _userId,
    };
    try {
      final response = await http.post(url, body: json.encode(data));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: jsonDecode(response.body)['name'],
      );
      _products.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/products/$id.json?auth=$_authToken';
    final data = {
      'title': newProduct.title,
      'description': newProduct.description,
      'price': newProduct.price,
      'imageUrl': newProduct.imageUrl,
    };
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await http.patch(url, body: json.encode(data));
      _products[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/products/$id.json?auth=$_authToken';
    final productIndex = _products.indexWhere((prod) => prod.id == id);
    var exProduct = _products[productIndex];

    _products.removeAt(productIndex);
    notifyListeners();
    final resp = await http.delete(url);
    if (resp.statusCode >= 400) {
      _products.insert(productIndex, exProduct);
      notifyListeners();
      throw HttpException('Deleting error, please try again');
    }
    exProduct = null;
  }
}

// Setters approach
//String authToken;
//String userId;
//
//set auth(token) {
//  this.authToken = token;
//  notifyListeners();
//}
//
//set use(id) {
//  this.userId = id;
//  notifyListeners();
//}
