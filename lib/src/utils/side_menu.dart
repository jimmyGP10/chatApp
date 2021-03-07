import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/auth/ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final LocalStorage storage = new LocalStorage('ChatApp-JF');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (context, snapStorage) {
          if (snapStorage.data == null) {
            return Container();
          } else {
            var userAuth = storage.getItem('userAuth');
            return _container(userAuth['email'], userAuth['name'], context);
          }
        });
  }

  Widget _container(email, name, context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
          accountName: Text('$name'), accountEmail: Text('$email')),
      GestureDetector(
          child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Cerrar Sesión',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              )),
          onTap: () {
            authBloc.signOut().then((onValue) {
              storage.deleteItem('userAuth');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
            });
          })
    ]));
  }
}
