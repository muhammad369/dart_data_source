import '../../dart_data_source.dart';

class InsertStatement extends NonQueryStatement {
  List<Assignment> assigns;

  InsertStatement(Database db, Table tbl) {
    this.db = db;
    this.tbl = tbl;
  }

  InsertStatement Values(List<Assignment> assigns) {
    this.assigns = assigns;
    return this;
  }


  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("INSERT INTO `{0}` ( ".format([tbl.name]));
    //fields
    for (Assignment asn in assigns) {
      sb.write("`{0}` ,".format([asn.cln.name]));
    }
    var sbt = sb.toString().removeLastChar();
    sb.clear();
    sb.write(sbt);
    sb.write(") VALUES (");
    //values
    for (Assignment asn in assigns) {
      sb.write("{0} ,".format([asn.val.toSql(this)]));
    }

    return sb.toString().removeLastChar() + ")";
  }


  @override
  Future<int> execute() {
    return db.executeInsert(this);
  }
  
}

class Assignment {
  Column cln;
  Expr val;

  Assignment(Column cln, Expr value) {
    this.cln = cln;
    this.val = value;
  }

  String toSql(Statement st) {
    return "`{0}` = ({1})".format([cln.name, val.toSql(st)]);
  }
}
