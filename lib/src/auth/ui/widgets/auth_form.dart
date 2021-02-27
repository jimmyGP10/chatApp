import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final String from;
  final TextEditingController ctrlName;
  final TextEditingController ctrlEmail;
  final TextEditingController ctrlPassword;
  final Function setName;
  final Function setEmail;
  final Function setPassword;
  const AuthForm(
      {Key key,
      @required this.from,
      @required this.ctrlName,
      @required this.ctrlEmail,
      @required this.ctrlPassword,
      @required this.setName,
      @required this.setEmail,
      @required this.setPassword})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: authBloc.getUserFields,
        builder: (context, snapshot) {
          return Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                (this.widget.from == 'register')
                    ? textField(
                        "* Nombres y Apellidos",
                        Icon(Icons.perm_identity),
                        null,
                        false,
                        'text',
                        widget.ctrlName,
                        widget.setName,
                        snapshot.data)
                    : Container(),
                SizedBox(height: 15),
                textField("* Correo", Icon(Icons.mail_outline), null, false,
                    'email', widget.ctrlEmail, widget.setEmail, snapshot.data),
                SizedBox(height: 15),
                textField(
                    '* Contraseña',
                    Icon(Icons.lock_outline),
                    (_isPasswordHidden == true)
                        ? Icon(Icons.visibility_off, color: Colors.grey)
                        : Icon(Icons.visibility, color: Colors.grey),
                    _isPasswordHidden,
                    'text',
                    widget.ctrlPassword,
                    widget.setPassword,
                    snapshot.data),
              ]));
        });
  }

  Widget textField(String placeHolder, Icon icon, Icon iconRight, obscureText,
      type, TextEditingController controller, Function setData, userMap) {
    return Container(
        padding: EdgeInsets.only(top: 3, left: 5, bottom: 3, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5),
            ]),
        child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            onChanged: (value) {
              setData(userMap, value);
            },
            keyboardType: (type == 'text')
                ? TextInputType.text
                : (type == 'email')
                    ? TextInputType.emailAddress
                    : TextInputType.number,
            decoration: InputDecoration(
                prefixIcon: icon,
                suffixIcon: (iconRight == null)
                    ? iconRight
                    : GestureDetector(
                        child: iconRight,
                        onTap: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        }),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: placeHolder)));
  }
}
