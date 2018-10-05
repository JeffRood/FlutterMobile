import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../models/user.dart';
import 'dart:async';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  String url = 'https://flutter-products-cfe85.firebaseio.com/products';
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;
  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get dispayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deleteProductID = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(url + '/' + deleteProductID + '.json')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.mercedes-benz.com/wp-content/uploads/sites/3/2018/07/04-mercedes-benz-mbsocialcar-mercedes-amg-gle-43-4matic-coupe-c-292-2560x1440-848x477.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userID': _authenticatedUser.id
    };
    try {
      final http.Response response =
          await http.post(url + '.json', body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> reponseData = json.decode(response.body);

      final Product newProduct = Product(
          id: reponseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userID: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    // _isLoading = false;
    //   notifyListeners();
    //     return false;
    // });
  }

  Future<Null> fetctProduct() {
    _isLoading = true;
    notifyListeners();
    return http.get(url + '.json?auth=${_authenticatedUser.token}').then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productID, dynamic productData) {
        final Product product = Product(
            id: productID,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userID: productData['userID']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://www.mercedes-benz.com/wp-content/uploads/sites/3/2018/07/04-mercedes-benz-mbsocialcar-mercedes-amg-gle-43-4matic-coupe-c-292-2560x1440-848x477.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userID': selectedProduct.userID
    };
    return http
        .put(url + '/' + selectedProduct.id + '.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userID: selectedProduct.userID);

      _products[selectedProductIndex] = updatedProduct;

      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      userEmail: selectedProduct.userEmail,
      userID: selectedProduct.userID,
      isFavorite: newFavoriteStatus,
    );

    _products[selectedProductIndex] = updateProduct;

    notifyListeners();
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayModel() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UsersModel extends ConnectedProductsModel {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCAfpZp3RvS9rdw0KQHQnXEUkGy61Wp_pI',
          body: json.encode(authData),
          headers: {'content-type': 'application/json'});
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCAfpZp3RvS9rdw0KQHQnXEUkGy61Wp_pI',
          body: json.encode(authData),
          headers: {'content-type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Algo va mal, revisa la conexion a internet';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Autentificacion correctamente';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken:']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Este correo ya esta siendo utilizado';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Usuario o contraseña no son correcto';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Usuario o contraseña no son correcto';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
