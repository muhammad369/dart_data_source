import 'dart:core';

import '../../dart_data_source.dart';

/// <summary>
/// a Queryable is any form may be used to select from such as (Table, View, JoinTable, SelectStatement)
/// </summary>
abstract class Queryable {
  String sqlInSelect();

  //#region join types

  JoinTable InnerJoin(Queryable t, Expr on) {
    return new JoinTable(this, JoinType.inner, t, on);
  }

  JoinTable OuterJoin(Queryable t, Expr on) {
    return new JoinTable(this, JoinType.full, t, on);
  }

  JoinTable CrossJoin(Queryable t, Expr on) {
    return new JoinTable(this, JoinType.cross, t, on);
  }

  JoinTable LeftJoin(Queryable t, Expr on) {
    return new JoinTable(this, JoinType.left, t, on);
  }

  JoinTable RightJoin(Queryable t, Expr on) {
    return new JoinTable(this, JoinType.right, t, on);
  }

  //#endregion

  late List<FieldInfo> fieldsInfo;
}

/// <summary>
/// a table or a view in the database
/// </summary>
abstract class DbTable extends Queryable implements DbObject {
  late String name;
  late Database db;

  @override
  String sqlInSelect() {
    return "`${this.name}`";
  }

// abstract
  String createCommand();
}
