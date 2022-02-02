part of datasource_core;

enum JoinType { inner, left, right, full, cross }

class JoinTable extends Queryable {
  late Queryable _tbl1, _tbl2;
  late Expr _on;
  late JoinType _join;

  static List<String> _joinNames = <String>[]
    ..addAll(["INNER", "LEFT OUTER", "RIGHT OUTER", "FULL OUTER", "CROSS"]);

  @override
  String sqlInSelect() {
    return "(${_tbl1.sqlInSelect()}) ${_joinNames[_join.index]} JOIN (${_tbl2.sqlInSelect()}) ON (${_on.toSql(null)})";
  }

  JoinTable._(Queryable t1, JoinType j, Queryable t2, Expr on) {
    this._tbl1 = t1;
    this._tbl2 = t2;
    this._join = j;
    this._on = on;
  }

  @override
  List<FieldInfo> get fieldsInfo {
    var tmp = <FieldInfo>[];
    _tbl1.fieldsInfo.forEach((element) => tmp.add(element));
    _tbl2.fieldsInfo.forEach((element) => tmp.add(element));
    return tmp;
  }
}
