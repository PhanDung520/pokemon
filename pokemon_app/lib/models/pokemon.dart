import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/utils/utils.dart';

class Pokemon{
  String class1;
  int attack;
  int height;
  int hp;
  int pokeId;
  String image;
  String name;
  int speed;
  int weight;

  Pokemon(this.class1, this.attack, this.height, this.hp, this.pokeId, this.image, this.name, this.speed, this.weight);
}

