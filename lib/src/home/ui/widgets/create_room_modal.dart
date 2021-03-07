import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CreateRoomModal extends StatefulWidget {
  CreateRoomModal({Key key}) : super(key: key);

  @override
  _CreateRoomModalState createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  TextEditingController ctrlEmail = new TextEditingController();
  bool loading = false;
  String url = "https://chatappjf.herokuapp.com";

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        color: Color(0xFF737373),
        child: Stack(children: [
          body(context),
          StreamBuilder(
              stream: authBloc.loadingStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                loading = snapshot.data ?? false;
                return loading
                    ? Loading(colorVariable: Color.fromRGBO(255, 255, 255, 0.0))
                    : Container();
              })
        ]));
  }

  Widget body(context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
      child: Column(children: [
        Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Icon(Icons.drag_handle)),
        Container(
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
            child: TextField(
                controller: ctrlEmail,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (string) async {
                  if (ctrlEmail.text == null || ctrlEmail.text == '') {
                    showToast("You must enter the user's email!", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  } else {
                    authBloc.setIsLoading(true);
                    var response = await http.get(
                        Uri.encodeFull('$url/users/ByEmail/${ctrlEmail.text}'));
                    var jsonResponse = convert.jsonDecode(response.body);
                    if (jsonResponse == null) {
                      Navigator.of(context).pop();
                      showToast("There is no user with that email!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      authBloc.setIsLoading(false);
                    } else {
                      Navigator.of(context).pop();
                      print(jsonResponse);
                      authBloc.setIsLoading(false);
                    }
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.blue),
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: '* User Email'))),
        SizedBox(height: 15),
        RaisedButton(
            padding: EdgeInsets.only(left: 50, right: 50),
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.blue)),
            onPressed: () {
              if (ctrlEmail.text == null || ctrlEmail.text == '') {
                showToast("You must enter the user's email!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              } else {
                print(ctrlEmail.text);
              }
            },
            child:
                new Text('Create Room', style: TextStyle(color: Colors.white)))
      ]),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight: const Radius.circular(25))),
    );
  }

  void showToast(String msg, context, {int duration, int gravity}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }
}
