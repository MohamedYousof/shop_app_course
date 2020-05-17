import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/products_provider.dart';
import 'package:yousofshop/widgets/product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool fav;
  ProductsGrid(this.fav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = fav ? productsData.itemsFavorites : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductGridItem(),
      ),
      itemCount: products.length,
    );
  }
}
