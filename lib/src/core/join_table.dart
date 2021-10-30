import '../../dart_data_source.dart';

enum JoinType { inner, left, right, full, cross }

class JoinTable extends AbsTable {
  late AbsTable tbl1, tbl2;
  late Expr on;
  late JoinType join;

  static List<String> joinNames = <String>[]
    ..addAll(["INNER", "LEFT OUTER", "RIGHT OUTER", "FULL OUTER", "CROSS"]);

  @override
  String sqlInSelect() {
    return "({0}) {1} JOIN ({2}) ON ({3})".format([
      tbl1.sqlInSelect(),
      joinNames[join.index],
      tbl2.sqlInSelect(),
      on.toSql(null)
    ]);
  }

  JoinTable(AbsTable t1, JoinType j, AbsTable t2, Expr on) {
    this.tbl1 = t1;
    this.tbl2 = t2;
    this.join = j;
    this.on = on;
  }

  @override
  List<FieldInfo> get fieldsInfo {
    var tmp = <FieldInfo>[];
    tbl1.fieldsInfo!.forEach((element) => tmp.add(element));
    tbl2.fieldsInfo!.forEach((element) => tmp.add(element));
    return tmp;
  }
}