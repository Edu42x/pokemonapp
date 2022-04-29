import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pokemonapp/src/models/favorite_pokemon_model.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, "pokemon.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE favoritos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name text,
            front_default text,
            back_default text
          )
        ''');
    });
  }

//FUNCINOES DEL POKEMONES

//Agregar a favoritos de manera Local

  Future<FavoritePokemon> addFavorite(FavoritePokemon favoritos) async {
    final db = await database;

    final id = await db!.insert("favoritos", favoritos.toJson());

    return favoritos.copy(id: id);
  }

  Future<FavoritePokemon> readFavorite(String name) async {
    final db = await database;

    final maps = await db!.query("favoritos",
        columns: FavoritePokemonFields.values,
        where: '${FavoritePokemonFields.name} = ?',
        whereArgs: [name]);

    if (maps.isNotEmpty) {
      return FavoritePokemon.fromJson(maps.first);
    } else {
      throw ("name $name didnt found");
    }
  }

  Future<List<FavoritePokemon>> getAllFavorites() async {
    final db = await database;
    final result = await db!.query("favoritos");

    return result.map((e) => FavoritePokemon.fromJson(e)).toList();
  }

  Future<int> delete(String name) async {
    final db = await database;

    return await db!.delete('favoritos',
        where: '${FavoritePokemonFields.name}=?', whereArgs: [name]);
  }

  Future close() async {
    final db = await database;
    db!.close();
  }
}
