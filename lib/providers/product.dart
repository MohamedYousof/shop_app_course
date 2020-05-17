import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:yousofshop/models/http_expctions.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String authToken, String userId) async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    isFavorite = !isFavorite;
    notifyListeners();

    final resp = await http.put(url, body: json.encode(isFavorite));
    if (resp.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Error has occured!');
    }
  }
}
