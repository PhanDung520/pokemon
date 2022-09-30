// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'detail_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$myParamsUserIdPoke {
  int get userId => throw _privateConstructorUsedError;
  Pokemon get poke => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $myParamsUserIdPokeCopyWith<myParamsUserIdPoke> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $myParamsUserIdPokeCopyWith<$Res> {
  factory $myParamsUserIdPokeCopyWith(
          myParamsUserIdPoke value, $Res Function(myParamsUserIdPoke) then) =
      _$myParamsUserIdPokeCopyWithImpl<$Res>;
  $Res call({int userId, Pokemon poke});
}

/// @nodoc
class _$myParamsUserIdPokeCopyWithImpl<$Res>
    implements $myParamsUserIdPokeCopyWith<$Res> {
  _$myParamsUserIdPokeCopyWithImpl(this._value, this._then);

  final myParamsUserIdPoke _value;
  // ignore: unused_field
  final $Res Function(myParamsUserIdPoke) _then;

  @override
  $Res call({
    Object? userId = freezed,
    Object? poke = freezed,
  }) {
    return _then(_value.copyWith(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      poke: poke == freezed
          ? _value.poke
          : poke // ignore: cast_nullable_to_non_nullable
              as Pokemon,
    ));
  }
}

/// @nodoc
abstract class _$$_myParamsUserIdPokeCopyWith<$Res>
    implements $myParamsUserIdPokeCopyWith<$Res> {
  factory _$$_myParamsUserIdPokeCopyWith(_$_myParamsUserIdPoke value,
          $Res Function(_$_myParamsUserIdPoke) then) =
      __$$_myParamsUserIdPokeCopyWithImpl<$Res>;
  @override
  $Res call({int userId, Pokemon poke});
}

/// @nodoc
class __$$_myParamsUserIdPokeCopyWithImpl<$Res>
    extends _$myParamsUserIdPokeCopyWithImpl<$Res>
    implements _$$_myParamsUserIdPokeCopyWith<$Res> {
  __$$_myParamsUserIdPokeCopyWithImpl(
      _$_myParamsUserIdPoke _value, $Res Function(_$_myParamsUserIdPoke) _then)
      : super(_value, (v) => _then(v as _$_myParamsUserIdPoke));

  @override
  _$_myParamsUserIdPoke get _value => super._value as _$_myParamsUserIdPoke;

  @override
  $Res call({
    Object? userId = freezed,
    Object? poke = freezed,
  }) {
    return _then(_$_myParamsUserIdPoke(
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      poke: poke == freezed
          ? _value.poke
          : poke // ignore: cast_nullable_to_non_nullable
              as Pokemon,
    ));
  }
}

/// @nodoc

class _$_myParamsUserIdPoke implements _myParamsUserIdPoke {
  _$_myParamsUserIdPoke({required this.userId, required this.poke});

  @override
  final int userId;
  @override
  final Pokemon poke;

  @override
  String toString() {
    return 'myParamsUserIdPoke(userId: $userId, poke: $poke)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_myParamsUserIdPoke &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.poke, poke));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(poke));

  @JsonKey(ignore: true)
  @override
  _$$_myParamsUserIdPokeCopyWith<_$_myParamsUserIdPoke> get copyWith =>
      __$$_myParamsUserIdPokeCopyWithImpl<_$_myParamsUserIdPoke>(
          this, _$identity);
}

abstract class _myParamsUserIdPoke implements myParamsUserIdPoke {
  factory _myParamsUserIdPoke(
      {required final int userId,
      required final Pokemon poke}) = _$_myParamsUserIdPoke;

  @override
  int get userId;
  @override
  Pokemon get poke;
  @override
  @JsonKey(ignore: true)
  _$$_myParamsUserIdPokeCopyWith<_$_myParamsUserIdPoke> get copyWith =>
      throw _privateConstructorUsedError;
}
