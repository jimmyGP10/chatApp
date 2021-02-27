import 'package:chat_app/src/auth/bloc/bloc_auth.dart';
import 'package:chat_app/src/utils/global_alert_dialog.dart';
import 'package:flutter/material.dart';

class PasswordRecovery extends StatefulWidget {
  PasswordRecovery({Key key}) : super(key: key);

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  String email;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text('¿Olvidaste la contraseña?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
        onTap: () {
          _passwordRecovery(context);
        });
  }

  _passwordRecovery(context) {
    showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder(
              stream: authBloc.getUserFields,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return GlobalAlertDialog(
                      isInput: false,
                      ctrlInput: null,
                      typeInput: null,
                      txtTitle: null,
                      txtContentInput:
                          "No hay ningún correo para realizar el proceso de cambio de contraseña.",
                      txtPrimaryButton: null,
                      txtSecondaryButton: 'Entendido',
                      primaryButton: null,
                      secondaryButton: hideAlertDialog);
                } else {
                  var data = snapshot.data;
                  if (data['email'] == null || data['email'] == '') {
                    return GlobalAlertDialog(
                        isInput: false,
                        ctrlInput: null,
                        typeInput: null,
                        txtTitle: null,
                        txtContentInput:
                            "No hay ningún correo para realizar el proceso de cambio de contraseña.",
                        txtPrimaryButton: null,
                        txtSecondaryButton: 'Entendido',
                        primaryButton: null,
                        secondaryButton: hideAlertDialog);
                  } else {
                    email = data['email'];
                    return GlobalAlertDialog(
                        isInput: false,
                        ctrlInput: null,
                        typeInput: null,
                        txtTitle: null,
                        txtContentInput:
                            "Se enviara un correo a $email para realizar el proceso de cambio de contraseña.",
                        txtPrimaryButton: 'Enviar',
                        txtSecondaryButton: 'Cancelar',
                        primaryButton: sendRecoveryPassword,
                        secondaryButton: hideAlertDialog);
                  }
                }
              });
        });
  }

  sendRecoveryPassword(context) {
    authBloc.sendPasswordResetEmail(email);
    Navigator.pop(context);
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
  }
}
