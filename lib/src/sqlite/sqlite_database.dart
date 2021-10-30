

import '../../dart_data_source.dart';
import 'sqlite_db_context.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class SqliteDatabase extends Database{

  String _path;
  SqliteDatabase(this._path);

  @override
  Future<DbContext> newContext() async {
    return SqliteDbContext(await sqf.openDatabase(_path));
  }

  @override
  void addIdColumn(Table t) {
    t.fields.add(
        new SqliteInteger("id_${t.name}")
    );
  }

  @override
  BoolColumn boolColumn(String name) {
    return new SqliteBool(name);
  }

  @override
  DateColumn dateColumn(String name) {
    return new SqliteDate(name);
  }

  @override
  DateTimeColumn dateTimeColumn(String name) {
    return new SqliteDateTime(name);
  }

  @override
  DoubleColumn doubleColumn(String name) {
    return new SqliteReal(name);
  }

  @override
  IntColumn intColumn(String name) {
    return new SqliteInteger(name);
  }

  @override
  Table newTable(String name, List<Column> fields) {
    return new Table(name, this, fields);
  }

  @override
  StringColumn stringColumn(String name, int maxLength) {
    return new SqliteString(name, maxLength);
  }

  @override
  TextColumn textColumn(String name) {
    return new SqliteText(name);
  }

}