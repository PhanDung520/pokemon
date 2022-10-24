// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'offline_state.freezed.dart';

@freezed
class OfflineState with _$OfflineState{
  const factory OfflineState.internet_nofirst() = _Internet_notFirst;

  const factory OfflineState.internet_first({String? errorText}) = _Internet_first;

  const factory OfflineState.nointernet_first() = _NoInternet_first;

  const factory OfflineState.noInternet_notFirst({String? errorText}) = _NoInternet_notFirst;
}