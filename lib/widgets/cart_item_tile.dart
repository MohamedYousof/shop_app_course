import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/cart.dart';

class CartItemTile extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int qty;
  CartItemTile({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.qty,
    @required this.price,
  });
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(Icons.delete, size: 40, color: Colors.white),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
//        Provider.of<Cart>(context, listen: false).removeItem(productId);
        cart.removeItem(productId);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Item removed'),
          action: SnackBarAction(
            label: 'UnDo',
            onPressed: () {
              cart.addCartItem(productId, title, price);
            },
          ),
        ));
      },
//      confirmDismiss: (direction) {
//        return showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            title: Text('Confirm delete'),
//            content: Text('Are you sure you want to remove this item?'),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Yes'),
//                onPressed: () {
//                  Navigator.of(context).pop(true);
//                },
//              ),
//              FlatButton(
//                child: Text('No'),
//                onPressed: () {
//                  Navigator.of(context).pop(false);
//                },
//              )
//            ],
//          ),
//        );
//      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Chip(
              label: Text(
                '\$$price',
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color,
                    fontSize: 18),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text('Total: \$${(price * qty)}'),
            trailing: Text('$qty x'),
          ),
        ),
      ),
      key: ValueKey(id),
    );
  }
}
