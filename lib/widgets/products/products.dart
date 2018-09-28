import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
class Products extends StatelessWidget {
  // Final es para decir que la lista esta vacia y se llena luego del construtor


  Widget _buildProductsList(List<Product> products) {
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
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model ) {
      
        return _buildProductsList(model.dispayedProducts);
    } , );  
  }
}
