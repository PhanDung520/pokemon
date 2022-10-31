import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/profile_bloc/profile_bloc.dart';
import 'package:pokemon_app/values/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/user.dart';

showEditDialog(BuildContext context, User user) {
  TextEditingController c1 = TextEditingController(text: user.password);
  TextEditingController c2 = TextEditingController(text: user.nameDisplay);
  // set up the button
  Widget okButton = TextButton(
    child: Text(AppLocalizations.of(context)!.cancel),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget editButton = BlocProvider(
  create: (context) => ProfileBloc(),
  child: BlocConsumer<ProfileBloc, ProfileState>(
    listener: (context, state) {
      if(state is ProfileSuccess){
        Navigator.of(context).pop();
        showDoneDialog(context, AppLocalizations.of(context)!.done);
      }
      if(state is ProfileError){
        Navigator.of(context).pop();
        showDoneDialog(context,  AppLocalizations.of(context)!.error);
      }
    },
    builder: (context, state) {
    return TextButton(
    child: Text(AppLocalizations.of(context)!.edit),
    onPressed: () async {
      context.read<ProfileBloc>().add(ProfileUpdate(userId: user.userId, passNew: c1.text, newName: c2.text));
    },
  );
  },
),
);

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Edit name and password"),
    content: SizedBox(height: MediaQuery.of(context).size.height*0.16 ,
      child: Column(children: [
        Row(
          children: [
            Text('${ AppLocalizations.of(context)!.username}: '),
            Text(user.username)
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
  // Widget okButton = TextButton(
  //   child: Text(AppLocalizations.of(context)!.ok),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(AppLocalizations.of(context)!.notification),
    content: SizedBox(height: MediaQuery.of(context).size.height*0.15 ,
        child: Center(child:
        Text(text),)),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}