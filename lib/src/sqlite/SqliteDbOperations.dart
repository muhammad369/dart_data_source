
import '../../dart_data_source.dart' as ds;
import 'package:sqflite/sqflite.dart';

class SqliteDbOperations extends ds.DbOperations{

  Database _db;
  Transaction _trns;

  @override
  Future openDb(String connectionString) async {
    _db = await openDatabase(connectionString);

  }

  @override
  Future closeDb() async {
    if(_trns != null){
      //_trns.
    }
    //
    if(_db != null) {
      await _db.close();
      _db = null;
    }
  }

  @override
  Future rollbackTransaction() {
    // TODO: implement rollbackTransaction
    throw UnimplementedError();
  }

  @override
  void startTransaction() {
    _db.transaction((txn) => this._trns = txn; )
  }

  @override
  Future commitTransaction() {
    
  }

  @override
  Future<int> delete(String sql, [List<Object> params]) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future executeSql(String sql) {
    // TODO: implement executeSql
    throw UnimplementedError();
  }

  @override
  Object getScalarValue(List<Map> result) {
    // TODO: implement getScalarValue
    throw UnimplementedError();
  }

  @override
  Future<int> insert(String sql, [List<Object> params]) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<Map>> query(String sql, [List<Object> params]) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<int> update(String sql, [List<Object> params]) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}