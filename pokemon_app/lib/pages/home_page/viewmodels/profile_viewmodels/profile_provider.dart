import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/viewmodels/profile_viewmodels/profile_state.dart';
import 'package:pokemon_app/utils/utils.dart';

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier,ProfileState >((ref) {
  return ProfileNotifier();
});


class ProfileNotifier extends StateNotifier<ProfileState>{
  ProfileNotifier(): super(const ProfileState.loading());
  Future<void> EditPassword(String passNew,String newName, int userId) async{
    await firestore.collection('users').doc(userId.toString()).update(
        {
          'password': passNew,
          'name': newName
        }
    ).then((value) => state = const ProfileState.done())
        .catchError((e)=>state = const ProfileState.error());
  }
}