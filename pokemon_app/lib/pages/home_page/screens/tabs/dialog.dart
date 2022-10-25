import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/viewmodels/profile_viewmodels/profile_provider.dart';
import 'package:pokemon_app/pages/home_page/viewmodels/profile_viewmodels/profile_state.dart';
import 'package:pokemon_app/pages/login_page/viewmodels/login_controller.dart';
import 'package:pokemon_app/values/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showEditDialog(BuildContext context, WidgetRef ref, int userId) {

  TextEditingController c1 = TextEditingController(text: ref.watch(userLoginProvider).password);
  TextEditingController c2 = TextEditingController(text: ref.watch(userLoginProvider).nameDisplay);
  // set up the button
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.cancel),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget editButton = TextButton(
    child: Text(AppLocalizations.of(context)!.edit),
    onPressed: () async {
      await ref.read(profileNotifierProvider.notifier).editPassword(c1.text, c2.text, userId);
      if(ref.watch(profileNotifierProvider) == const ProfileState.done()){

        Navigator.of(context).pop();
        showDoneDialog(context, AppLocalizations.of(context)!.done);
      }
      if(ref.watch(profileNotifierProvider) == const ProfileState.error()){
        Navigator.of(context).pop();
        showDoneDialog(context,  AppLocalizations.of(context)!.error);
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Edit name and password"),
    content: SizedBox(height: MediaQuery.of(context).size.height*0.16 ,
    child: Column(children: [
      Row(
        children: [
          Text('${ AppLocalizations.of(context)!.username}: '),
          Text(ref.watch(userLoginProvider).name)
        ],
      ),
      Row(
        children: [
          Container(alignment: Alignment.bottomLeft,width: 100,child: Text('${ AppLocalizations.of(context)!.password}: ')),
          Expanded(child:
          TextField(style: const TextStyle(color: AppColors.lightTextColor), controller: c1, obscureText: true,))
        ],
      ),
      Row(
        children: [
          Container(alignment: Alignment.bottomLeft,width: 100,child: const Text('Name: ')),
          Expanded(child: TextField(style: const TextStyle(color: AppColors.lightTextColor),controller: c2,))

        ],
      )

    ],),),
    actions: [
      okButton,
      editButton
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

showDoneDialog(BuildContext context, String text) {

  // set up the button
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.ok),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(AppLocalizations.of(context)!.notification),
    content: SizedBox(height: MediaQuery.of(context).size.height*0.15 ,
      child: Center(child:
        Text(text),)),
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