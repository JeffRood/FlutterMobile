import 'package:flutter/material.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';


class ProductsPage extends StatefulWidget { 
final MainModel model;

ProductsPage(this.model);
@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsPageState();
  }
}


class  _ProductsPageState    extends State<ProductsPage> {

  @override
  initState() {
    widget.model.fetctProduct();
    super.initState();
  }

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

Widget  _buildProductsList() {
  return ScopedModelDescendant(builder:  (BuildContext context, Widget child, MainModel model) {
  Widget context = Center(child: Text('No Product Found'),);
  if(model.dispayedProducts.length > 0 &&  !model.isLoading) {
    context = Products();
  } else if (model.isLoading) {
       context = Center(child: CircularProgressIndicator());
  }
  return RefreshIndicator( onRefresh: model.fetctProduct ,child: context) ;
  },);
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
      body:   _buildProductsList(),
    );
  }
}
