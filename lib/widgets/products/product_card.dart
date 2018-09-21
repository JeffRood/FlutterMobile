import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
class ProductCard extends StatelessWidget {
      final Map<String, dynamic> product;
      final int productIndex;
  ProductCard(this.product, this.productIndex);


Widget _buildTitlePriceRow() {
  return    Container(
              padding: EdgeInsets.only(top: 1.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Flexible da el espacio que queramos pero no necesariamente todo el espacio
                   // Flexible(
                      // Flex Permite especificar la cantidad que quiero que se utilice
                   TitleDefault(product['title']),
                    SizedBox(
                      width: 8.0,
                    ),
                    // Se  usa Expanded si queremos el mayor espacio posible
                    // Expanded(
                     PriceTag(product['price'].toString())
                  ]));
}


Widget _buildActionButtons( BuildContext context) {
  return   ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                 icon: Icon(Icons.info),
                  color: Theme.of(context).accentColor,
                  onPressed: () => Navigator.pushNamed<bool>(
                      context, '/product/' + productIndex.toString())),
               IconButton(
                 icon: Icon(Icons.favorite_border),
                 color: Colors.red,
                 onPressed: () => Navigator.pushNamed<bool>(
                      context, '/product/' + productIndex.toString())
                            )
            ],
            
  );
}
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
         _buildTitlePriceRow(),
                  AddressTag('Union Square, San Francisco'),
        _buildActionButtons(context)
        ],
      ),
    );
    }
}

