import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/order.dart';
import 'package:yousofshop/widgets/main_drawer.dart';
import 'package:yousofshop/widgets/order_item_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders_screen';

  @override
  Widget build(BuildContext context) {
//    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (data.error != null) {
                return Center(
                  child: Text('An error has occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (context, i) =>
                          OrderItemTile(orderData.orders[i]),
                      itemCount: orderData.orders.length),
                );
              }
            }
          }),
    );
  }
}
