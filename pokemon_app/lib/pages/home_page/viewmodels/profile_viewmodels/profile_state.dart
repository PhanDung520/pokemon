// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState{
  const factory ProfileState.loading() = _Loading;

  const factory ProfileState.error() = _Error;

  const factory ProfileState.done() = _Done;

}