import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
   final Map<String, dynamic> _formData = {
   'email' : null,
   'password' : null,
   'acceptTerms' : false
 };
  final String usuario = 'jeffryrodriguez08@gmail.com';
  final String password = '123456';
   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/login_background.jpg'));
  }

  Widget _buildUserTextField() {
    return TextFormField(
      // Manejar placeholder y demas dentro del input
      decoration: InputDecoration(
          labelText: 'Username', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
        validator: (String value) {
       //  if (value.trim().length == 0) {
         if (value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
          return 'Coloque un usuario';
        }
      },       // Datos
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
           validator: (String value) {
       //  if (value.trim().length == 0) {
         if (value.isEmpty) {
          return 'Coloque una contraseña';
        } 
           },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceotSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Acceot Terns'),
    );
  }

  void _submitForm() {
    if (!_formkey.currentState.validate() || !_formData['acceptTerms']) {
        return;
    }
      _formkey.currentState.save();
         print(_formData);
    Navigator.pushReplacementNamed(context, '/products');

//       if(_formData['email'] == usuario && _formData['password'] == password) {

//       } else {
//         AlertDialog(title: Text('incorrecto'));
//   }
  }
  @override
  Widget build(BuildContext context) {
    final double devicewidth = MediaQuery.of(context).size.width; 
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth  * 0.95;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(10.0),
          // Diferencia de single y el Listview es que este solo tiene un child
          child: Center(
              child: SingleChildScrollView(
            child: Container(
              width: targetwidth,
              child: Form(
                key: _formkey,
                child: Column(
                children: <Widget>[
                  _buildUserTextField(),
                  SizedBox(height: 10.0),
                  _buildPasswordTextField(),
                  _buildAcceotSwitch(),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(child: Text('Login'), onPressed: _submitForm),
                ],
              ),
            )),
          )),
        ));
  }
}
