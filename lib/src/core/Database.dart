import 'dart:core';

import '../../dart_data_source.dart';

abstract class Database {
  //String _conectionString;
  DbOperations dbOps;

  Database(this.dbOps);

  /// <summary>
  /// implemented by the db, pass columns except primary and forein keys
  /// </summary>
  Table newTable(String name, List<Column> fields);

  //#region excute commands

  void addIdColumn(Table t);

  //#endregion

  //#region db-objects

  Index newIndex(String name, Table tbl, List<Column> cols) {
    return new Index(name, tbl, cols);
  }

  Trigger newTrigger(String name, Table tbl) {
    return new Trigger(name, tbl);
  }

  View newView(String name, AbsSelect select) {
    return new View(this, name, select);
  }

  //#endregion

  //#region db-columns

  IntColumn intColumn(String name);

  DoubleColumn doubleColumn(String name);

  TextColumn textColumn(String name);

  StringColumn stringColumn(String name, int maxLength);

  DateColumn dateColumn(String name);

  DateTimeColumn dateTimeColumn(String name);

  //BinaryColumn binaryColumn(String name);

  BoolColumn boolColumn(String name);

  //#endregion

  //#region META

  StringColumn _meta_name;
  IntColumn _meta_value;
  StringColumn _meta_text;
  Table _tbl_meta;

  void updateSchemaIfNeeded() {
    //fields
    _meta_name = stringColumn("name", 150);
    _meta_value = intColumn("value").allowNull() as IntColumn;
    _meta_text = stringColumn("text", 150).allowNull() as StringColumn;

    //table
    _tbl_meta = this.newTable("ds_meta", [_meta_name, _meta_value, _meta_text]);

    //start trns.
    this.startTransaction();
    //create if not exists
    this.create(_tbl_meta);
    //look version
    int ver = currentVersion();
    if (ver == -1) {
      // insert version row
      this.insertInto(_tbl_meta).Values(
          [_meta_name.value("schema version"), _meta_value.value(0)]).execute();
      //
      ver = 0;
    }
    //
    for (int i = ver; i < schemaUpdates.length; i++) {
      schemaUpdates[i].apply(this);
    }
    _setSchemaVersion(schemaUpdates.length);
    //commit
    this.submitChanges();
  }

  int currentVersion() {
    Object tmp = this
        .select()
        .from(_tbl_meta)
        .fields([_meta_value])
        .where(_meta_name.Equal("schema version"))
        .executeScalar();
    //
    return tmp == null ? -1 : tmp as int;
  }

  //#endregion

  //#region schema updates
  List<SchemaUpdate> schemaUpdates = new List<SchemaUpdate>();

  void addSchemaUpdate(SchemaUpdate su) {
    schemaUpdates.add(su);
  }

  void addSchemaUpdateObjects(List<DbObject> dbObjs) {
    schemaUpdates.add(new SchemaUpdate(dbObjs));
  }

  void _setSchemaVersion(int version) {
    this
        .Update(_tbl_meta)
        .Set([_meta_value.value(version)])
        .Where(_meta_name.Equal("schema version"))
        .execute();
  }

  //#endregion

  //#region dbcontext

  void startTransaction() {
    this.dbOps.startTransaction();
  }

  void rollBack() {
    this.dbOps.rollbackTransaction();
  }

  void submitChanges() {
    this.dbOps.commitTransaction();
  }

  int create(DbObject obj) {
    this.dbOps.executeSql(obj.createCommand());
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

  UpdateStatement Update(Table tbl) {
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
  int lastId();

  Future<int> executeUpdate(UpdateStatement updateStatement) {
    startTransaction();

    var commandText = updateStatement.toSql();

    return this.dbOps.update(
        commandText, updateStatement.parameters.map((p) => p.value()).toList());
  }

  Future<int> executeDelete(DeleteStatement deleteStatement) {
    startTransaction();

    var commandText = deleteStatement.toSql();

    return this.dbOps.delete(
        commandText, deleteStatement.parameters.map((p) => p.value()).toList());
  }

  Future<int> executeInsert(InsertStatement insertStatement) {
    startTransaction();

    var commandText = insertStatement.toSql();

    return this.dbOps.insert(
        commandText, insertStatement.parameters.map((p) => p.value()).toList());
  }

  /// <summary>
  /// returns null if no data found
  /// </summary>
  Future<Map> executeSelectRow(SelectStatement selectStatement) async {
    startTransaction();

    var commandText = selectStatement.toSql();

    var result = await this.dbOps.query(
        commandText, selectStatement.parameters.map((p) => p.value()).toList());

    if (result.isEmpty) return null;

    return result[0];
  }

  Future<List<Map>> executeSelect(SelectStatement selectStatement) {
    startTransaction();

    var commandText = selectStatement.toSql();

    return this.dbOps.query(
        commandText, selectStatement.parameters.map((p) => p.value()).toList());
  }

  Object executeScalar(SelectStatement selectStatement) async {
    startTransaction();

    var commandText = selectStatement.toSql();

    return this.dbOps.getScalarValue(await this.dbOps.query(commandText,
        selectStatement.parameters.map((p) => p.value()).toList()));
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
