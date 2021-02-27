import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/auth/ui/screens/register.dart';
import 'package:chat_app/src/auth/ui/widgets/auth_form.dart';
import 'package:chat_app/src/auth/ui/widgets/login_button.dart';
import 'package:chat_app/src/auth/ui/widgets/password_recovery.dart';
import 'package:chat_app/src/utils/global_alert_dialog.dart';
import 'package:chat_app/src/utils/loading.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _buildUI(),
      StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading
                ? Loading(colorVariable: Color.fromRGBO(255, 255, 255, 0.4))
                : Container();
          })
    ]);
  }

  Widget _buildUI() {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                    Container(height: 200, width: 200, child: Text('ChatApp')),
                    AuthForm(
                        from: 'login',
                        ctrlEmail: ctrlEmail,
                        ctrlName: null,
                        ctrlPassword: ctrlPassword,
                        setEmail: setEmail,
                        setName: null,
                        setPassword: setPassword),
                    PasswordRecovery(),
                    Container(
                        margin: EdgeInsets.only(
                            top: 50, bottom: 20, left: 20, right: 20),
                        child: LoginButton(buildErrorDialog: buildErrorDialog)),
                    _registerOption(context),
                  ]))),
        )));
  }

  Widget _registerOption(context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Register()));
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('¿No tienes cuenta?'),
          Text(' Crear Cuenta',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700))
        ]));
  }

  Future buildErrorDialog(BuildContext context, _message) {
    return showDialog(
        context: context,
        builder: (context) {
          return GlobalAlertDialog(
              isInput: false,
              ctrlInput: null,
              typeInput: null,
              txtTitle: null,
              txtContentInput: "¡El correo o la contraseña son incorrectas!",
              txtPrimaryButton: '¡Entendido!',
              txtSecondaryButton: null,
              primaryButton: hideAlertDialog,
              secondaryButton: null);
        });
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
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
}
