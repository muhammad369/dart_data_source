import 'dart:core';

import 'package:dart_data_source/dart_data_source.dart';

/// the abstract operation to be implemented by every db type
abstract class DbContext {
  Future<void> close();

  Object? getScalarValue(List<Map<String, Object?>> result);

  Future<void> executeSql(String sql);

  Future<void> executeTransaction(Future<void> Function(DbContext transactionContext) action);

  Future<void> executeTransactionStatements(List<NonQueryStatement> statements) {
    return executeTransaction((transactionContext) async {
      statements.forEach((s) async { await s.execute(transactionContext); });
    });
  }

  /// shall check if transaction already started
  //void startTransaction();

  //Future commitTransaction();

  //Future rollbackTransaction();

  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object>? params]);

  Future<int> rawInsert(String sql, [List<Object>? params]);

  Future<int> rawUpdate(String sql, [List<Object>? params]);

  Future<int> rawDelete(String sql, [List<Object>? params]);

  //#region dbcontext

  // void startTransaction() {
  //   this.dbOps.startTransaction();
  // }
  //
  // void rollBack() {
  //   this.dbOps.rollbackTransaction();
  // }

  Future<void> create(DbObject obj) {
    return this.executeSql(obj.createCommand());
  }

  //#endregion

//#region ===== select update insert delete =====

  SelectStatement select() {
    return new SelectStatement(this);
  }

  SelectStatement selectDistinct() {
    return new SelectStatement(this, true);
  }

  SelectStatement selectListItems(Table tbl, Expr nameField) {
    return select().from(tbl).fields([tbl.id.As("id"), nameField.As("name")]);
  }

  UpdateStatement update(Table tbl) {
    return new UpdateStatement(this, tbl);
  }

  InsertStatement insertInto(Table tbl) {
    return new InsertStatement(this, tbl);
  }

  DeleteStatement deleteFrom(Table tbl) {
    return new DeleteStatement(this, tbl);
  }

//#endregion

//#region execute commands

  /// <summary>
  /// must be used before closing the connection
  /// </summary>
  Future<int> lastId();

  Future<int> executeUpdate(UpdateStatement updateStatement) {
    //startTransaction();

    var commandText = updateStatement.toSql();

    return this.rawUpdate(commandText, updateStatement.parameters.map((e) => e.value).toList());
  }

  Future<int> executeDelete(DeleteStatement deleteStatement) {
    //startTransaction();

    var commandText = deleteStatement.toSql();

    return this.rawDelete(commandText, deleteStatement.parameters.map((p) => p.value).toList());
  }

  Future<int> executeInsert(InsertStatement insertStatement) {
    //startTransaction();

    var commandText = insertStatement.toSql();

    return this.rawInsert(commandText, insertStatement.parameters.map((p) => p.value).toList());
  }

  /// <summary>
  /// returns null if no data found
  /// </summary>
  Future<Map<String, Object?>?> executeSelectRow(SelectStatement selectStatement) async {
    //startTransaction();

    var commandText = selectStatement.toSql();

    var result = await this.rawQuery(commandText, selectStatement.parameters.map((p) => p.value).toList());

    if (result.isEmpty) return null;

    return result[0];
  }

  Future<List<Map<String, Object?>>> executeSelect(SelectStatement selectStatement) {
    //startTransaction();

    var commandText = selectStatement.toSql();

    return this.rawQuery(commandText, selectStatement.parameters.map((p) => p.value).toList());
  }

  Object? executeScalar(SelectStatement selectStatement) async {
    //startTransaction();

    var commandText = selectStatement.toSql();

    return this
        .getScalarValue(await this.rawQuery(commandText, selectStatement.parameters.map((p) => p.value).toList()));
  }

//#endregion

/*
//#region entity

  public T selectFirstWhere<T>(expr cond) where T : Entity, new()
  {
  var ent = new T();
  var r = this.select().from(ent.Tbl).where(cond).executeRow();
  if (r == null)
  {
  return null;
  }
  else
  {
  ent.attach(r);
  return ent;
  }
  }

  public T selectById<T>(int id) where T : TableEntity, new()
  {
  var ent = new T();
  var tbl = ent.Tbl as Table;
  var r = this.select().from(tbl).where(tbl.id.equal(id)).executeRow();
  if (r == null)
  {
  return null;
  }
  else
  {
  ent.attach(r);
  return ent;
  }
  }

  public List<T> selectWhere<T>(expr cond) where T : Entity, new()
  {
  var tbl = new T().Tbl;
  var list = new List<T>();
  var dt = this.select().from(tbl).where(cond).execute();

  foreach (DataRow dr in dt.Rows)
  {
  var item = new T();
  item.attach(dr);
  list.Add(item);
  }

  return list;
  }

  public List<T> selectPage<T>(int index, int size) where T : Entity, new()
  {
  var tbl = new T().Tbl;
  var list = new List<T>();
  var dt = this.select().from(tbl).page(index, size).execute();

  foreach (DataRow dr in dt.Rows)
  {
  var item = new T();
  item.attach(dr);
  list.Add(item);
  }

  return list;
  }

  public List<T> select<T>(expr cond, int pageIndex, int pageSize) where T : Entity, new()
  {
  var tbl = new T().Tbl;
  var list = new List<T>();
  var dt = this.select().from(tbl).where(cond).page(pageIndex, pageSize).execute();

  foreach (DataRow dr in dt.Rows)
  {
  var item = new T();
  item.attach(dr);
  list.Add(item);
  }

  return list;
  }

//#endregion
*/

}
