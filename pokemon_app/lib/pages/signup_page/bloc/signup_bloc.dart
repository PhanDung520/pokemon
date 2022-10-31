import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pages/signup_page/bloc/signup_event.dart';
import 'package:pokemon_app/pages/signup_page/bloc/signup_state.dart';

import '../../../utils/firebase_reference.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{
  SignUpBloc():super(SignUpInitial()){
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(SignUpSubmitted event, Emitter emitter) async {
   emit(SignUpLoading());
   if(event.username != '' && event.password !='' && event.name != ''){
     final available = await signUp(event.username, event.password, event.name);
     if(available == false){
       return emitter(SignUpError());
     }else{
       return emitter(SignUpSuccess());
     }
   }else{
     return emitter(SignUpError());
   }
  }
  Future<bool> signUp(String name, String password, String nameDisplay) async {
    //get the last id
    int idLast = 0;
    await firestore.collection('users').get().then((value) => {
      for(var element in value.docs){
        idLast = int.parse(element.id)
      }
    });
    if(idLast == 0){
      //error
      return false;
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
      return true;
    }
  }
}