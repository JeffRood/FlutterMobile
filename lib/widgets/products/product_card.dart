import 'package:flutter/material.dart';
import '../../models/product.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;
  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.only(top: 1.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          // Flexible da el espacio que queramos pero no necesariamente todo el espacio
          // Flexible(
          // Flex Permite especificar la cantidad que quiero que se utilice
          TitleDefault(product.title),
          SizedBox(
            width: 8.0,
          ),
          // Se  usa Expanded si queremos el mayor espacio posible
          // Expanded(
          PriceTag(product.price.toString())
        ]));
  }

  Widget _buildActionButtons(BuildContext context) {
    return   ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
         IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + model.allProducts[productIndex].id)),
                   IconButton(
              icon: Icon(model.allProducts[productIndex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectProduct(model.allProducts[productIndex].id);
                model.toggleProductFavoriteStatus();
              }),
       ] );
          } );
        }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/login_background.jpg')),
          _buildTitlePriceRow(),
          AddressTag('Union Square, San Francisco'),
          Text(product.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
