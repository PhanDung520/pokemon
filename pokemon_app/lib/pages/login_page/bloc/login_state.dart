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
class LoginSuccess extends LoginState{}
class LoginError extends LoginState{}

