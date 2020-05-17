import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(), // id
        TextField(), // title
        TextField(), // description
        TextField(), // price
        TextField(), // image
      ],
    );
  }
}
