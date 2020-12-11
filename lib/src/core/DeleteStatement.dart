import '../../dart_data_source.dart';

class DeleteStatement extends NonQueryStatement {
  Expr cond;

  DeleteStatement(Database db, Table tbl) {
    this.db = db;
    this.tbl = tbl;
  }

  DeleteStatement where(Expr cond) {
    this.cond = cond;
    return this;
  }

  @override
  Future<int> execute() {
    return db.executeDelete(this);
  }

  @override
  String toSql() {
    StringBuffer sb = new StringBuffer();
    sb.write("DELETE FROM `${tbl.name}`");
    if (cond != null) {
      sb.write(" WHERE (${cond.toSql(this)})");
    }
    return sb.toString();
  }
}
