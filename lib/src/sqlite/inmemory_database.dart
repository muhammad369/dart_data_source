import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../dart_data_source.dart';
import 'package:sqflite/sqflite.dart' as sqf;

/// InMemory db holds for one connection only, if the connection closes, it vanishes
class InMemoryDatabase extends SqliteDatabase {
  InMemoryDatabase() : super(sqf.inMemoryDatabasePath);


  Future<DbContext> newTestingContext() async {
    late DatabaseExecutor sqfDb;
    var onConfig = (d) async {
      await d.execute('PRAGMA foreign_keys = ON;');
    };
    sqfDb = await databaseFactoryFfi.openDatabase(sqf.inMemoryDatabasePath,
        options: OpenDatabaseOptions(onConfigure: onConfig));

    return SqliteDbContext(sqfDb);
  }
}
