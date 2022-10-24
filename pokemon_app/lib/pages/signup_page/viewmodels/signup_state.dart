// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState{
  const factory SignUpState.loading() = _Loading;

  const factory SignUpState.error({String? errorText}) = _Error;

  const factory SignUpState.available() = _Available;
}