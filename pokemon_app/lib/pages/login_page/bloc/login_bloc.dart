import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/login_page/bloc/login_event.dart';
import 'package:pokemon_app/pages/login_page/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/firebase_reference.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc(): super(LoginInitial()){
    on<LoginSubmitted>(_onLoginSubmmited);
  }


  void _onLoginSubmmited(LoginSubmitted event , Emitter emitter) async{
    // emit la hanh dong phat ra event
    emit(LoginLoading());
    final listUser = await _tryGetAllUser();
    if(listUser.isEmpty){
      return emitter(LoginError());
    }else{
      //tim user trong list
      int count =0;
      for(User user in listUser){
        if(user.username == event.username && user.password == event.password){
          count =1;
          return emitter(LoginSuccess(user: user));
        }
      }
      if(count == 0){
        return emitter(LoginError());
      }
    }
  }
  Future<List<User>> _tryGetAllUser() async{
    List<User> listUser =[];
    await firestore.collection('users').get().then((value) => {
      for(var element in value.docs){
        listUser.add(User(username: element['username'], password: element['password'], userId: int.parse(element['userId']), nameDisplay: element['name']))
      }
    });
    return listUser;
  }
}