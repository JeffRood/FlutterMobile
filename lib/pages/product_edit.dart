import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
   final int productIndex;
  ProductEditPage({this.addProduct, this.updateProduct, this.product, this.productIndex});

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

  Widget _buildTitleTextField() {
    return TextFormField(
      // Manejar placeholder y demas dentro del input
      decoration: InputDecoration(
        labelText: 'Product Title',
      ),
      initialValue:
          widget.product == null ? '' : widget.product['title'],
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
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
       initialValue:
          widget.product == null ? '' : widget.product['description'],
    
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
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
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
    );
  }

  void _submitForm() {
    // Llama las validadaciones en todos los campos
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
      if(widget.product == null) {
widget.addProduct(_formData);
      } else {
        widget.updateProduct(widget.productIndex, _formData);
      }
    
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    final double targetpadding = devicewidth - targetwidth;
    final Widget pagecontent = GestureDetector(
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
                _buildTitleTextField(),
                _buildDescriptionTextField(),
                _buildPriceTextField(),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text('Save'),
                  onPressed: _submitForm,
                )
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
    // TODO: implement build
    return widget.product == null
        ? pagecontent
        : Scaffold(
            appBar: AppBar(
              title: Text('edit product'),
            ),
            body: pagecontent,
          );
  }
}
