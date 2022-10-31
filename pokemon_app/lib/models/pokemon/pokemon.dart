import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
class Pokemon with _$Pokemon {
  const factory Pokemon({
    required String class1,
    required int attack,
    required int height,
    required int hp,
    required int pokeId,
    required String image,
    required String name,
    required int speed,
    required int weight,
    required int like
  }) = _Pokemon;
  factory Pokemon.fromJson(Map<String, dynamic> json) =>_$PokemonFromJson(json);
}
