import 'dart:core';

import '../../dart_data_source.dart';

/// <summary>
/// an abstract table is any form may be used to select from as Table, View, JoinTable, SelectStatement
/// </summary>
abstract class AbsTable {
  String sqlInSelect();

  //#region join types

  JoinTable innerJoin(AbsTable t, Expr on) {
    return new JoinTable(this, JoinType.inner, t, on);
  }

  JoinTable outerJoin(AbsTable t, Expr on) {
    return new JoinTable(this, JoinType.full, t, on);
  }

  JoinTable crossJoin(AbsTable t, Expr on) {
    return new JoinTable(this, JoinType.cross, t, on);
  }

  JoinTable leftJoin(AbsTable t, Expr on) {
    return new JoinTable(this, JoinType.left, t, on);
  }

  JoinTable rightJoin(AbsTable t, Expr on) {
    return new JoinTable(this, JoinType.right, t, on);
  }

  //#endregion

  List<FieldInfo> fieldsInfo;
}

/// <summary>
/// a table or a view in the database
/// </summary>
abstract class DbTable extends AbsTable implements DbObject {
  String name;
  Database db;

  @override
  String sqlInSelect() {
    return "`${this.name}`";
  }

// abstract
  String createCommand();
}
