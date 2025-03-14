import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_speed/db_speed/speed_entity.dart';

class DBSpeed extends GetxService {
  late Database dbBase;

  Future<DBSpeed> init() async {
    await createSpeedDB();
    return this;
  }

  createSpeedDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'speed.db');

    dbBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await createSpeedTable(db);
        });
  }

  createSpeedTable(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS speed (id INTEGER PRIMARY KEY, createdTime TEXT, duration TEXT, distance TEXT, avgSpeed TEXT, maxSpeed TEXT)');
  }

  insertSpeedData(SpeedEntity speedEntity) async {
    final id = await dbBase.insert('speed', {
      'createdTime': speedEntity.createdTime.toIso8601String(),
      'duration': speedEntity.duration,
      'distance': speedEntity.distance,
      'avgSpeed': speedEntity.avgSpeed,
      'maxSpeed': speedEntity.maxSpeed,
    });
    return id;
  }

  cleanSpeedData() async {
    await dbBase.delete('speed');
  }

  Future<List<SpeedEntity>> getSpeedAllData() async {
    var result = await dbBase.query('speed', orderBy: 'createdTime DESC');
    return result.map((e) => SpeedEntity.fromJson(e)).toList();
  }
}
