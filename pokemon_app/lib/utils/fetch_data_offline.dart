import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future initDatabase()async{
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'pokemons.db'),
    onCreate: (db, version){
      return db.execute(
        'CREATE TABLE pokemons(pokeId INTEGER PRIMARY KEY, class1 TEXT,image TEXT,name TEXT, attack INTEGER, height INTEGER,hp INTEGER,speed INTEGER,weight INTEGER,like INTEGER,)'
      );
    }
  );
}