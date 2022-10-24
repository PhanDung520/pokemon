import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/utils/connection_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

import '../../pages/detals_page/viewmodel/detail_provider.dart';
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

void fetchFavoriteOffline(WidgetRef ref, int userId) async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'favorite$userId.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE favorite(pokeId INTEGER PRIMARY KEY, class1 TEXT,image TEXT,name TEXT, attack INTEGER, height INTEGER,hp INTEGER,speed INTEGER,weight INTEGER,like INTEGER)',
      );
    },
    version: 1,
  );
  Future<void> insertPoke(Pokemon pokemon) async {
    final db = await database;
    await db.insert(
      'favorite',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> deleteAll() async {
    final db = await database;
    await db.execute('DELETE FROM favorite');
  }
  // A method that retrieves all the dogs from the pokemons table.
  Future<List<Pokemon>> pokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite');
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
  await deleteAll();
  final data = ref.watch(fProvider3);
  for(Pokemon poke in data){
    insertPoke(poke);
  }
  if(ref.watch(connectivityProvider) == false){
    ref.read(fProvider3.notifier).state = await pokemons();
  }
}