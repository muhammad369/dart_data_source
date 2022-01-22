import '../../dart_data_source.dart';

class InsertStatement extends NonQueryStatement {
  late List<Assignment> assigns;

  InsertStatement(Table tbl) {
    this.tbl = tbl;
  }

  InsertStatement Values(List<Assignment> assigns) {
    this.assigns = assigns;
    return this;
  }

  InsertStatement ValuesMap(Map<String, dynamic> map) {
    this.assigns = map.entries.map<Assignment>((item) => new Assignment(item.key, new ValueExpr(item.value))).toList();
    return this;
  }

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("INSERT INTO `${tbl.name}` ( ");
    //fields
    for (Assignment asn in assigns) {
      sb.write("`${asn.clnName}` ,");
    }
    var sbt = sb.toString().removeLastChar();
    sb.clear();
    sb.write(sbt);
    sb.write(") VALUES (");
    //values
    for (Assignment asn in assigns) {
      sb.write("${asn.val.toSql(this)} ,");
    }

    return sb.toString().removeLastChar() + ")";
  }

  @override
  Future<int> execute(DbContext dbc) {
    return dbc.executeInsert(this);
  }
}

class Assignment {
  late String clnName;
  late Expr val;

  Assignment(String cln, Expr value) {
    this.clnName = cln;
    this.val = value;
  }

  String toSql(Statement st) {
    return "`$clnName` = (${val.toSql(st)})";
  }
}
