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

  IntColumn intColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  DoubleColumn doubleColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  TextColumn textColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  StringColumn stringColumn(String name, int maxLength, {bool allowNull = false, bool unique = false, Object? defaultValue});

  DateColumn dateColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  DateTimeColumn dateTimeColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

  //BinaryColumn binaryColumn(String name);

  BoolColumn boolColumn(String name, {bool allowNull = false, bool unique = false, Object? defaultValue});

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
    _meta_text = stringColumn("text", 150, allowNull: true) ;

    //table
    _tbl_meta = this.newTable("ds_meta", [_meta_name, _meta_value, _meta_text]);


    //this.startTransaction();
    //create if not exists

    await dbc.executeTransaction((transactionContext) async {
      await transactionContext.create(_tbl_meta);
      int ver = await currentVersion(transactionContext);
      if (ver == -1) {
        // insert version row
        await transactionContext
            .insertInto(_tbl_meta)
            .Values([_meta_name.value("schema version"), _meta_value.value(0)]).execute();
      }
      //
      ver = 0;
      //
      for (int i = ver; i < schemaUpdates.length; i++) {
        await schemaUpdates[i].apply(transactionContext);
      }
      await _setSchemaVersion(transactionContext, schemaUpdates.length);
    });

    //commit
    //this.submitChanges();
  }

  Future<int> currentVersion(DbContext dbc) async {
    Object? tmp = await dbc
        .select()
        .from(_tbl_meta)
        .fields([_meta_value])
        .where(_meta_name.equal("schema version"))
        .executeScalar();
    //
    return tmp == null ? -1 : tmp as int;
  }

  //#endregion

  //#region schema updates
  List<SchemaUpdate> schemaUpdates = <SchemaUpdate>[];

  void addSchemaUpdate(SchemaUpdate su) {
    schemaUpdates.add(su);
  }

  void addSchemaUpdateObjects(List<DbObject> dbObjs) {
    schemaUpdates.add(new SchemaUpdate(dbObjs));
  }

  Future<void> _setSchemaVersion(DbContext dbc, int version) async {
    await dbc.update(_tbl_meta).Set([_meta_value.value(version)]).Where(_meta_name.equal("schema version")).execute();
  }

  //#endregion

}
