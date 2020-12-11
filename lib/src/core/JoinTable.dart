import '../../dart_data_source.dart';

enum JoinType { inner, left, right, full, cross }

class JoinTable extends AbsTable {
  AbsTable Tbl1, tbl2;
  Expr on;
  JoinType join;
  static List<String> joinNames = new List<String>()
    ..addAll(["INNER", "LEFT OUTER", "RIGHT OUTER", "FULL OUTER", "CROSS"]);

  @override
  String sqlInSelect() {
    return "({0}) {1} JOIN ({2}) ON ({3})".format([
      Tbl1.sqlInSelect(),
      joinNames[join as int],
      tbl2.sqlInSelect(),
      on.toSql(null)
    ]);
  }

  JoinTable(AbsTable t1, JoinType j, AbsTable t2, Expr on) {
    this.Tbl1 = t1;
    this.tbl2 = t2;
    this.join = j;
    this.on = on;
  }

  @override
  List<FieldInfo> get fieldsInfo {
    var tmp = new List<FieldInfo>();
    tmp.addAll(Tbl1.fieldsInfo);
    tmp.addAll(tbl2.fieldsInfo);
    return tmp;
  }
}
