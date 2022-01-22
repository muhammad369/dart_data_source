import '../../dart_data_source.dart';
import 'package:sqflite/sqflite.dart' as sqf;

/// InMemory db holds for one connection only, if the connection closes, it vanishes
class InMemoryDatabase extends SqliteDatabase {

  InMemoryDatabase() : super(sqf.inMemoryDatabasePath);



}
