import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yousofshop/providers/order.dart';

class OrderItemTile extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemTile(this.orderItem);

  @override
  _OrderItemTileState createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd-MMM-yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.orderItem.products.length * 40.0 + 10, 140),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                itemBuilder: (context, i) => ProductListTile(
                  title: widget.orderItem.products[i].title,
                  price: widget.orderItem.products[i].price,
                  qty: widget.orderItem.products[i].qty,
                ),
                itemCount: widget.orderItem.products.length,
              ),
            )
        ],
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final String title;
  final int qty;
  final double price;

  ProductListTile({this.title, this.qty, this.price});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      trailing: Text(
        '$qty x $price',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
