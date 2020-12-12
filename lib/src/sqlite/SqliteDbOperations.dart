

import 'package:dart_data_source/dart_data_source.dart';

class SqliteDbOperations extends DbOperations{
  @override
  Future closeDb() {
    // TODO: implement closeDb
    throw UnimplementedError();
  }

  @override
  Future commitTransaction() {
    // TODO: implement commitTransaction
    throw UnimplementedError();
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
  Future openDb(String connectionString) {
    // TODO: implement openDb
    throw UnimplementedError();
  }

  @override
  Future<List<Map>> query(String sql, [List<Object> params]) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future rollbackTransaction() {
    // TODO: implement rollbackTransaction
    throw UnimplementedError();
  }

  @override
  void startTransaction() {
    // TODO: implement startTransaction
  }

  @override
  Future<int> update(String sql, [List<Object> params]) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}