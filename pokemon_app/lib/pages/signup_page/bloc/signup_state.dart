import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable{
  const SignUpState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SignUpInitial extends SignUpState{}
class SignUpLoading extends SignUpState{}
class SignUpSuccess extends SignUpState{}
class SignUpError extends SignUpState{}

