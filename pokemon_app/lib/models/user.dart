import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/utils/utils.dart';

class User{
  String name;
  String password;
  int userId;

  User(this.name, this.password, this.userId);

}
