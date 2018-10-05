import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';


class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final String usuario = 'jeffryrodriguez08@gmail.com';
  final String password = '123456';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/login_background.jpg'));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      // Manejar placeholder y demas dentro del input
      decoration: InputDecoration(
          labelText: 'Username', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        //  if (value.trim().length == 0) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Coloque un usuario';
        }
      }, // Datos
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      controller: _passwordTextController,
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

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      // Manejar placeholder y demas dentro del input
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        //  if (value.trim().length == 0) {
        if (_passwordTextController.text != value) {
          return 'passwords do not match';
        }
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

  void _submitForm(Function authenticate) async {
    if (!_formkey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formkey.currentState.save();
    Map<String, dynamic> successInformation;
   
      successInformation =
          await authenticate(_formData['email'], _formData['password'], _authMode);
  
      if (successInformation['success']) {
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Un error ha ocurrido'),
                content: Text(successInformation['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    
  }

//       if(_formData['email'] == usuario && _formData['password'] == password) {

//       } else {
//         AlertDialog(title: Text('incorrecto'));
//   }

  @override
  Widget build(BuildContext context) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
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
                      _buildEmailTextField(),
                      SizedBox(height: 10.0),
                      _buildPasswordTextField(),
                      SizedBox(
                        width: 10.0,
                      ),
                      _authMode == AuthMode.Signup
                          ? _buildPasswordConfirmTextField()
                          : Container(),
                      _buildAcceotSwitch(),
                      SizedBox(
                        width: 10.0,
                      ),
                      FlatButton(
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'Registrarme' : 'Iniciar Seccion'} '),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.Login
                                ? AuthMode.Signup
                                : AuthMode.Login;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ScopedModelDescendant(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return model.isLoading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  child: Text(_authMode == AuthMode.Login
                                      ? 'acceder'
                                      : 'Registrar'),
                                  onPressed: () =>  _submitForm(model.authenticate));
                        },
                      )
                    ],
                  ),
                )),
          )),
        ));
  }
}
