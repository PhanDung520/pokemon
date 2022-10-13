import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/login_page/viewmodels/login_state.dart';

import '../../../models/user.dart';
import '../../../utils/utils.dart';

Future<void> initUser(List<User> listUser) async{
  await firestore.collection('users').get().then((value) => {
    value.docs.forEach((element) {
      listUser.add(User(element['username'], element['password'], int.parse(element['userId'].toString()), element['name']));
    })
  });
}

final userLoginProvider = StateProvider((ref) => User('name', 'password', 5, 'name'));
final loginStateProvider = StateProvider((ref) => LoginState(LoginStatus.loading));

class LoginController{
  Future<void> Login(String name, String pass, WidgetRef ref) async{
    List<User> userList = [];
    await initUser(userList);
    int count =0;
    for(User user in userList){
      if(user.name == name && user.password == pass){
        ref.read(loginStateProvider.notifier).state = LoginState(LoginStatus.success);
        ref.read(userLoginProvider.notifier).state = user;
        count =1;
      }
    }
    if(count ==0){
      ref.read(loginStateProvider.notifier).state = LoginState(LoginStatus.errorUserPass);
    }
}
}