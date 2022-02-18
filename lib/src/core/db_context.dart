part of datasource_core;

/// the abstract operation to be implemented by every db type
abstract class DbContext {
  Future<void> close();

  // logging
  void Function(String logLine)? sqlLogger;
  void Function(String logLine)? resultLogger;
  void setLogger({void Function(String logLine)? sqlLogger, void Function(String logLine)? resultLogger}){
    this.sqlLogger = sqlLogger;
    this.resultLogger = resultLogger;
  }

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

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object>? params]);

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
    var cmd = obj.createCommand();
    if(sqlLogger != null) sqlLogger!(cmd);
    return this.executeSql(cmd);
  }

  //#endregion

//#region execute commands



  Future<int> executeUpdate(UpdateStatement updateStatement) {
    //startTransaction();

    var commandText = updateStatement.toSql();
    var params = updateStatement._parameters.map((e) => e.value).toList();
    if(sqlLogger != null) sqlLogger!('statement: $commandText  params: $params');
    return this.rawUpdate(commandText, params);
  }

  Future<int> executeDelete(DeleteStatement deleteStatement) {
    //startTransaction();

    var commandText = deleteStatement.toSql();
    var params = deleteStatement._parameters.map((p) => p.value).toList();
    if(sqlLogger != null) sqlLogger!('statement: $commandText  params: $params');
    return this.rawDelete(commandText, params);
  }

  Future<int> executeInsert(InsertStatement insertStatement) {
    //startTransaction();

    var commandText = insertStatement.toSql();
    var params = insertStatement._parameters.map((p) => p.value).toList();
    if(sqlLogger != null) sqlLogger!('statement: $commandText  params: $params');
    return this.rawInsert(commandText, params);
  }

  /// <summary>
  /// returns null if no data found
  /// </summary>
  Future<Map<String, dynamic>?> executeSelectRow(SelectStatement selectStatement) async {
    //startTransaction();

    var commandText = selectStatement.toSql();
    var params = selectStatement._parameters.map((p) => p.value).toList();
    if(sqlLogger != null) sqlLogger!('statement: $commandText  params: $params');
    var result = await this.rawQuery(commandText, params);

    if(resultLogger != null) resultLogger!('sql select row result: $result');
    if (result.isEmpty) return null;

    return result[0];
  }

  Future<List<Map<String, dynamic>>> executeSelect(AbsSelect selectStatement) async {
    //startTransaction();

    var commandText = selectStatement.toSql();
    var params = selectStatement._getParameters().map((p) => p.value).toList();
    if(sqlLogger != null) sqlLogger!('statement: $commandText  params: $params');
    var result = await this.rawQuery(commandText, params);
    if(resultLogger != null) resultLogger!('sql result: $result');
    return result;
  }

  Future<Object?> executeScalar(SelectStatement selectStatement) async {
    //startTransaction();

    var commandText = selectStatement.toSql();
    var params = selectStatement._parameters.map((p) => p.value).toList();
    if(sqlLogger != null) sqlLogger!('select scalar statement: $commandText  params: $params');
    var result = await this.rawQuery(commandText, params);
    if(resultLogger != null) resultLogger!('sql result: $result');
    return this.getScalarValue(result);
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
