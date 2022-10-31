import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/pokemon/pokemon.dart';

Future<List<Pokemon>> fetchDataOffline(List<Pokemon> listPoke, bool isConnect) async {
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
      pokemon.toJson(),
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
        class1 :maps[i]['class1'],
        attack :maps[i]['attack'],
        height :maps[i]['height'],
        hp :maps[i]['hp'],
        pokeId :maps[i]['pokeId'],
        image :maps[i]['image'],
        name :maps[i]['name'],
        speed :maps[i]['speed'],
        weight :maps[i]['weight'],
        like :maps[i]['like'],
      );
    });
  }
  Future<void> deleteAll() async {
    final db = await database;
    await db.execute('DELETE FROM pokemons');
  }
  if(isConnect){
    await deleteAll();
  }
  for(Pokemon poke in listPoke){
    await insertPoke(poke);
  }
  await pokemons();
  return await pokemons();
}

Future<List<Pokemon>> fetchFavoriteOffline(int userId, List<Pokemon> listFavorite, bool isConnect) async {
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
      pokemon.toJson(),
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
        class1 :maps[i]['class1'],
        attack :maps[i]['attack'],
        height :maps[i]['height'],
        hp :maps[i]['hp'],
        pokeId :maps[i]['pokeId'],
        image :maps[i]['image'],
        name :maps[i]['name'],
        speed :maps[i]['speed'],
        weight :maps[i]['weight'],
        like :maps[i]['like'],
      );
    });
  }
  if(isConnect){
    await deleteAll();
  }
  //final data = ref.watch(fProvider3);
  for(Pokemon poke in listFavorite){
    insertPoke(poke);
  }
  await pokemons();
  return await pokemons();
}