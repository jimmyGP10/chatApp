import 'package:chat_app/src/auth/ui/screens/login.dart';
import 'package:chat_app/src/home/ui/screens/home.dart';
import 'package:chat_app/src/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SessionHandler extends StatefulWidget {
  const SessionHandler({Key key}) : super(key: key);

  @override
  _SessionHandlerState createState() => _SessionHandlerState();
}

class _SessionHandlerState extends State<SessionHandler> {
  var userAuth;
  final LocalStorage storage = new LocalStorage('ChatApp-JF');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (context, snapStorage) {
          if (snapStorage.data == null) {
            return Loading(colorVariable: Color.fromRGBO(255, 255, 255, 1));
          } else {
            userAuth = storage.getItem('userAuth');
            if (userAuth == null) {
              return Login();
            } else {
              return Home();
            }
          }
        });
  }
}
