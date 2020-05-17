import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/products_provider.dart';
import 'package:yousofshop/screens/edit_product_screen.dart';
import 'package:yousofshop/widgets/main_drawer.dart';
import 'package:yousofshop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_products';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndAddProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, data) => data.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: Consumer<ProductsProvider>(
                    builder: (ctx, productsData, _) => ListView.builder(
                          itemBuilder: (context, i) => UserProductItem(
                            id: productsData.items[i].id,
                            title: productsData.items[i].title,
                            imageUrl: productsData.items[i].imageUrl,
                          ),
                          itemCount: productsData.items.length,
                        )),
              ),
      ),
    );
  }
}
