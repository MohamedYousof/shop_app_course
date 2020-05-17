import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/products_provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = 'product_detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<ProductsProvider>(context).getProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Image.network(
            product.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price}',
            style: TextStyle(color: Colors.blueGrey, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              product.description,
              softWrap: true,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
