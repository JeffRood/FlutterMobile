import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

class ConnectedProducts extends Model {
  List<Product> products = [];
  int setProductIndex;
  User authenticatedUser;

  void addProduct(
      String title, String description, String image, double price) {
    final Product newProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: authenticatedUser.email,
        userID: authenticatedUser.id);
    products.add(newProduct);
    setProductIndex = null;
    notifyListeners();
  }
}
