import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/utils/session_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginButton extends StatelessWidget {
  final Function buildErrorDialog;
  const LoginButton({Key key, @required this.buildErrorDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = "https://chatappjf.herokuapp.com";
    final LocalStorage storage = new LocalStorage('ChatApp-JF');
    return StreamBuilder(
        stream: authBloc.getUserFields,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
              elevation: 2,
              highlightElevation: 5,
              color: Colors.blue,
              shape: StadiumBorder(),
              onPressed: () async {
                var data = snapshot.data;
                print(data);
                if (data['email'] == null ||
                    data['email'] == '' ||
                    data['password'] == null ||
                    data['password'] == '') {
                  showToast('The fields with (*) are required!', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                } else {
                  var emailValidation = validateEmail(data['email']);
                  if (emailValidation == null) {
                    login(
                        data['email'], data['password'], url, storage, context);
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
                      child: Text('LogIn',
                          style:
                              TextStyle(color: Colors.white, fontSize: 17)))));
        });
  }

  login(email, password, url, storage, context) async {
    authBloc.setIsLoading(true);
    try {
      AuthResult result =
          await authBloc.signInWithEmailAndPassword(email, password);
      if (result.user.uid != null) {
        var response = await http
            .get(Uri.encodeFull('$url/users/ByUid/${result.user.uid}'));
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          print(jsonResponse);
          storage.setItem('userAuth', jsonResponse);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SessionHandler()),
              (Route<dynamic> route) => false);
          authBloc.setIsLoading(false);
        } else {
          print('Request failed with status: ${response.statusCode}.');
          authBloc.setIsLoading(false);
        }
      }
    } on AuthException catch (error) {
      authBloc.setIsLoading(false);
      return buildErrorDialog(context, error.message);
    } on Exception catch (error) {
      authBloc.setIsLoading(false);
      return buildErrorDialog(context, error.toString());
    }
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
}
