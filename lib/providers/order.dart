import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
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

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/orders.json?auth=$_authToken&orderBy="creatorId"&equalTo="$_userId"';
    final resp = await http.get(url);
    final extractedData = jsonDecode(resp.body) as Map<String, dynamic>;
    final List<OrderItem> loadedItems = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedItems.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>).map((i) {
            return CartItem(
                id: i['id'],
                title: i['title'],
                price: i['price'],
                qty: i['qty']);
          }).toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _orders = loadedItems;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shopapp-9eb6f.firebaseio.com/orders.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    final data = {
      'creatorId': _userId,
      'amount': total,
      'products': cartProducts
          .map((i) =>
              {'id': i.id, 'title': i.title, 'price': i.price, 'qty': i.qty})
          .toList(),
      'dateTime': timeStamp.toIso8601String(),
    };
    print(data);

    final resp = await http.post(url, body: json.encode(data));
    if (resp.statusCode >= 400) {
      throw 'Error submitting the order';
    }
    final addedItem = OrderItem(
        id: jsonDecode(resp.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp);
    _orders.insert(0, addedItem);
    notifyListeners();
    print(resp.statusCode);
    print(resp.body);
  }
}
