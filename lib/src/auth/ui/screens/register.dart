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
  bool isChecked = false;
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
                    Text('Crear Cuenta',
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: Offset(0, 5),
                                  blurRadius: 5),
                            ]),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: CheckboxListTile(
                            activeColor: Colors.red,
                            title: Text('¡Acepto los términos y condiciones!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                isChecked = val;
                              });
                            })),
                    Container(
                        margin:
                            EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: RegisterButton(
                            buildErrorDialog: _buildErrorDialog,
                            isChecked: isChecked)),
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
          Text('¿Ya tienes cuenta?'),
          Text(' Iniciar Sesión',
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
              txtTitle: 'Mensaje De Error',
              txtContentInput: (_message ==
                      "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)")
                  ? "¡La dirección de correo electrónico ya está en uso por otra cuenta!"
                  : _message,
              txtPrimaryButton: '¡Entendido!',
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
