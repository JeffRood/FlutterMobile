import 'package:flutter/material.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';


class ProductsPage extends StatelessWidget {



Widget _buildSideDrawer(BuildContext context) {
  return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            )
          ],
        ),
      );
}


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer:  _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Sisalril App'),
        actions: <Widget>[
        
        ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {

          return   IconButton(
            icon: Icon(model.displayFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            color: Colors.blue,
            onPressed: () {
              model.toggleDisplayModel();
            },
          );
      } ),
     
        ],
        centerTitle: true,
      ),
      body: Products(),
    );
  }
}
