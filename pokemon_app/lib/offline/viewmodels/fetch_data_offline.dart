import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/offline/viewmodels/offline_state.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

import '../../pages/home_page/viewmodels/home_provider.dart';

void fetchDataOffline(WidgetRef ref) async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'pokemons.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE pokemons(pokeId INTEGER PRIMARY KEY, class1 TEXT,image TEXT,name TEXT, attack INTEGER, height INTEGER,hp INTEGER,speed INTEGER,weight INTEGER,like INTEGER)',
      );
    },
    version: 1,
  );
  Future<void> insertPoke(Pokemon pokemon) async {
    final db = await database;
    await db.insert(
      'pokemons',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // A method that retrieves all the dogs from the pokemons table.
  Future<List<Pokemon>> pokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pokemons');
    // Convert the List<Map<String, dynamic> into a List<Pokemon>.
    return List.generate(maps.length, (i) {
      return Pokemon(
        maps[i]['class1'],
        maps[i]['attack'],
        maps[i]['height'],
        maps[i]['hp'],
        maps[i]['pokeId'],
        maps[i]['image'],
        maps[i]['name'],
        maps[i]['speed'],
        maps[i]['weight'],
        maps[i]['like'],
      );
    });
  }
  final data = ref.watch(pokeGet2Provider);
  for(Pokemon poke in data){
    await insertPoke(poke);
  }

  ref.read(pokeGet2Provider.notifier).state = await pokemons();
}