import 'dart:core';

import '../../dart_data_source.dart';

abstract class Database {
  Database();

  Future<DbContext> newContext();

  /// <summary>
  /// implemented by the db, pass columns except primary and forein keys
  /// </summary>
  Table newTable(String name, List<Column> fields);

  //#region execute commands

  void addIdColumn(Table t);

  //#endregion

  //#region db-objects

  Index newIndex(String name, Table tbl, List<Column> cols, {bool unique = false}) {
    return new Index(name, tbl, cols, unique: unique);
  }

  // Trigger newTrigger(String name, Table tbl) {
  //   return new Trigger(name, tbl);
  // }

  View newView(String name, AbsSelect select) {
    return new View(this, name, select);
  }

  //#endregion

  //#region db-columns

  IntColumn intColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  DoubleColumn doubleColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  TextColumn textColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  StringColumn stringColumn(String name, int maxLength,
      {bool allowNull = false, bool unique = false, Object? defaultValue});

  DateColumn dateColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  DateTimeColumn dateTimeColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  //BinaryColumn binaryColumn(String name);

  BoolColumn boolColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  //#endregion

//#region ===== select update insert delete =====

  SelectStatement Select() {
    return new SelectStatement();
  }

  SelectStatement SelectDistinct() {
    return new SelectStatement(distinct: true);
  }

  SelectStatement SelectListItems(Table tbl, Expr nameField) {
    return Select().From(tbl).Fields([tbl.Id.As("id"), nameField.As("name")]);
  }

  UpdateStatement Update(Table tbl) {
    return new UpdateStatement(tbl);
  }

  InsertStatement InsertInto(Table tbl) {
    return new InsertStatement(tbl);
  }

  DeleteStatement DeleteFrom(Table tbl) {
    return new DeleteStatement(tbl);
  }

//#endregion

  //#region META

  late StringColumn _meta_name;
  late IntColumn _meta_value;
  late StringColumn _meta_text;
  late Table _tbl_meta;

  Future<void> updateSchemaIfNeeded(DbContext dbc) async {
    //fields
    _meta_name = stringColumn("name", 150);
    _meta_value = intColumn("value", allowNull: true);
    _meta_text = stringColumn("text", 150, allowNull: true);

    //table
    _tbl_meta = this.newTable("ds_meta", [_meta_name, _meta_value, _meta_text]);

    //this.startTransaction();
    //create if not exists

    await dbc.executeTransaction((transactionContext) async {
      await transactionContext.create(_tbl_meta);
      int ver = await currentVersion(transactionContext);
      if (ver == -1) {
        // insert version row
        await this
            .InsertInto(_tbl_meta)
            .Values([_meta_name.Assign("schema version"), _meta_value.Assign(0)])
            .execute(transactionContext);
        //
        ver = 0;
      }
      //
      if (ver < _schemaUpdates.length) {
        for (int i = ver; i < _schemaUpdates.length; i++) {
          await _schemaUpdates[i].apply(transactionContext);
        }
        await _setSchemaVersion(transactionContext, _schemaUpdates.length);
      }
    });

    //commit
    //this.submitChanges();
  }

  Future<int> currentVersion(DbContext dbc) async {
    Object? tmp = await this
        .Select()
        .From(_tbl_meta)
        .Fields([_meta_value])
        .Where(_meta_name.Equal("schema version"))
        .executeScalar(dbc);
    //
    return tmp == null ? -1 : tmp as int;//int.parse(tmp);
  }

  //#endregion

  //#region schema updates
  List<SchemaUpdate> _schemaUpdates = <SchemaUpdate>[];

  void addSchemaUpdate(SchemaUpdate su) {
    _schemaUpdates.add(su);
  }

  void addSchemaUpdateObjects(List<DbObject> dbObjs) {
    _schemaUpdates.add(new SchemaUpdate(objects: dbObjs));
  }

  Future<void> _setSchemaVersion(DbContext dbc, int version) async {
    await this
        .Update(_tbl_meta)
        .Set([_meta_value.Assign(version)])
        .Where(_meta_name.Equal("schema version"))
        .execute(dbc);
  }

  /// <summary>
  /// must be used before closing the connection
  /// </summary>
  Future<int> lastId(DbContext dbc);

  //#endregion

}
