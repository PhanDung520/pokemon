import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable{
  const SignUpEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent{
  const SignUpSubmitted({required this.username, required this.password, required this.name});
  final String username;
  final String password;
  final String name;
}