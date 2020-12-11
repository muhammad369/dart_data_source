import 'dart:core';

/// the abstract operation to be implemented by every db type
abstract class DbOperations {
  Future openDb(String connectionString);

  Future closeDb();

  Object getScalarValue(List<Map> result);

  Future executeSql(String sql);

  /// shall check if transaction already started
  void startTransaction();

  Future commitTransaction();

  Future rollbackTransaction();

  Future<List<Map>> query(String sql, [List<Object> params]);

  Future<int> insert(String sql, [List<Object> params]);

  Future<int> update(String sql, [List<Object> params]);

  Future<int> delete(String sql, [List<Object> params]);
}
