import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/cart.dart';
import 'package:yousofshop/providers/products_provider.dart';
import 'package:yousofshop/screens/CartScreen.dart';
import 'package:yousofshop/widgets/main_drawer.dart';
import 'package:yousofshop/widgets/original.dart';
import 'package:yousofshop/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = 'products_overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isLoading = false;
  @override
  initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndAddProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  bool showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yousof Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            builder: (context, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
          ),
          PopupMenuButton(
            onSelected: (val) {
              setState(() {
                if (val == 0) {
                  showFavorites = true;
                } else {
                  showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: 1,
              )
            ],
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavorites),
      drawer: MainDrawer(),
    );
  }
}
