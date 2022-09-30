import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../utils/utils.dart';

final listDataProvider = StateProvider<List<User>>((ref) =>[]);

Future<void> initUser(List<User> listUser) async{
  await firestore.collection('users').get().then((value) => {
    value.docs.forEach((element) {
      User user = User(element['username'], element['password'], element['userId']);
      listUser.add(user);
    })
  });
}

final userGetProvider = Provider<List<User>>((ref) {
  List<User> listUser = [];
  initUser(listUser);
  return listUser;
});
