import 'package:flutter/material.dart';
import './pages/auth.dart';
import './pages/productsAdmin.dart';
import './pages/products.dart';
import './pages/product.dart';

// import 'package:flutter/rendering.dart';
main() {
// debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];
  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

   void _updateProduct(int index, Map<String,dynamic> product) {
    setState(() {
      _products[index] = product;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,          
          
          ),
          
      // home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) =>
            ProductsAdminPage(_addProduct, _updateProduct ,_deleteProduct, _products)
      },
      // on generateRoute es una funcion para manejar rutas no registrada en las rutas de arriba
      onGenerateRoute: (RouteSettings setting) {
        final List<String> pathElements = setting.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                _products[index]['title'],
                _products[index]['image'],
                _products[index]['price'],
             _products[index]['description'] ),
          );
        }
        return null;
      },

      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }
}

// class _MyAppState extends StatelessWidget {
//   @override
//   Widget build(context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Jeffry Rodriguez'),
//         ),
//         body:
//         Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.all(10.0),
//               child: RaisedButton(
//                 onPressed: () {},
//                 child: Text('Add Product'),
//               ),
//             ),
//             Card(
//               child: Column(
//                 children: <Widget>[
//                   Image.asset('./assets/logo.png'),
//                   Text('Sisalril')
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
