import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/order.dart';
import 'package:yousofshop/widgets/cart_item_tile.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) => CartItemTile(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                qty: cart.items.values.toList()[i].qty,
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _ordering = false;
  @override
  Widget build(BuildContext context) {
    return _ordering
        ? Stack(
            children: <Widget>[
              FlatButton(
                  child: Text(
                    'ORDER NOW',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: null),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: CircularProgressIndicator(),
              )
            ],
          )
        : FlatButton(
            child: Text('ORDER NOW',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18)),
            onPressed: widget.cart.items.length == 0
                ? null
                : () async {
                    setState(() {
                      _ordering = true;
                    });

                    try {
                      await Provider.of<Orders>(context, listen: false)
                          .addOrder(
                        widget.cart.items.values.toList(),
                        widget.cart.totalAmount,
                      );

                      setState(() {
                        _ordering = false;
                      });
                      widget.cart.clear();
                    } catch (e) {
                      setState(() {
                        _ordering = false;
                      });
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(e)),
                      );
                    }
                  },
          );
  }
}
