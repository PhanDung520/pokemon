import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/login_page/login_state.dart';

import '../../models/user.dart';
import '../../utils/utils.dart';

Future<void> initUser(List<User> listUser) async{
  await firestore.collection('users').get().then((value) => {
    value.docs.forEach((element) {
      User user = User(element['username'], element['password'], element['userId']);
      listUser.add(user);
    })
  });
}

final userLoginProvider = StateProvider((ref) => User('name', 'password', 5));
final loginStateProvider = StateProvider((ref) => LoginState(LoginStatus.errorUserPass));

class LoginController{
  Future<void> Login(String name, String pass, WidgetRef ref) async{
    List<User> userList = [];
    await initUser(userList);
    for(User user in userList){
      if(user.name == name && user.password == pass){
        ref.read(loginStateProvider.notifier).state = LoginState(LoginStatus.success);
        ref.read(userLoginProvider.notifier).state = user;
      }else{
        ref.read(loginStateProvider.notifier).state = LoginState(LoginStatus.errorUserPass);
      }
    }
}
}