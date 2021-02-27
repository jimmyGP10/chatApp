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
        child: Text('Forgot your password?',
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
                          "There is no email to perform the password change process.",
                      txtPrimaryButton: null,
                      txtSecondaryButton: 'Ok',
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
                            "There is no email to perform the password change process.",
                        txtPrimaryButton: null,
                        txtSecondaryButton: 'Ok',
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
                            "An email will be sent to $email to carry out the password change process.",
                        txtPrimaryButton: 'Send',
                        txtSecondaryButton: 'Cancel',
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
