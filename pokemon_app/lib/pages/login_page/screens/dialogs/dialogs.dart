import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.ok),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(AppLocalizations.of(context)!.errorLogin),
    content: Text(AppLocalizations.of(context)!.errorLogin2),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
showProgessCir(BuildContext context) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator(),);
    },
  );
}

showAlertDialogIfError(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.ok),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(AppLocalizations.of(context)!.errorLogin),
    content: Text(AppLocalizations.of(context)!.errorInternet),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}