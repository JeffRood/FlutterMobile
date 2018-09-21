import 'package:flutter/material.dart';

import './product_card.dart';

class Products extends StatelessWidget {
  // Final es para decir que la lista esta vacia y se llena luego del construtor
  final List<Map<String, dynamic>> products;

  // Contrutor para traer data externa
  Products(this.products);

  Widget _buildProductsList() {
    Widget productCard;
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      // Para devorver null
//  productCard = Container();

      productCard = Center(
        child: Text('No Product Found please add some'),
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }
}
