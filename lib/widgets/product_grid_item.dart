import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/auth.dart';
import 'package:yousofshop/providers/cart.dart';
import 'package:yousofshop/providers/product.dart';
import 'package:yousofshop/screens/product_detail.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
          builder: (context, product, child) => IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () async {
              try {
                await product.toggleFavorite(authData.token, authData.userId);
              } catch (e) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString()),
                ));
              }
            },
          ),
        ),
        title: Text(product.title),
        trailing: IconButton(
          onPressed: () {
            cart.addCartItem(product.id, product.title, product.price);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.title} added!'),
                action: SnackBarAction(
                  label: 'UnDo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                  textColor: Colors.purpleAccent,
                ),
                elevation: 3,
              ),
            );
          },
          icon: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
