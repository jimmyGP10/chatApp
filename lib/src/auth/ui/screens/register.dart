import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/auth/ui/screens/login.dart';
import 'package:chat_app/src/auth/ui/widgets/auth_form.dart';
import 'package:chat_app/src/auth/ui/widgets/register_button.dart';
import 'package:chat_app/src/utils/global_alert_dialog.dart';
import 'package:chat_app/src/utils/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  static const route = "register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  TextEditingController ctrlName = new TextEditingController();
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();
    authBloc.setIsLoading(false);
    Map<String, dynamic> mapProduct = {};
    authBloc.setUserFormFields(mapProduct);
  }

  @override
  void dispose() {
    super.dispose();
    authBloc.setUserFormFields(null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildUI(),
        StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading
                ? Loading(colorVariable: Color.fromRGBO(255, 255, 255, 0.4))
                : Container();
          },
        ),
      ],
    );
  }

  _buildUI() {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Create Account',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w900)),
                    AuthForm(
                        from: 'register',
                        ctrlEmail: ctrlEmail,
                        ctrlName: ctrlName,
                        ctrlPassword: ctrlPassword,
                        setEmail: setEmail,
                        setName: setName,
                        setPassword: setPassword),
                    Container(
                        margin:
                            EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: RegisterButton(
                            buildErrorDialog: _buildErrorDialog)),
                    _loginOption(context),
                  ]),
            ),
          ),
        )));
  }

  Widget _loginOption(context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Login()));
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Do you already have an account?'),
          Text(' Log in',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700))
        ]));
  }

  Future _buildErrorDialog(BuildContext context, String _message) {
    return showDialog(
        context: context,
        builder: (context) {
          return GlobalAlertDialog(
              isInput: false,
              ctrlInput: null,
              typeInput: null,
              txtTitle: 'Error message',
              txtContentInput: (_message ==
                      "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)")
                  ? "The email address is already in use by another account!"
                  : _message,
              txtPrimaryButton: 'Ok!',
              txtSecondaryButton: null,
              primaryButton: hideAlertDialog,
              secondaryButton: null);
        });
  }

  setName(mapUser, value) {
    Map<String, dynamic> userMap = mapUser;
    var nameMap = Map<String, String>();
    nameMap['name'] = value;
    userMap.addAll(nameMap);
    authBloc.setUserFormFields(userMap);
  }

  setEmail(mapUser, value) {
    Map<String, dynamic> userMap = mapUser;
    var emailMap = Map<String, String>();
    emailMap['email'] = value;
    userMap.addAll(emailMap);
    authBloc.setUserFormFields(userMap);
  }

  setPassword(mapUser, value) {
    Map<String, dynamic> userMap = mapUser;
    var passwordMap = Map<String, String>();
    passwordMap['password'] = value;
    userMap.addAll(passwordMap);
    authBloc.setUserFormFields(userMap);
  }

  setStore(mapUser, value) {
    Map<String, dynamic> userMap = mapUser;
    var storeMap = Map<String, String>();
    storeMap['store'] = value;
    userMap.addAll(storeMap);
    authBloc.setUserFormFields(userMap);
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
  }
}
