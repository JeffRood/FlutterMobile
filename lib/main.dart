import 'package:flutter/material.dart';
import './models/product.dart';
import './pages/auth.dart';
import './pages/productsAdmin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';

import 'package:scoped_model/scoped_model.dart';
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
  
  @override
  Widget build(context) {
   final MainModel model  = MainModel();
    return ScopedModel<MainModel>(
       model: model,
      child:
    MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,          
          
          ),
          
      // home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(model),
        '/admin': (BuildContext context) =>
            ProductsAdminPage(model)
      },
      // on generateRoute es una funcion para manejar rutas no registrada en las rutas de arriba
      onGenerateRoute: (RouteSettings setting) {
        final List<String> pathElements = setting.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final String productId= pathElements[2];
         final Product product = model.allProducts.firstWhere((Product product) {
            return product.id == productId;
         });
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => 
            ProductPage(product),
          );
        }
        return null;
      },

      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(model));
      },
    ) );
    
    
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
