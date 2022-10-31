part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProfileUpdate extends ProfileEvent{
  const ProfileUpdate({required this.userId, required this.passNew, required this.newName});
  final String newName;
  final String passNew;
  final int userId;
}
