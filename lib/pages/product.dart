import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;
ProductPage(this.product);


  Widget _buildAdressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text('\$' + price.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child:  Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            // Centra;
            // centerTitle: true,
          ),
          body: Column(
            //centra a de arriba a abajo
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                    FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/login_background.jpg')),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(product.title),
              ),
              _buildAdressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
    ),
    );
  }
}
