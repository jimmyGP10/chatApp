import 'package:chat_app/src/home/ui/widgets/create_room_modal.dart';
import 'package:chat_app/src/utils/side_menu.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      drawer: SideMenu(),
      appBar: AppBar(
          title: Row(children: <Widget>[
        Expanded(child: Text('ChatApp')),
        GestureDetector(
            child: Icon(Icons.add_circle_outline_rounded),
            onTap: () {
              _settingModalBottomSheet(context);
            })
      ])),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return CreateRoomModal();
        });
  }
}
