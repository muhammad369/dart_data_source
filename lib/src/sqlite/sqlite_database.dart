import '../../dart_data_source.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class SqliteDatabase extends Database {
  String _path;
  SqliteDatabase(this._path);

  @override
  Future<DbContext> newContext() async {
    var sdfDb = await sqf.openDatabase(_path);
    return SqliteDbContext(sdfDb);
  }

  @override
  void addIdColumn(Table t) {
    // TODO: add another kind of id (uuid, or no id at all)
    t.fields.add(new SqliteInteger("id_${t.name}"));
  }

  @override
  BoolColumn boolColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteBool(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  DateColumn dateColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteDate(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  DateTimeColumn dateTimeColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteDateTime(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  DoubleColumn doubleColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteReal(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  IntColumn intColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteInteger(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  Table newTable(String name, List<DbColumn> fields) {
    return new Table(name, this, fields);
  }

  @override
  StringColumn stringColumn(String name, int maxLength,
      {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteString(name, maxLength, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  @override
  TextColumn textColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue}) {
    return new SqliteText(name, unique: unique, allowNull: allowNull, defaultValue: defaultValue);
  }

  SelectStatement? _selectLastIdStatement;

  @override
  Future<int> lastId(DbContext dbc) async {
    if (_selectLastIdStatement == null)
    {
      _selectLastIdStatement = this.Select().Fields([new FunctionExpression("last_insert_rowid")]);
    }
    var value = await _selectLastIdStatement!.executeScalar(dbc);
    if(value == null) return 0;
    return (int.parse(value.toString()));
  }
}
