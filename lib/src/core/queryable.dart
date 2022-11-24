part of datasource_core;

/// <summary>
/// a Queryable is any form may be used to select from such as (Table, View, JoinTable, SelectStatement)
/// </summary>
abstract class Queryable {
  String _sqlInSelect();

  //#region join types

  JoinTable InnerJoin(Queryable t, Expr on) {
    return new JoinTable._(this, JoinType.inner, t, on);
  }

  JoinTable OuterJoin(Queryable t, Expr on) {
    return new JoinTable._(this, JoinType.full, t, on);
  }

  JoinTable CrossJoin(Queryable t, Expr on) {
    return new JoinTable._(this, JoinType.cross, t, on);
  }

  JoinTable LeftJoin(Queryable t, Expr on) {
    return new JoinTable._(this, JoinType.left, t, on);
  }

  JoinTable RightJoin(Queryable t, Expr on) {
    return new JoinTable._(this, JoinType.right, t, on);
  }

  //#endregion

  late List<FieldInfo> fieldsInfo;
}

/// <summary>
/// a table or a view in the database
/// </summary>
abstract class DbTable extends Queryable implements DbObject {
  late final String name;
  late final AbsDatabase db;

  @override
  String _sqlInSelect() {
    return "`${this.name}`";
  }

// abstract
  String createCommand();
}
