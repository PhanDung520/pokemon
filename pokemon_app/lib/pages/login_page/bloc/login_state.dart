import 'package:equatable/equatable.dart';
import 'package:pokemon_app/models/user.dart';

abstract class LoginState extends Equatable{
  const LoginState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginInitial extends LoginState{}
class LoginLoading extends LoginState{}
class LoginSuccess extends LoginState{
  const LoginSuccess({required this.user});
  final User user;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LoginError extends LoginState{}

