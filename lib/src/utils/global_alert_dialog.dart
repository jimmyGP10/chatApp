import 'package:flutter/material.dart';

class GlobalAlertDialog extends StatelessWidget {
  final bool isInput;
  final TextEditingController ctrlInput;
  final String typeInput;
  final String txtTitle;
  final String txtContentInput;
  final String txtPrimaryButton;
  final String txtSecondaryButton;
  final Function primaryButton;
  final Function secondaryButton;
  const GlobalAlertDialog({
    Key key,
    @required this.isInput,
    @required this.ctrlInput,
    @required this.typeInput,
    @required this.txtTitle,
    @required this.txtContentInput,
    @required this.txtPrimaryButton,
    @required this.txtSecondaryButton,
    @required this.primaryButton,
    @required this.secondaryButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: (txtTitle == null) ? Container() : Text(txtTitle),
        content: (isInput)
            ? TextFormField(
                controller: ctrlInput,
                keyboardType: (typeInput == 'text')
                    ? TextInputType.text
                    : TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    labelText: txtContentInput,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(7.0),
                    )))
            : Text(txtContentInput),
        actions: <Widget>[
          (txtSecondaryButton == null)
              ? Container()
              : FlatButton(
                  onPressed: () {
                    secondaryButton(context);
                  },
                  child: Text(txtSecondaryButton,
                      style: TextStyle(color: Colors.red))),
          (txtPrimaryButton == null)
              ? Container()
              : FlatButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    primaryButton(context);
                  },
                  child: Text(txtPrimaryButton))
        ]);
  }
}
