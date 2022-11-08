// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Pokemon _$$_PokemonFromJson(Map<String, dynamic> json) => _$_Pokemon(
      class1: json['class1'] as String,
      attack: json['attack'] as int,
      height: json['height'] as int,
      hp: json['hp'] as int,
      pokeId: json['pokeId'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      speed: json['speed'] as int,
      weight: json['weight'] as int,
      like: json['like'] as int,
    );

Map<String, dynamic> _$$_PokemonToJson(_$_Pokemon instance) =>
    <String, dynamic>{
      'class1': instance.class1,
      'attack': instance.attack,
      'height': instance.height,
      'hp': instance.hp,
      'pokeId': instance.pokeId,
      'image': instance.image,
      'name': instance.name,
      'speed': instance.speed,
      'weight': instance.weight,
      'like': instance.like,
    };
