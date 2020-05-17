import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int qty;

  CartItem({this.id, this.title, this.price, this.qty});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int counter = 0;
    _items.forEach((key, i) {
      counter += i.qty;
    });
    return counter;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, i) {
      total += i.price * i.qty;
    });
    return total;
  }

  void addCartItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // add one to quantity
      _items.update(
          productId,
          (exItem) => CartItem(
              id: exItem.id,
              title: exItem.title,
              price: exItem.price,
              qty: exItem.qty + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              qty: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].qty > 1) {
      _items.update(
        productId,
        (oldItem) => CartItem(
            id: oldItem.id,
            title: oldItem.title,
            price: oldItem.price,
            qty: oldItem.qty - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
