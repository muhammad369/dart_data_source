import '../../dart_data_source.dart';

class InsertStatement extends NonQueryStatement {
  late List<Assignment> assigns;

  InsertStatement(DbContext dbc, Table tbl) {
    this.dbc = dbc;
    this.tbl = tbl;
  }

  InsertStatement Values(List<Assignment> assigns) {
    this.assigns = assigns;
    return this;
  }


  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("INSERT INTO `${tbl.name}` ( ");
    //fields
    for (Assignment asn in assigns) {
      sb.write("`${asn.cln.name}` ,");
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
  Future<int> execute([DbContext? dbc]) {
    return (dbc ?? this.dbc).executeInsert(this);
  }
  
}

class Assignment {
  late Column cln;
  late Expr val;

  Assignment(Column cln, Expr value) {
    this.cln = cln;
    this.val = value;
  }

  String toSql(Statement st) {
    return "`${cln.name}` = (${val.toSql(st)})";
  }
}
