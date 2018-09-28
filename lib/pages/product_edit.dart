import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/helpers/ensure-visible.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
 
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/logo.png'
  };
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        // Manejar placeholder y demas dentro del input
        decoration: InputDecoration(
          labelText: 'Product Title',
        ),
        initialValue: product == null ? '' : product.title,
        // Valida automaticamente pero no es preferible
        // autovalidate: true,
        validator: (String value) {
          //  if (value.trim().length == 0) {
          if (value.isEmpty || value.length < 5) {
            return 'El titulo es requerido, y debe tener minimo 5 caracteres';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
        // Datos
        // onChanged: (String value) {
        //   setState(() {
        //     _titlevalue = value;
        //   });
        // },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(labelText: 'Product Description'),
        initialValue: product == null ? '' : product.description,
        maxLines: 4,
        validator: (String value) {
          //  if (value.trim().length == 0) {
          if (value.isEmpty || value.length < 10) {
            return 'La descripcion es requerida, y debe tener minimo 10 caracteres';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue:
            product == null ? '' :  product.price.toString(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          //  if (value.trim().length == 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'El precio es requerido, y debe ser un numero';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct, [int selectedProductIndex]) {
    // Llama las validadaciones en todos los campos
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(Product(
          title: _formData['title'],
          description: _formData['description'],
          price: _formData['price'],
          image: _formData['image'],
          isFavorite: false));
    } else {
      updateProduct(
           Product(
              title: _formData['title'],
              description: _formData['description'],
              price: _formData['price'],
              image: _formData['image'],
              isFavorite: true));
    }

    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          child: Text('Save'),
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectedProductIndex ),
        );
      },
    );
  }

  Widget _buildPageContext(BuildContext context, Product product) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    final double targetpadding = devicewidth - targetwidth;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetpadding / 2),
              children: <Widget>[
                _buildTitleTextField(product),
                _buildDescriptionTextField(product),
                _buildPriceTextField(product),
                SizedBox(
                  height: 10.0,
                ),
                _buildSubmitButton(),

// GestureDetector(

//   onTap: _submitForm,
//   child:   Container(
//             color: Colors.green,
//             padding: EdgeInsets.all(5.0),
//              child: Text('Is my button'),
//           ),
// )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
   
 
       return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
         final Widget pagecontent = _buildPageContext(context, model.selectedProduct);
        return   model.selectedProductIndex == null
        ? pagecontent
        : Scaffold(
            appBar: AppBar(
              title: Text('edit product'),
            ),
            body: pagecontent,
          );
      },
    );
   
  }
}
