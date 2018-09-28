import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_products.dart';

class ProductsModel extends ConnectedProducts {


bool _showFavorites = false;
 List<Product> get allProducts {
   return List.from(products);
  }

  List<Product> get dispayedProducts {
    if(_showFavorites) {
      return products.where(
        (Product product) =>  product.isFavorite).toList();
    }
   return List.from(products);
  }
 int get selectedProductIndex {
   return setProductIndex;
 }

Product get selectedProduct {
  if (selectedProductIndex == null) {
    return null;
  }
  return products[selectedProductIndex];
}



  void deleteProduct() {
      products.removeAt(selectedProductIndex);
      setProductIndex = null;
      notifyListeners();
  }

   void updateProduct(Product product) {

      products[selectedProductIndex] = product;
      setProductIndex = null;
      notifyListeners();
  }
   void toggleProductFavoriteStatus() {
       final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = 
    Product(title: selectedProduct.title,
    description: selectedProduct.description,
    image: selectedProduct.image,
    price: selectedProduct.price,
    userEmail: selectedProduct.userEmail,
    userID: selectedProduct.userID,
    isFavorite: newFavoriteStatus,
      );
    products[selectedProductIndex] = updateProduct;
    setProductIndex = null;
    notifyListeners();
   }
 bool get displayFavoritesOnly {
  return _showFavorites;
   }
  void selectProduct(int index) {
    setProductIndex = index;
         notifyListeners();
  }
  void toggleDisplayModel() {
    _showFavorites = !_showFavorites;
     notifyListeners();
  }
}

