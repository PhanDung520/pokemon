import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/signup_page/viewmodels/signup_state.dart';
import 'package:pokemon_app/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


final textSignUpStateProvider = StateProvider.family((ref, BuildContext context) =>AppLocalizations.of(context)!.signup);


final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier();
});

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier(): super(const SignUpState.loading());
  Future<void> signUp(String name, String password, String nameDisplay) async {
    //get the last id
    int idLast = 0;
    await firestore.collection('users').get().then((value) => {
      for(var element in value.docs){
        idLast = int.parse(element.id)
      }
    });
    if(idLast == 0){
      //error
      state = const SignUpState.error(errorText: 'Cannot reference to all user');
    }else{
      // do add
      idLast++;
      await firestore.collection('users').doc(idLast.toString()).set({
        'password': password,
        'username': name,
        'name': nameDisplay,
        'userId': idLast.toString()
      });
      await firestore.collection('users').doc(idLast.toString()).collection('favourite').doc('999').set({});
      state = const SignUpState.available();
    }
  }
}