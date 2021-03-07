import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/utils/session_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterButton extends StatefulWidget {
  final Function buildErrorDialog;
  const RegisterButton({Key key, @required this.buildErrorDialog})
      : super(key: key);

  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  final LocalStorage storage = new LocalStorage('ChatApp-JF');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authBloc.getUserFields,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return _registerButton(context, snapshot.data);
        });
  }

  Widget _registerButton(context, data) {
    String url = "https://chatappjf.herokuapp.com";
    return RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        shape: StadiumBorder(),
        onPressed: () async {
          if (data['name'] == null ||
              data['name'] == '' ||
              data['email'] == null ||
              data['email'] == '' ||
              data['password'] == null ||
              data['password'] == '') {
            showToast('The fields with (*) are required!', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          } else {
            var emailValidation = validateEmail(data['email']);
            if (emailValidation == null) {
              int passwordValidation = data['password'].length;
              if (passwordValidation < 6) {
                showToast(
                    'The password must be at least 6 characters!', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              } else {
                register(data['email'], data['password'], data['name'], url,
                    context);
              }
            } else {
              showToast('¡$emailValidation!', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            }
          }
        },
        child: Container(
            width: double.infinity,
            height: 50,
            child: Center(
                child: Text('Register',
                    style: TextStyle(color: Colors.white, fontSize: 17)))));
  }

  navigation(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SessionHandler()),
        (Route<dynamic> route) => false);
  }

  void showToast(String msg, context, {int duration, int gravity}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        backgroundColor: Color.fromRGBO(0, 166, 0, 1),
        textColor: Colors.white);
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email';
    else
      return null;
  }

  register(email, password, names, url, context) async {
    authBloc.setIsLoading(true);
    try {
      AuthResult result =
          await authBloc.createUserWithEmailAndPassword(email, password);
      if (result.user.uid != null) {
        var response = await http.post(Uri.encodeFull('$url/users/add'),
            body: convert.json.encode({
              "name": names,
              "email": email,
              "uid": result.user.uid,
            }),
            headers: {'content-type': 'application/json'});
        print('response.body' + response.body);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          storage.setItem('userAuth', jsonResponse);
          authBloc.setIsLoading(false);
          navigation(context);
        } else {
          print('Request failed with status: ${response.statusCode}.');
          authBloc.setIsLoading(false);
        }
      }
      authBloc.setIsLoading(false);
    } on AuthException catch (error) {
      authBloc.setIsLoading(false);
      return widget.buildErrorDialog(context, error.message);
    } on Exception catch (error) {
      authBloc.setIsLoading(false);
      return widget.buildErrorDialog(context, error.toString());
    }
  }
}
