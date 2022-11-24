import '../../dart_data_source.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqf_ffi;

class SqliteDbContext extends DbContext {
  // the connection
  sqf.DatabaseExecutor _db;

  SqliteDbContext(this._db);

  @override
  Future<void> close() async {
    if (_db is sqf.Database && (_db as sqf.Database).isOpen) {
      await (_db as sqf.Database).close();
    }
  }

  // @override
  // Future rollbackTransaction() {
  //   // TODO: implement rollbackTransaction
  //   throw UnimplementedError();
  // }
  //
  // @override
  // void startTransaction() {
  //   _db.transaction((txn) => this._trns = txn; )
  // }
  //
  // @override
  // Future commitTransaction() {
  //
  // }

  @override
  Future<int> rawDelete(String sql, [List<Object>? params]) {
    if (sqlLogger != null) sqlLogger!('raw statement: $sql  params: $params');
    return _db.rawDelete(sql, params);
  }

  @override
  Future<void> executeSql(String sql) {
    if (sqlLogger != null) sqlLogger!('raw statement: $sql');
    return _db.execute(sql);
  }

  @override
  Object? getScalarValue(List<Map<String, dynamic>> result) {
    if (result == null || result.length == 0) return null;
    if (result[0] == null || result[0].length == 0) return null;
    return result[0].values.first;
  }

  @override
  Future<int> rawInsert(String sql, [List<Object>? params]) {
    if (sqlLogger != null) sqlLogger!('raw statement: $sql  params: $params');
    return _db.rawInsert(sql, params);
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object>? params]) async {
    if (sqlLogger != null) sqlLogger!('raw statement: $sql  params: $params');
    var result = await _db.rawQuery(sql, params);
    if (resultLogger != null) resultLogger!('sql result: $result');
    return result;
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object>? params]) {
    if (sqlLogger != null) sqlLogger!('raw statement: $sql  params: $params');
    return _db.rawUpdate(sql, params);
  }

  @override
  Future<void> executeTransaction(Future<void> Function(DbContext transactionContext) action) {
    if (_db is sqf.Transaction)
      throw Exception("executeTransaction() method can't be called on a TransactionContext instance");
    //
    return (_db as sqf.Database).transaction((txn) {
      return action(SqliteDbContext(txn)..setLogger(sqlLogger: this.sqlLogger, resultLogger: this.resultLogger));
    });
  }
}
