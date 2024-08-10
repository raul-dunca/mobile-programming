import 'dart:async';
import 'package:adoptr/model/pet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepo {
  static final DatabaseRepo instance = DatabaseRepo._init();
  static Database? _database;

  DatabaseRepo._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pet.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const ageType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tablePets
    (
      ${PetFields.id} $idType,
      ${PetFields.name} $textType,
      ${PetFields.type} $textType,
      ${PetFields.location} $textType,
      ${PetFields.gender} $textType,
      ${PetFields.breed} $textType,
      ${PetFields.age} $ageType,
      ${PetFields.contact} $textType
    )
''');
  }

  Future<int> create(Pet pet) async {
    final db = await instance.database;
    final json = pet.toJson();
    const colums =
        '${PetFields.id},${PetFields.name},${PetFields.type},${PetFields.location},${PetFields.gender},${PetFields.breed},${PetFields.age},${PetFields.contact}';
    final values = "'${json[PetFields.id]}'," +
        "'${json[PetFields.name]}'," +
        "'${json[PetFields.type]}'," +
        "'${json[PetFields.location]}'," +
        "'${json[PetFields.gender]}'," +
        "'${json[PetFields.breed]}'," +
        "${json[PetFields.age]}," +
        "'${json[PetFields.contact]}'";
    final id =
        await db.rawInsert('INSERT INTO $tablePets ($colums) VALUES ($values)');

    //final id = await db.insert(tablePets, pet.toJson());
    return id;
  }

  Future<int> create_no_id(Pet pet) async {
    final db = await instance.database;
    final json = pet.toJson();

    final result = await db
        .rawQuery('SELECT MAX(${PetFields.id}) as max_id FROM $tablePets');
    int maxId = result.first['max_id'] as int? ?? 0;
    int newId = maxId + 1;

    const columns =
        '${PetFields.id},${PetFields.name},${PetFields.type},${PetFields.location},${PetFields.gender},${PetFields.breed},${PetFields.age},${PetFields.contact}';

    final values = "'$newId'," +
        "'${json[PetFields.name]}'," +
        "'${json[PetFields.type]}'," +
        "'${json[PetFields.location]}'," +
        "'${json[PetFields.gender]}'," +
        "'${json[PetFields.breed]}'," +
        "${json[PetFields.age]}," +
        "'${json[PetFields.contact]}'";

    final id = await db
        .rawInsert('INSERT INTO $tablePets ($columns) VALUES ($values)');

    return id;
  }

  Future<Pet> readOnePet(int id) async {
    //id += 1;
    final db = await instance.database;

    final maps = await db
        .rawQuery('SELECT * FROM $tablePets WHERE ${PetFields.id} = ?', [id]);

    if (maps.isNotEmpty) {
      return Pet.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Pet>> readAllPets() async {
    final db = await instance.database;
    final rez = await db.rawQuery('SELECT * FROM $tablePets');
    return rez.map((e) => Pet.fromJson(e)).toList();
  }

  Future<int> update(Pet pet) async {
    final db = await instance.database;
    final json = pet.toJson();
    final rez = await db.rawUpdate(
      'UPDATE $tablePets SET '
      '${PetFields.name} = "${json[PetFields.name]}", '
      '${PetFields.type} = "${json[PetFields.type]}", '
      //    '${PetFields.image} = "${json[PetFields.image]}", '
      '${PetFields.location} = "${json[PetFields.location]}", '
      '${PetFields.gender} = "${json[PetFields.gender]}", '
      '${PetFields.breed} = "${json[PetFields.breed]}", '
      '${PetFields.age} = "${json[PetFields.age]}", '
      '${PetFields.contact} = "${json[PetFields.contact]}" '
      'WHERE ${PetFields.id} = "${json[PetFields.id]}"',
    );
    return rez;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final rez = await db
        .rawDelete('DELETE FROM $tablePets WHERE ${PetFields.id} = ?', [id]);
    return rez;
  }

  Future<int> deleteAllPets() async {
    final db = await instance.database;
    return await db.rawDelete('DELETE FROM $tablePets');
  }

  Future<int> countPets() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tablePets'));
    return count!;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
