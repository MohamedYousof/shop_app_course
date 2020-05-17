import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/auth.dart';
import 'package:yousofshop/screens/auth_screen.dart';
import 'package:yousofshop/screens/orders_screen.dart';
import 'package:yousofshop/screens/products_overview_screen.dart';
import 'package:yousofshop/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Yousof Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ItemDrawer(
            icon: Icons.shop,
            text: 'Shop',
            handler: () => Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName),
          ),
          Divider(),
          ItemDrawer(
            icon: Icons.payment,
            text: 'Orders',
            handler: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ItemDrawer(
              icon: Icons.edit,
              text: 'Manage Products',
              handler: () => Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName)),
          Divider(),
          ListTile(
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 26,
            ),
            title: Text('Logout', style: Theme.of(context).textTheme.title),
          ),
        ],
      ),
    );
  }
}

class ItemDrawer extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function handler;

  ItemDrawer({this.icon, this.text, this.handler});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: handler,
      leading: Icon(icon, size: 26),
      title: Text(text, style: Theme.of(context).textTheme.title),
    );
  }
}
