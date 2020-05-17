import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yousofshop/providers/auth.dart';
import 'package:yousofshop/providers/cart.dart';
import 'package:yousofshop/providers/order.dart';
import 'package:yousofshop/providers/products_provider.dart';
import 'package:yousofshop/screens/CartScreen.dart';
import 'package:yousofshop/screens/auth_screen.dart';
import 'package:yousofshop/screens/edit_product_screen.dart';
import 'package:yousofshop/screens/orders_screen.dart';
import 'package:yousofshop/screens/product_detail.dart';
import 'package:yousofshop/screens/products_overview_screen.dart';
import 'package:yousofshop/screens/splash_screen.dart';
import 'package:yousofshop/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          // setter approach
          create: (context) => ProductsProvider(),
          update: (context, data, product) {
            product.auth = data.token;
            product.userId = data.userId;
            return product;
          },
          // constructor approach
//          create: (context) => ProductsProvider('', '', []),
//          update: (context, data, old) =>
//              ProductsProvider(data.token, old.userId, old.items),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, data, order) {
            order.auth = data.token;
            order.userId = data.userId;
            return order;
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Yousof Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrangeAccent,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AuthScreen.routeName: (_) => AuthScreen(),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            ProductDetail.routeName: (_) => ProductDetail(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
