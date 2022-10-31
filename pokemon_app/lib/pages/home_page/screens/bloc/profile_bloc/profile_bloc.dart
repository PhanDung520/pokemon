import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../utils/firebase_reference.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileUpdate>((event, emit) async {
      await firestore.collection('users').doc(event.userId.toString()).update(
          {
            'password': event.passNew,
            'name': event.newName
          }
      ).then((v)=> emit(ProfileSuccess()))
      .catchError((e)=>emit(ProfileError()));
    });
  }
}
