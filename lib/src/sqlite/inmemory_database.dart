import '../../dart_data_source.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class InMemoryDatabase extends SqliteDatabase {

  InMemoryDatabase() : super(sqf.inMemoryDatabasePath);

}
